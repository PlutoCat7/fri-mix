//
//  GBGuestGameCompeleteViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGuestGameCompeleteViewController.h"

#import "GBHightLightButton.h"
#import "GBGameTimePicker.h"
#import "GBGuestGameCompletePreview.h"
#import "GamePhotoSelectView.h"
#import "GameVideoSelectView.h"

#import "MatchRequest.h"
#import "MatchLogic.h"
#import "MatchGamePhotosUploadManager.h"

typedef enum {
    TimeType_FirstHalf = 0,
    TimeType_SecondHalf = 1
}TimeType;

@interface GBGuestGameCompeleteViewController ()<
GBGameTimePickerDelegate,
GamePhotoSelectViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
// 比赛日期
@property (weak, nonatomic) IBOutlet UILabel *gameDateLabel;
// 常规赛上半场开始时间
@property (weak, nonatomic) IBOutlet UILabel *nomalFirstHalfBeginTimeLabel;
// 常规赛上半场结束时间
@property (weak, nonatomic) IBOutlet UILabel *nomalFirstHalfEndTimeLabel;
// 常规赛下半场开始时间
@property (weak, nonatomic) IBOutlet UILabel *nomalSecondHalfBeginTimeLabel;
// 常规赛下半场结束时间
@property (weak, nonatomic) IBOutlet UILabel *nomalSecondHalfEndTimeLabel;

// OK按钮
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) GBGameTimePicker *timePicker;
@property (nonatomic, strong) MatchDoingInfo *matchInfo;
@property (nonatomic, assign) NSInteger currentSelectIndex;

// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *matchDateStLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameStLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginStLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstStLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondStLabel;

@property (assign, nonatomic)  NSInteger deviceBegin;
@property (assign, nonatomic)  NSInteger deviceFinish;
@property (weak, nonatomic) IBOutlet UILabel *deviationLabel;
@property (weak, nonatomic) IBOutlet UIView *gameTimeView;
@property (weak, nonatomic) IBOutlet GamePhotoSelectView *gamePhotoView;
@property (weak, nonatomic) IBOutlet GameVideoSelectView *gameVideoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameTimeHeightConstraints;

@property (nonatomic, strong) MatchGamePhotosUploadManager *uploadManager;

@end

@implementation GBGuestGameCompeleteViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

-(void)localizeUI{
    self.matchDateStLabel.text = LS(@"post.label.date");
    self.gameStLabel.text = LS(@"post.label.game");
    self.beginStLabel.text = LS(@"post.label.begin.time");
    self.endStLabel.text = LS(@"post.label.finish.time");
    self.firstStLabel.text = LS(@"post.label.first");
    self.secondStLabel.text = LS(@"post.label.second");
}
- (instancetype)initWithMatchInfo:(MatchDoingInfo *)matchInfo {
    
    if(self=[super init]){
        
        _matchInfo = matchInfo;
    }
    return self;
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

#pragma mark - Delegate

-(void)GBGameTimePicker:(GBGameTimePicker*)picker startHour:(NSInteger)startHour startMin:(NSInteger)startMin endHour:(NSInteger)endHour endMin:(NSInteger)endMin {
    if (self.currentSelectIndex == TimeType_FirstHalf) {
        NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", startHour, startMin];
        NSString *endTime = [NSString stringWithFormat:@"%02zd:%02zd", endHour, endMin];
        
        self.nomalFirstHalfBeginTimeLabel.text = startTime;
        self.nomalFirstHalfEndTimeLabel.text = endTime;
        
    } else if (self.currentSelectIndex == TimeType_SecondHalf) {
        NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", startHour, startMin];
        NSString *endTime = [NSString stringWithFormat:@"%02zd:%02zd", endHour, endMin];
        
        self.nomalSecondHalfBeginTimeLabel.text = startTime;
        self.nomalSecondHalfEndTimeLabel.text = endTime;
    }
    [self checkInputValid];
}

#pragma mark GamePhotoSelectViewDelegate

- (void)mediaCountChange:(BOOL)isAdd view:(GamePhotoSelectView *)view {
    
    [self viewLayoutChange];
}

#pragma mark - Action

// 点击设置常规赛上半场时间
- (IBAction)actionNomalFirstTimeSetting:(id)sender {
    
    [self.view endEditing:YES];
    self.currentSelectIndex = TimeType_FirstHalf;
    
    NSDate *firstStartDate = [self dateWithTime:self.nomalFirstHalfBeginTimeLabel.text];
    NSDate *firstEndDate = [self dateWithTime:self.nomalFirstHalfEndTimeLabel.text];
    NSInteger startH = [firstStartDate hour];
    NSInteger startM = [firstStartDate minute];
    NSInteger endH = [firstEndDate hour];
    NSInteger endM = [firstEndDate minute];
    
    self.timePicker = [GBGameTimePicker showWithSelectIndex:startH startMin:startM endHour:endH endMin:endM];
    self.timePicker.delegate = self;
}

// 点击设置常规赛下半场时间
- (IBAction)actionNomalSecondTimeSetting:(id)sender {
    
    [self.view endEditing:YES];
    self.currentSelectIndex = TimeType_SecondHalf;
    
    NSDate *firstStartDate = [self dateWithTime:self.nomalSecondHalfBeginTimeLabel.text];
    NSDate *firstEndDate = [self dateWithTime:self.nomalSecondHalfEndTimeLabel.text];
    NSInteger startH = [firstStartDate hour];
    NSInteger startM = [firstStartDate minute];
    NSInteger endH = [firstEndDate hour];
    NSInteger endM = [firstEndDate minute];
    
    self.timePicker = [GBGameTimePicker showWithSelectIndex:startH startMin:startM endHour:endH endMin:endM];
    self.timePicker.delegate = self;
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"post.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self updateTimeUI];
    [self setupNavigationRightItem];
    
    [self checkInputValid];
    
    self.gamePhotoView.maxImageCount = 7;
    self.gamePhotoView.superViewController = self;
    self.gamePhotoView.delegate = self;
    
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
        NSDate *firstStartDate = [self dateWithTime:self.nomalFirstHalfBeginTimeLabel.text];
        NSDate *firstEndDate = [self dateWithTime:self.nomalFirstHalfEndTimeLabel.text];
        NSDate *secondStartDate = [self dateWithTime:self.nomalSecondHalfBeginTimeLabel.text];
        NSDate *secondEndDate = [self dateWithTime:self.nomalSecondHalfEndTimeLabel.text];
        
        NSInteger gameTime = [firstEndDate minutesAfterDate:firstStartDate] + [secondEndDate minutesAfterDate:secondStartDate];
        NSArray *dataList = @[@(gameTime).stringValue, self.nomalFirstHalfBeginTimeLabel.text, self.nomalFirstHalfEndTimeLabel.text, self.nomalSecondHalfBeginTimeLabel.text, self.nomalSecondHalfEndTimeLabel.text];
        @weakify(self)
        [GBGuestGameCompletePreview showWithComplete:^(NSInteger index) {
            
            @strongify(self)
            if (index == 1) {
                [self uploadPhotos];
            }
        } dataList:dataList];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.enabled = NO;
    self.okButton = menuBtn;
}

- (void)viewLayoutChange {
    
    //计算提示文本的高度
    if ([NSString stringIsNullOrEmpty:self.deviationLabel.text]) {
        self.gameTimeHeightConstraints.constant = 105*kAppScale;
    }else {
        self.gameTimeHeightConstraints.constant = 105*kAppScale + 40;
    }

    self.gamePhotoView.top = self.gameTimeHeightConstraints.constant + self.gameTimeView.top;
    self.gameVideoView.top = self.gamePhotoView.bottom;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.gameVideoView.bottom + 40);
    
    [self.contentScrollView layoutIfNeeded];
}

- (void)updateTimeUI {
    
    NSInteger beginTime = self.matchInfo.matchBeginTime;
    NSInteger finishTime = self.matchInfo.matchEndTime;
    NSInteger middleTime = (beginTime + finishTime) / 2;
    
    self.deviceBegin  = beginTime;
    self.deviceFinish = finishTime;
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"HH:mm"];
    
    NSString *begin = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:beginTime]];
    NSString *middle = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:middleTime]];
    NSString *finish = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:finishTime]];
    
    self.nomalFirstHalfBeginTimeLabel.text = begin;
    self.nomalFirstHalfEndTimeLabel.text = middle;
    self.nomalSecondHalfBeginTimeLabel.text = middle;
    self.nomalSecondHalfEndTimeLabel.text = finish;
    
    dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy / MM / dd"];
    self.gameDateLabel.text = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:beginTime]];
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
    
    NSDate *firstStartDate = [self dateWithTime:self.nomalFirstHalfBeginTimeLabel.text];
    NSDate *firstEndDate = [self dateWithTime:self.nomalFirstHalfEndTimeLabel.text];
    NSDate *secondStartDate = [self dateWithTime:self.nomalSecondHalfBeginTimeLabel.text];
    NSDate *secondEndDate = [self dateWithTime:self.nomalSecondHalfEndTimeLabel.text];
    //判断是否有跨天
    if ([MatchLogic sectionsDateCompare:firstStartDate twoDate:secondEndDate]) {
        firstStartDate = [MatchLogic transferTomorrow:firstStartDate];
        firstEndDate = [MatchLogic transferTomorrow:firstEndDate];
        secondStartDate = [MatchLogic transferTomorrow:secondStartDate];
        secondEndDate = [MatchLogic transferTomorrow:secondEndDate];
    }
    
    self.matchInfo.firstStartTime = [firstStartDate timeIntervalSince1970];
    self.matchInfo.firstEndTime = [firstEndDate timeIntervalSince1970];
    self.matchInfo.secondStartTime = [secondStartDate timeIntervalSince1970];
    self.matchInfo.secondEndTime = [secondEndDate timeIntervalSince1970];
    
    [self showLoadingToast];
    @weakify(self)
    [MatchRequest guestCommitMatchComplete:self.matchInfo handler:^(id result, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"sync.tip.uploadok")];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeleteMatchSuccess object:nil];
        }
    }];
}

#pragma mark Logic

- (NSDate *)dateWithTime:(NSString *)timeString {
    
    NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
    [dateToStrFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *YMD = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.matchInfo.matchBeginTime]];
    
    NSDateFormatter *strToDataFormatter = [[NSDateFormatter alloc] init];
    [strToDataFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [strToDataFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", YMD, timeString]];
    
    return date;
}

- (void)checkInputValid {
    
    self.okButton.enabled =  [self calculateRateOfcoverage]!=0;
}

// 0-完全不匹配 1-偏移量超过50% 2- 偏移量小于50%或完全匹配

-(NSInteger)calculateRateOfcoverage
{
    self.deviationLabel.text = @"";
    
    
    NSDate *firstStartDate = [self dateWithTime:self.nomalFirstHalfBeginTimeLabel.text];
    NSDate *firstEndDate = [self dateWithTime:self.nomalFirstHalfEndTimeLabel.text];
    NSDate *secondStartDate = [self dateWithTime:self.nomalSecondHalfBeginTimeLabel.text];
    NSDate *secondEndDate = [self dateWithTime:self.nomalSecondHalfEndTimeLabel.text];
    
    NSInteger state1 = [MatchLogic sectionsDateCompare:firstStartDate twoDate:firstEndDate];
    NSInteger state2 = [MatchLogic sectionsDateCompare:firstEndDate twoDate:secondStartDate];
    NSInteger state3 = [MatchLogic sectionsDateCompare:secondStartDate twoDate:secondEndDate];
    if (state1 == 0 ||
        state2 == 0 ||
        state3 == 0) {
        self.deviationLabel.textColor = [UIColor colorWithHex:0xFF0012];
        self.deviationLabel.text = [NSString stringWithFormat:LS(@"post.tip.correct.time")];
        return 0;
    }
    
    NSInteger setBeginTime = firstStartDate.timeIntervalSince1970;
    NSInteger setEndTime = secondEndDate.timeIntervalSince1970;
    //判断是否跨天
    if ([MatchLogic sectionsDateCompare:firstStartDate twoDate:secondEndDate] == 1) {
        setEndTime = [secondEndDate dateByAddingDays:1].timeIntervalSince1970;
    }
    CGFloat rate = [self areaCalculateDeviceBegin:self.deviceBegin
                                        deviceEnd:self.deviceFinish
                                        userBegin:setBeginTime
                                          userEnd:setEndTime];
    
    if (([firstStartDate compare:firstEndDate] == NSOrderedDescending) || ([firstEndDate compare:secondStartDate] == NSOrderedDescending) || ([secondStartDate compare:secondEndDate] == NSOrderedDescending)) {
        self.deviationLabel.textColor = [UIColor colorWithHex:0xFF0012];
        self.deviationLabel.text = [NSString stringWithFormat:LS(@"post.tip.correct.time")];
        return 0;
        
    } else if (rate <= 0.001f) {
        NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
        [dateToStrFormatter setDateFormat:@"HH:mm"];
        
        NSString *begin = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.deviceBegin]];
        NSString *finish = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.deviceFinish]];
        
        self.deviationLabel.textColor = [UIColor colorWithHex:0xFF0012];
        self.deviationLabel.text = [NSString stringWithFormat:@"%@.%@%@-%@", LS(@"finish.label.timeerror"), LS(@"finish.label.record"), begin, finish];
        return 0;
        
    } else if(rate > 0 && rate <= 0.5) {
        NSDateFormatter *dateToStrFormatter = [[NSDateFormatter alloc] init];
        [dateToStrFormatter setDateFormat:@"HH:mm"];
        
        NSString *begin = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.deviceBegin]];
        NSString *finish = [dateToStrFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.deviceFinish]];
        
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

@end
