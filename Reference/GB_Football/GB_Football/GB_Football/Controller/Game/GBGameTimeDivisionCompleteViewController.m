//
//  GBGameTimeDivisionCompleteViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTimeDivisionCompleteViewController.h"

#import "GBGameTimeDivisionHeaderView.h"
#import "GBGameTimeDivisionTableViewCell.h"
#import "GBGameTimeDivisionFooterView.h"
#import "GBHightLightButton.h"
#import "GBCourseMask.h"
#import "NoReMindManager.h"
#import "GBGameScorePicker.h"
#import "GBGameTimePicker.h"
#import "GBGameTimeDivisionCompletePreview.h"
#import "GBRecordListViewController.h"
#import "GamePhotoSelectView.h"
#import "GameVideoSelectView.h"

#import "MatchRequest.h"
#import "MatchLogic.h"
#import "MatchGamePhotosUploadManager.h"

#define kMaxTeamNameLength  20
#define kMaxTimeDivisionCount 5

@interface GBGameTimeDivisionCompleteViewController () <UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
GBGameTimeDivisionFooterViewDelegate,
GBGameScorePickerDelegate,
GBGameTimePickerDelegate,
GamePhotoSelectViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviationLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GBGameTimeDivisionFooterView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITextField *homeTeamNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *guestTeamNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *homeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestScoreLabel;
@property (strong, nonatomic) UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *deviationLabel;
@property (weak, nonatomic) IBOutlet GBCourseMask *courseMask;
@property (weak, nonatomic) IBOutlet UIView *gameTimeView;
@property (weak, nonatomic) IBOutlet UIView *gameTeamNameView;
@property (weak, nonatomic) IBOutlet UIView *gameScoreView;
@property (weak, nonatomic) IBOutlet GamePhotoSelectView *gamePhotoView;
@property (weak, nonatomic) IBOutlet GameVideoSelectView *gameVideoView;

// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *matchDateStLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitingTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *ourStLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppStLabel;

@property (nonatomic, strong) MatchDoingInfo *matchInfo;
@property (nonatomic, strong) NSMutableArray<TimeDivisionRecordInfo *> *timeDivisionList;
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, strong) MatchGamePhotosUploadManager *uploadManager;

@end

@implementation GBGameTimeDivisionCompleteViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)localizeUI{
    self.matchDateStLabel.text = LS(@"post.label.date");
    self.homeTeamLabel.text = LS(@"multi-section.home.team.name");
    self.visitingTeamLabel.text = LS(@"multi-section.visiting.team.name");
    self.ourStLabel.text = LS(@"post.label.our.score");
    self.oppStLabel.text = LS(@"post.label.opp.score");
}

- (instancetype)initWithMatchInfo:(MatchDoingInfo *)info {
    
    self = [super init];
    if (self) {
        self.matchInfo = info;
        self.timeDivisionList = [[NSMutableArray alloc]initWithArray:info.timeDivisionRecordList copyItems:YES];
        for (TimeDivisionRecordInfo *info in self.matchInfo.timeDivisionRecordList) { //修改为比赛日期
            [self transferToMatchDate:info];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self viewLayoutChange];
    });
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Create_Setting;
}

#pragma mark - NSNotificaion

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkInputValid];
}

// 字数限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.homeTeamNameTextField == textField) {
        if([self.homeTeamNameTextField.text length] >= kMaxTeamNameLength && range.length != 1)return NO;
    }
    if (self.guestTeamNameTextField == textField) {
        if([self.guestTeamNameTextField.text length] >= kMaxTeamNameLength && range.length != 1)return NO;
    }
    
    return YES;
}

// Done键盘回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action
- (IBAction)actionSetScore:(id)sender {
    
    GBGameScorePicker *scorePicker = [GBGameScorePicker showWithOurSelectIndex:self.homeScoreLabel.text.integerValue oppSelectIndex:self.guestScoreLabel.text.integerValue];
    scorePicker.delegate = self;
}

#pragma mark - Private

- (void)loadData {
    
    if (self.timeDivisionList.count == 0) { //未打卡，自动生成一节
        TimeDivisionRecordInfo *info = [TimeDivisionRecordInfo new];
        info.section = 0;
        info.beginDate = [NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchBeginTime];
        info.endDate = [NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchEndTime];
        //去除秒
        [self transferToMatchDate:info];
        [self.timeDivisionList addObject:info];
    }else {
        TimeDivisionRecordInfo *info = self.timeDivisionList.lastObject;
        if (!info.endDate) {
            info.endDate = [NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchEndTime];
        }else if (!info.beginDate) {
            if (self.timeDivisionList.count == 1) {
                info.beginDate = [NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchBeginTime];
            }else {
                TimeDivisionRecordInfo *tmpInfo = self.timeDivisionList[self.timeDivisionList.count - 2];
                info.beginDate = tmpInfo.endDate;
            }
        }
    }
}

-(void)setupUI
{
    self.title = LS(@"post.nav.title");
    [self setupBackButtonWithBlock:nil];
    if ([NoRemindManager sharedInstance].tutorialMaskCompletGame == NO)
    {
        [self.courseMask showWithType:COURSE_MASK_COMPLETE];
    }
    [self setupNavigationRightItem];
    
    [self setupTableView];
    [self setupTextField];
    [self updateTimeUI];
    [self checkCanAddOrDelete];
    [self checkInputValid];
    
    self.gamePhotoView.maxImageCount = 7;
    self.gamePhotoView.delegate = self;
    self.gamePhotoView.superViewController = self;
    
    self.gameVideoView.maxVideoCount = 1;
    self.gameVideoView.superViewController = self;
}

- (void)setupNavigationRightItem {
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 60, 40);
    [menuBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [menuBtn setTitleColor:[ColorManager disableColor] forState:UIControlStateDisabled];
    menuBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [menuBtn setTitle:LS(@"game.complete.done") forState:UIControlStateNormal];
    @weakify(self)
    [menuBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        
        //收起键盘
        [self.view endEditing:YES];
        NSInteger weScore= [self.homeScoreLabel.text integerValue];
        NSInteger otherScore = [self.guestScoreLabel.text integerValue];
        NSMutableArray *sectionDateList = [NSMutableArray arrayWithCapacity:1];
        for (TimeDivisionRecordInfo *info in self.timeDivisionList) {
            [sectionDateList addObject:@[info.beginDate, info.endDate]];
        }
        @weakify(self)
        [GBGameTimeDivisionCompletePreview showWithComplete:^(NSInteger index) {
            @strongify(self)
            if (index == 1) {
                [self uploadPhotos];
            }
        } sectionDateList:[sectionDateList copy] weScore:weScore oppScore:otherScore];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.enabled = NO;
    self.okButton = menuBtn;
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBGameTimeDivisionTableViewCell" bundle:nil] forCellReuseIdentifier:@"GBGameTimeDivisionTableViewCell"];
    
    GBGameTimeDivisionHeaderView *tmpView = [[[NSBundle mainBundle] loadNibNamed:@"GBGameTimeDivisionHeaderView" owner:self options:nil] firstObject];
    tmpView.frame = CGRectMake(0, 0, kUIScreen_Width, 25*kAppScale);
    self.tableView.tableHeaderView = tmpView;
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"GBGameTimeDivisionFooterView" owner:self options:nil] firstObject];
    self.footerView.frame = CGRectMake(0, 0, kUIScreen_Width, 50*kAppScale);
    self.footerView.delegate = self;
    self.tableView.tableFooterView = self.footerView;
    
    [self viewLayoutChange];
}

- (void)setupTextField {
    
    self.homeTeamNameTextField.delegate = self;
    self.guestTeamNameTextField.delegate = self;
    self.homeTeamNameTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                        initWithString:LS(@"multi-section.home.team.name.placehold")
                                                        attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x909090]}];
    self.guestTeamNameTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                         initWithString:LS(@"multi-section.visiting.team.name.placehold")
                                                         attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x909090]}];
    self.homeTeamNameTextField.text = self.matchInfo.host_team;
    self.guestTeamNameTextField.text = self.matchInfo.follow_team;
}

- (void)updateTimeUI {
    
    long beginTime = self.matchInfo.matchBeginTime;
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy / MM / dd"];
    self.dateLabel.text = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:beginTime]];
}

- (void)uploadPhotos {
    
    NSMutableArray *uploadList = [NSMutableArray arrayWithArray:[self.gamePhotoView getMatchImageUploadObjectList]];
    [uploadList addObjectsFromArray:[self.gameVideoView getMatchVideoUploadObjectList]];
    if (uploadList.count == 0) {  //没有上传图片和视频，直接完成比赛
        [self finishMatch];
        return;
    }
    
    self.uploadManager = [[MatchGamePhotosUploadManager alloc] initWithUploadObjectList:[uploadList copy]];
    __block NSMutableArray *imgUriList = [NSMutableArray arrayWithCapacity:1];
    __block NSMutableArray *videoUriList = [NSMutableArray arrayWithCapacity:1];
    __block NSInteger step = 0;
    [self showLoadingToastWithText:[NSString stringWithFormat:@"%@ %td/%td", LS(@"game.complete.upload.photo"), step, uploadList.count]];
    @weakify(self)
    [self.uploadManager startUploadWithBlock:^(MatchGamePhotoUploadObject *uploadObject, BOOL isSucess, NSString *successUri) {
        
        step++;
        @strongify(self)
        if (isSucess) {
            [self showLoadingToastWithText:[NSString stringWithFormat:@"%@ %td/%td", LS(@"game.complete.upload.photo"), step, uploadList.count]];
            if (uploadObject.type == 1) {
                [videoUriList addObject:successUri];
            }else {
                [imgUriList addObject:successUri];
            }
            if (uploadList.lastObject == uploadObject) {//最后一步且上传成功， 进入下一步
                self.matchInfo.uriList = [imgUriList copy];
                self.matchInfo.videoUriList = [videoUriList copy];
                [self finishMatch];
            }
        }else {
            [self showToastWithText:LS(@"game.complete.upload.fail")];
        }
    }];
}

- (void)finishMatch {
    
    NSInteger weScore= [self.homeScoreLabel.text integerValue];
    NSInteger otherScore = [self.guestScoreLabel.text integerValue];
    
    self.matchInfo.homeScore = weScore;
    self.matchInfo.guestScore = otherScore;
    //判断是否存在跨天
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    TimeDivisionRecordInfo *first = self.timeDivisionList.firstObject;
    TimeDivisionRecordInfo *last = self.timeDivisionList.lastObject;
    if ([MatchLogic sectionsDateCompare:first.beginDate twoDate:last.endDate] == 1) { //跨天
        for (TimeDivisionRecordInfo *olfInfo in self.timeDivisionList) {
            TimeDivisionRecordInfo *recordInfo = [[TimeDivisionRecordInfo alloc] init];
            recordInfo.section = olfInfo.section;
            recordInfo.beginDate = [MatchLogic transferTomorrow:olfInfo.beginDate];
            recordInfo.endDate = [MatchLogic transferTomorrow:olfInfo.endDate];
            [result addObject:recordInfo];
        }
    }else {
        result = [NSMutableArray arrayWithArray:self.timeDivisionList];
    }
    self.matchInfo.timeDivisionRecordList = [result copy];
    self.matchInfo.host_team = [self.homeTeamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.matchInfo.follow_team = [self.guestTeamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([NSString stringIsNullOrEmpty:self.matchInfo.follow_team]) {
        self.matchInfo.follow_team = LS(@"pre.hint.opponment");
    }
    
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest commitTimeDivisionMatchComplete:self.matchInfo handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[RawCacheManager sharedRawCacheManager].userInfo clearMatchInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_FinishMatchSuccess object:nil];
            
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            if (viewControllers.count>1) {
                [viewControllers removeObjectsInRange:NSMakeRange(1, viewControllers.count - 1)];
            }
            [viewControllers addObject:[[GBRecordListViewController alloc] init]];
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
    }];
}

#pragma mark Logic

- (void)checkInputValid {
    
    NSString *host_team = [self.homeTeamNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    self.okButton.enabled = host_team.length>0 && [self calculateRateOfcoverage]!=0;
}

// 0-完全不匹配 1-偏移量超过50% 2- 偏移量小于50%或完全匹配

-(NSInteger)calculateRateOfcoverage
{
    if (self.timeDivisionList.count == 0) {
        self.deviationLabel.text = @"";
        return 0;
    }
    
    NSArray *errorTipsList = @[LS(@"multi-section.setting.error.one"),
                                 LS(@"multi-section.setting.error.two"),
                                 LS(@"multi-section.setting.error.three"),
                                 LS(@"multi-section.setting.error.four"),
                                 LS(@"multi-section.setting.error.five")];
    for (TimeDivisionRecordInfo *info in self.timeDivisionList) {//每一节判断
        if ((!info.beginDate || !info.endDate)) {
            self.deviationLabel.textColor = [UIColor colorWithHex:0xFF0012];
            NSInteger section = [self.timeDivisionList indexOfObject:info];
            self.deviationLabel.text = errorTipsList[section];
            return 0;
        }else {
            if ([MatchLogic sectionsDateCompare:info.beginDate twoDate:info.endDate] == 0) {
                self.deviationLabel.textColor = [UIColor colorWithHex:0xFF0012];
                NSInteger section = [self.timeDivisionList indexOfObject:info];
                self.deviationLabel.text = errorTipsList[section];
                return 0;
            }
        }
    }
    for (NSInteger index=0; index<self.timeDivisionList.count; index++) {//相邻节判断
        if (index>0) {
            TimeDivisionRecordInfo *current = self.timeDivisionList[index];
            TimeDivisionRecordInfo *last = self.timeDivisionList[index-1];
            if ([MatchLogic sectionsDateCompare:last.endDate twoDate:current.beginDate] == 0) {
                self.deviationLabel.textColor = [UIColor colorWithHex:0xFF0012];
                self.deviationLabel.text = errorTipsList[index];
                return 0;
            }
        }
    }

    NSInteger setBeginTime = [self.timeDivisionList.firstObject beginDate].timeIntervalSince1970;
    NSInteger setEndTime = [self.timeDivisionList.lastObject endDate].timeIntervalSince1970;
    //判断是否跨天
    if ([MatchLogic sectionsDateCompare:self.timeDivisionList.firstObject.beginDate twoDate:self.timeDivisionList.lastObject.endDate] == 1) {
        setEndTime = [[self.timeDivisionList.lastObject endDate] dateByAddingDays:1].timeIntervalSince1970;
    }
    CGFloat rate = [self areaCalculateDeviceBegin:self.matchInfo.matchBeginTime deviceEnd:self.matchInfo.matchEndTime
                                        userBegin:setBeginTime userEnd:setEndTime];
    if (rate <= 0.001f) {
        NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
        [dateToStrFormatter setDateFormat:@"HH:mm"];
        
        NSString *begin = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchBeginTime]];
        NSString *finish = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchEndTime]];
        
        self.deviationLabel.textColor = [UIColor colorWithHex:0xFF0012];
        self.deviationLabel.text = [NSString stringWithFormat:@"%@.%@%@-%@", LS(@"finish.label.timeerror"), LS(@"finish.label.record"), begin, finish];
        return 0;
        
    } else if(rate > 0 && rate <= 0.5) {
        NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
        [dateToStrFormatter setDateFormat:@"HH:mm"];
        
        NSString *begin = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchBeginTime]];
        NSString *finish = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchEndTime]];
        
        self.deviationLabel.textColor = [UIColor colorWithHex:0xFFD144];
        self.deviationLabel.text = [NSString stringWithFormat:@"%@.%@%@-%@", LS(@"finish.label.timewarning"), LS(@"finish.label.record"), begin, finish];
        return 1;
    }
    self.deviationLabel.text = @"";
    return 2;
}

// 区间重叠算法
-(CGFloat)areaCalculateDeviceBegin:(NSInteger)deviceBegin
                         deviceEnd:(NSInteger)deviceEnd
                         userBegin:(NSInteger)userBegin
                           userEnd:(NSInteger)userEnd
{
    NSInteger begin = MAX(deviceBegin,userBegin);
    NSInteger end   = MIN(deviceEnd,userEnd);
    NSInteger len   = end - begin;
    CGFloat rate = 0.f;
    rate = len*1.f / (userEnd - userBegin);
    return rate;
}

- (void)viewLayoutChange {
    
    BOOL isTips = ![NSString stringIsNullOrEmpty:self.deviationLabel.text];
    self.deviationLabelHeightConstraint.constant = isTips?40:0;
    self.tableViewConstraint.constant = 75*kAppScale + 34*self.timeDivisionList.count*kAppScale + self.deviationLabelHeightConstraint.constant;
    self.gamePhotoView.top = self.tableViewConstraint.constant + self.gameTimeView.top + self.gameTeamNameView.height + self.gameScoreView.height + 15*kAppScale;
    self.gameVideoView.top = self.gamePhotoView.bottom;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.gameVideoView.bottom + 40);
    self.containerViewConstraint.constant = self.scrollView.contentSize.height;
    self.containerViewBottomConstraint.constant = self.scrollView.height - self.scrollView.contentSize.height;
}

- (NSDate *)dateWithTime:(NSString *)timeString {
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *YMD = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchBeginTime]];
    
    NSDateFormatter *strToDataFormatter = [[NSDateFormatter alloc] init];
    [strToDataFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [strToDataFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", YMD, timeString]];
    
    return date;
}

- (void)transferToMatchDate:(TimeDivisionRecordInfo *)recordInfo {
    
    NSString *timeString = [NSString stringWithFormat:@"%02zd:%02zd", recordInfo.beginDate.hour, recordInfo.beginDate.minute];
    recordInfo.beginDate = [self dateWithTime:timeString];
    
    timeString = [NSString stringWithFormat:@"%02zd:%02zd", recordInfo.endDate.hour, recordInfo.endDate.minute];
    recordInfo.endDate = [self dateWithTime:timeString];
}

- (void)checkCanAddOrDelete {
    
    if (self.timeDivisionList.count==0) {
        self.footerView.delButton.alpha = 0.2f;
        self.footerView.addButton.alpha = 1.0f;
    }else {
        if (self.timeDivisionList.count == kMaxTimeDivisionCount) {
            self.footerView.delButton.alpha = 1.0f;
            self.footerView.addButton.alpha = 0.2f;
        }else {
            self.footerView.delButton.alpha = 1.0f;
            self.footerView.addButton.alpha = 1.0f;
        }
    }
}

#pragma mark - Delegate

-(void)GBGameScorePicker:(GBGameScorePicker*)picker our:(NSInteger)our opp:(NSInteger)opp
{
    self.homeScoreLabel.text = @(our).stringValue;
    self.guestScoreLabel.text = @(opp).stringValue;
}

-(void)GBGameTimePicker:(GBGameTimePicker*)picker startHour:(NSInteger)startHour startMin:(NSInteger)startMin endHour:(NSInteger)endHour endMin:(NSInteger)endMin {
    GBGameTimeDivisionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectIndex inSection:0]];
    NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", startHour, startMin];
    NSString *endTime = [NSString stringWithFormat:@"%02zd:%02zd", endHour, endMin];
    
    cell.beginTimeLabel.text = startTime;
    cell.endTimeLabel.text = endTime;
    
    TimeDivisionRecordInfo *info = self.timeDivisionList[self.currentSelectIndex];
    info.beginDate = [self dateWithTime:startTime];
    info.endDate = [self dateWithTime:endTime];

    [self checkInputValid];
}

#pragma mark GBGameTimeDivisionFooterViewDelegate

- (void)didClickDelete {
    
    [UMShareManager event:Analy_Click_Game_DelQuar];
    
    [self.timeDivisionList removeLastObject];
    [self checkCanAddOrDelete];
    [self viewLayoutChange];
    [self.tableView reloadData];
    
    [self checkInputValid];
}

- (void)didClickAdd {
    
    [UMShareManager event:Analy_Click_Game_AddQuar];
    
    if (self.timeDivisionList.count < kMaxTimeDivisionCount) {
        
        TimeDivisionRecordInfo *info = [TimeDivisionRecordInfo new];
        NSInteger section = 0;
        if (self.timeDivisionList.count>0) {
            section = [self.timeDivisionList lastObject].section+1;
            info.beginDate = self.timeDivisionList.lastObject.endDate;
            info.endDate = info.beginDate;
        }else {
            info.beginDate = [NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchBeginTime];
            info.endDate = [NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchEndTime];
        }
        info.section = section;
        [self.timeDivisionList addObject:info];
        [self checkCanAddOrDelete];
        
        [self viewLayoutChange];
        [self.tableView reloadData];
        
        [self checkInputValid];
    }
}

#pragma mark GamePhotoSelectViewDelegate

- (void)mediaCountChange:(BOOL)isAdd view:(GamePhotoSelectView *)view {
    
    [self viewLayoutChange];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.timeDivisionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 34*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeDivisionRecordInfo *info = self.timeDivisionList[indexPath.row];
    NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", info.beginDate.hour, info.beginDate.minute];
    NSString *endTime = [NSString stringWithFormat:@"%02zd:%02zd", info.endDate.hour, info.endDate.minute];
    
    GBGameTimeDivisionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBGameTimeDivisionTableViewCell"];
    cell.beginTimeLabel.text = startTime;
    cell.endTimeLabel.text = endTime;
    NSDictionary *chineseDic = @{@"0":LS(@"multi-section.section.one"),
                                 @"1":LS(@"multi-section.section.two"),
                                 @"2":LS(@"multi-section.section.three"),
                                 @"3":LS(@"multi-section.section.four"),
                                 @"4":LS(@"multi-section.section.five")};
    cell.sectionNameLabel.text = chineseDic[@(info.section).stringValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [UMShareManager event:Analy_Click_Game_TimeQuar];
    
    self.currentSelectIndex = indexPath.row;
    TimeDivisionRecordInfo *info = self.timeDivisionList[indexPath.row];

    GBGameTimePicker *timePicker = [GBGameTimePicker showWithSelectIndex:info.beginDate.hour startMin:info.beginDate.minute endHour:info.endDate.hour endMin:info.endDate.minute];
    timePicker.delegate = self;
}

@end
