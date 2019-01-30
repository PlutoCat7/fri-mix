//
//  GBGameTimeDivisionRecordViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTimeDivisionRecordViewController.h"

#import "TimeDivisionRecordTableViewCell.h"
#import "GBGameTimeDivisionFooterView.h"
#import "TimeDivisionRecordTableViewHeaderView.h"
#import "GBSingleTimePicker.h"

#define kMaxTimeDivisionCount 5

@interface GBGameTimeDivisionRecordViewController ()<UITableViewDelegate,
UITableViewDataSource,
GBGameTimeDivisionFooterViewDelegate,
GBSingleTimePickerDelegate,
TimeDivisionRecordTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GBGameTimeDivisionFooterView *footerView;

//localizable

@property (nonatomic, strong) MatchDoingInfo *matchInfo;
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, assign) NSInteger timeIndex;

@end

@implementation GBGameTimeDivisionRecordViewController

- (void)dealloc
{
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.matchInfo.timeDivisionRecordList];
    TimeDivisionRecordInfo *info = [tmpList lastObject];
    if (info && (!info.beginDate&&!info.endDate)) {
        [tmpList removeLastObject];
        self.matchInfo.timeDivisionRecordList = [tmpList copy];
        [self.matchInfo saveCache];
    }
}

- (instancetype)initWithMatchInfo:(MatchDoingInfo *)matchInfo {
    
    self = [super init];
    if (self) {
        _matchInfo = matchInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetTableViewHeight];
    });
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Create_Quarter;
}

#pragma mark - Private

- (void)loadData {
    
    if (self.matchInfo.timeDivisionRecordList.count == 0) {
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.matchInfo.timeDivisionRecordList];
        TimeDivisionRecordInfo *info = [TimeDivisionRecordInfo new];
        info.section = 0;
        [tmpList addObject:info];
        self.matchInfo.timeDivisionRecordList = [tmpList copy];
    }
}

-(void)setupUI
{
    self.title = LS(@"multi-section.record.title");
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    [self checkCanAddOrDelete];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeDivisionRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeDivisionRecordTableViewCell"];
    
    TimeDivisionRecordTableViewHeaderView *tmpView = [[[NSBundle mainBundle] loadNibNamed:@"TimeDivisionRecordTableViewHeaderView" owner:self options:nil] firstObject];
    tmpView.frame = CGRectMake(0, 0, kUIScreen_Width, 25*kAppScale);
    self.tableView.tableHeaderView = tmpView;
    self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"GBGameTimeDivisionFooterView" owner:self options:nil] firstObject];
    self.footerView.frame = CGRectMake(0, 0, kUIScreen_Width, 50*kAppScale);
    self.footerView.delegate = self;
    self.tableView.tableFooterView = self.footerView;
    
    [self resetTableViewHeight];
}

#pragma mark Logic

- (void)resetTableViewHeight {
    
    self.tableViewConstraint.constant = 75*kAppScale + 42*self.matchInfo.timeDivisionRecordList.count*kAppScale;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.tableView.bottom+40);
}

- (NSDate *)dateWithTime:(NSString *)timeString {
    
    NSDate *currentDate = [NSDate date];
    NSString *YMD = [NSString stringWithFormat:@"%04td-%02td-%02td", currentDate.year, currentDate.month, currentDate.day];
    
    NSDateFormatter *strToDataFormatter = [[NSDateFormatter alloc] init];
    [strToDataFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [strToDataFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", YMD, timeString]];
    
    return date;
}

- (void)showTimePicker:(NSDate *)beginDate{

    if (!beginDate) {
        beginDate = [NSDate date];
    }
    GBSingleTimePicker *timePicker = [GBSingleTimePicker showWithSelectIndex:beginDate.hour startMin:beginDate.minute];
    timePicker.delegate = self;
}

- (void)checkCanAddOrDelete {
    
    if (self.matchInfo.timeDivisionRecordList.count==0) {
        [self.footerView setDelButtonEnable:NO];
        [self.footerView setAddButtonEnable:YES];
    }else {
        if (self.matchInfo.timeDivisionRecordList.count == kMaxTimeDivisionCount) {
            [self.footerView setDelButtonEnable:YES];
            [self.footerView setAddButtonEnable:NO];
        }else {
            TimeDivisionRecordInfo *info = self.matchInfo.timeDivisionRecordList.lastObject;
            if (info.beginDate && info.endDate) {
                [self.footerView setDelButtonEnable:YES];
                [self.footerView setAddButtonEnable:YES];
            }else {
                [self.footerView setDelButtonEnable:YES];
                [self.footerView setAddButtonEnable:NO];
            }
        }
    }
}

#pragma mark - Delegate

-(void)GBSingleTimePicker:(GBSingleTimePicker*)picker startHour:(NSInteger)startHour startMin:(NSInteger)startMin {
    
    NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", startHour, startMin];
    NSDate *date = [self dateWithTime:startTime];
    TimeDivisionRecordInfo *info = self.matchInfo.timeDivisionRecordList[self.currentSelectIndex];
    if (self.timeIndex == 1) {
        info.beginDate = date;
    }else {
        info.endDate = date;
    }
    [self.matchInfo saveCache];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentSelectIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark GBGameTimeDivisionFooterViewDelegate

- (void)didClickDelete {
    
    NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.matchInfo.timeDivisionRecordList];
    [tmpList removeLastObject];
    self.matchInfo.timeDivisionRecordList = [tmpList copy];
    [self.matchInfo saveCache];
    [self checkCanAddOrDelete];
    [self resetTableViewHeight];
    [self.tableView reloadData];
}

- (void)didClickAdd {
    
    [UMShareManager event:Analy_Click_Game_PAddQuar];
    
    if (self.matchInfo.timeDivisionRecordList.count < kMaxTimeDivisionCount) {
        NSInteger section = 0;
        if (self.matchInfo.timeDivisionRecordList.count>0) {
            section = [self.matchInfo.timeDivisionRecordList lastObject].section+1;
        }
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:self.matchInfo.timeDivisionRecordList];
        TimeDivisionRecordInfo *info = [TimeDivisionRecordInfo new];
        info.section = section;
        [tmpList addObject:info];
        self.matchInfo.timeDivisionRecordList = [tmpList copy];
        [self.matchInfo saveCache];
        [self checkCanAddOrDelete];
        
        [self resetTableViewHeight];
        [self.tableView reloadData];
    }
}

#pragma mark TimeDivisionRecordTableViewCellDelegate

- (void)didClickBeginTime:(TimeDivisionRecordTableViewCell *)cell {
    
    [UMShareManager event:Analy_Click_Game_PDelQuar];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TimeDivisionRecordInfo *info = self.matchInfo.timeDivisionRecordList[indexPath.row];
    if (!info.beginDate) {
        NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", [NSDate date].hour, [NSDate date].minute];
        info.beginDate = [self dateWithTime:startTime];
        [self.matchInfo saveCache];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else {
        self.currentSelectIndex = indexPath.row;
        self.timeIndex = 1;
        [self showTimePicker:info.beginDate];
    }
    
    [self checkCanAddOrDelete];
}

- (void)didClickEndTime:(TimeDivisionRecordTableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    TimeDivisionRecordInfo *info = self.matchInfo.timeDivisionRecordList[indexPath.row];
    if (!info.endDate) {
        NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", [NSDate date].hour, [NSDate date].minute];
        info.endDate = [self dateWithTime:startTime];
        [self.matchInfo saveCache];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else {
        self.currentSelectIndex = indexPath.row;
        self.timeIndex = 2;
        [self showTimePicker:info.endDate];
    }
    
    [self checkCanAddOrDelete];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.matchInfo.timeDivisionRecordList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 42*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeDivisionRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeDivisionRecordTableViewCell"];
    cell.delegate = self;
    
    TimeDivisionRecordInfo *info = self.matchInfo.timeDivisionRecordList[indexPath.row];
    NSString *startTime = [NSString stringWithFormat:@"%02zd:%02zd", info.beginDate.hour, info.beginDate.minute];
    NSString *endTime = [NSString stringWithFormat:@"%02zd:%02zd", info.endDate.hour, info.endDate.minute];
    
    cell.beginTimeLabel.text = startTime;
    cell.endTimeLabel.text = endTime;
    NSDictionary *chineseDic = @{@"0":LS(@"multi-section.section.one"),
                                 @"1":LS(@"multi-section.section.two"),
                                 @"2":LS(@"multi-section.section.three"),
                                 @"3":LS(@"multi-section.section.four"),
                                 @"4":LS(@"multi-section.section.five")};
    cell.sectionNameLabel.text = chineseDic[@(info.section).stringValue];
    [cell showBeginLayer:!info.beginDate];
    [cell showEndLayer:!info.endDate];
    
    return cell;
}


@end
