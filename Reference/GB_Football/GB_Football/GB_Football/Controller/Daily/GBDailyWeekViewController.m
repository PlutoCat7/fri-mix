//
//  GBDailyWeekViewController.m
//  GB_Football
//
//  Created by gxd on 17/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBDailyWeekViewController.h"
#import "GBMenuViewController.h"
#import "GBDailyDetailViewController.h"

#import "MPBarsGraphView.h"
#import "MJRefresh.h"
#import "DailyRequest.h"
#import "GBBluetoothManager.h"
#import "CalendarMenuView.h"
#import "GBSharePan.h"
#import "UMShareManager.h"

@interface GBDailyWeekViewController ()<MPBarsGraphViewDelegate, GBSharePanDelegate, CalendarMenuDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// 目标步数指示标签
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

// 柱状图
@property (strong, nonatomic) MPBarsGraphView *barGraph;
@property (weak, nonatomic) IBOutlet UIView *barGraphContainer;

@property (weak, nonatomic) IBOutlet UILabel *totalDistLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalStepLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalConsLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagDistLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagStepLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagConsLbl;

@property (weak, nonatomic) IBOutlet UILabel *targetStLbl;
@property (weak, nonatomic) IBOutlet UILabel *analysisStLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalDistStLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalStepStLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalConsStLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagDistStLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagStepStLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagConsStLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailDataStLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalDistUnitStLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagDistUnitStLbl;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property (nonatomic, strong) NSArray<NSDate *> *weekDateList;
@property (nonatomic, strong) NSMutableArray<DailyInfo *> *dataList;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *shouldHasDataDateList;  //应该有数据的日期，
@property (nonatomic, strong) NSDate *curDate;

// 分享功能
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic)  GBSharePan   *sharePan;
@property (strong, nonatomic)  UIImage      *shotImage;

@property (nonatomic, strong) CalendarMenuView *navBarMenu;

@end

@implementation GBDailyWeekViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    [self.yah_KVOController observe:[RawCacheManager sharedRawCacheManager].userInfo.config keyPath:@"stepNumberGoal" block:^(id observer, id object, NSDictionary *change) {
        @strongify(self)
        [self refreshUI];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Daily_Week;
}

- (void)shareSuccess {
    [UMShareManager event:Analy_Click_Share_Daily];
}

#pragma mark -
#pragma mark Memory

- (void)localizeUI {
    self.targetStLbl.text = LS(@"week.label.goal");
    self.analysisStLbl.text = LS(@"week.label.data.statistics");
    self.totalDistStLbl.text = LS(@"week.label.total.mileage");
    self.totalStepStLbl.text = LS(@"week.label.total.step");
    self.totalConsStLbl.text = LS(@"week.label.total.calorie");
    self.avagDistStLbl.text = LS(@"week.label.avag.mileage");
    self.avagStepStLbl.text = LS(@"week.label.avag.step");
    self.avagConsStLbl.text = LS(@"week.label.avag.calorie");
    self.detailDataStLbl.text = LS(@"week.label.data.detail");
}

- (instancetype)initWithCurDate:(NSDate *)curDate {
    self = [super init];
    if (self) {
        _curDate = curDate;
    }
    return self;
}

- (void)dealloc{
    
}

#pragma mark - action

- (IBAction)actionViewDetail:(id)sender {
    NSDate *first = [self.weekDateList firstObject];
    NSDate *last = [self.weekDateList lastObject];
    
    NSString *title = [NSString stringWithFormat:@"%02td/%02td~%02td/%02td", first.month, first.day, last.month, last.day];
    GBDailyDetailViewController *viewController = [[GBDailyDetailViewController alloc] initWithData:self.dataList title:title];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - BAR Delegate

-(NSArray<NSNumber*>*)barsGraphData
{
    NSMutableArray *stepList = [NSMutableArray arrayWithCapacity:1];
    [stepList addObject:@([RawCacheManager sharedRawCacheManager].stepNumberGoal)];
    for (DailyInfo *dailyInfo in self.dataList) {
        if ([self isShowSportData]) {
            [stepList addObject:@(dailyInfo.totalStep)];
        } else {
            [stepList addObject:@(dailyInfo.dailyAndRunStep)];
        }
        
    }
    [stepList addObject:@(0)];
    return [stepList copy];
}

-(NSArray<UIColor*>*)MPBarsGraphViewColor:(MPBarsGraphView*)barGraph
{
    NSMutableArray *stepList = [NSMutableArray arrayWithCapacity:1];
    [stepList addObject:@([RawCacheManager sharedRawCacheManager].stepNumberGoal)];
    for (DailyInfo *dailyInfo in self.dataList) {
        if ([self isShowSportData]) {
            [stepList addObject:@(dailyInfo.totalStep)];
        } else {
            [stepList addObject:@(dailyInfo.dailyAndRunStep)];
        }
    }
    [stepList addObject:@(0)];
    return [self colorForGraph:[stepList copy]];
}

// 颜色获取逻辑
-(NSArray<UIColor*>*)colorForGraph:(NSArray<NSNumber*>*)sourceData
{
    NSMutableArray *colors = [[NSMutableArray alloc]initWithCapacity:[sourceData count]];
    NSNumber *base    = [sourceData firstObject];
    
    for (int i = 0 ; i < [sourceData count]; i++)
    {
        if ( [sourceData[i] integerValue] >= [base integerValue] )
        {
            colors[i] = [UIColor colorWithHex:0x01ff00];
        }
        else if([sourceData[i] integerValue] >= (CGFloat)[base integerValue]*0.75f &&
                [sourceData[i] integerValue] < (CGFloat)[base integerValue]*1.f)
        {
            colors[i] = [UIColor colorWithHex:0x01e672];
        }
        else if([sourceData[i] integerValue] >= (CGFloat)[base integerValue]*0.5f &&
                [sourceData[i] integerValue] < (CGFloat)[base integerValue]*0.75f)
        {
            colors[i] = [UIColor colorWithHex:0xffea01];
        }
        else if([sourceData[i] integerValue] >= (CGFloat)[base integerValue]*0.f &&
                [sourceData[i] integerValue] < (CGFloat)[base integerValue]*0.5f)
        {
            colors[i] = [UIColor colorWithHex:0xfd0100];
        }
    }
    return [colors mutableCopy];
}

-(TYPE_BAR)MPBarsGraphViewType:(MPBarsGraphView*)barGraph
{
    return TYPE_WEEK;
}

#pragma mark - 分享功能

-(void)shareItemAction
{
    [self hideNavItems];
    self.shotImage = [UIImage imageWithCapeture];
    [self.sharePan showSharePanWithDelegate:self];
}

- (GBSharePan*)sharePan
{
    if (!_sharePan)
    {
        _sharePan = [[GBSharePan alloc] init];
        _sharePan.delegate = self;
    }
    return _sharePan;
}

- (void)GBSharePanAction:(GBSharePan*)pan tag:(SHARE_TYPE)tag
{
    [[[UMShareManager alloc]init] screenShare:tag image:self.shotImage complete:^(NSInteger state)
     {
         switch (state)
         {
             case 0:
             {
                 [self showToastWithText:LS(@"share.toast.success")];
                 [self showNavItems];
                 [self shareSuccess];
                 [pan hide:^(BOOL ok){}];
             }break;
             case 1:
             {
                 [self showToastWithText:LS(@"share.toast.fail")];
                 [self showNavItems];
                 [pan hide:^(BOOL ok){}];
             }break;
             default:
                 break;
         }
     }];
}

- (void)GBSharePanActionCancel:(GBSharePan *)pan
{
    [self showNavItems];
}

#pragma Calendar Delegate
- (void)didSelectDate:(NSDate *)date {
    if ([self.curDate isEqualToDateIgnoringTime:date]) {
        return;
    }
    self.curDate = date;
    [self caculateWeekDate];
    
    // 导入数据
    [self.scrollView.mj_header beginRefreshing];
}

- (void)didShowCalendarMenuBefore {
    [self hideNavItems];
}

- (void)didHideCalendarMenuAfter {
    [self showNavItems];
}

#pragma mark - Private

-(void)setupUI {
    [self caculateWeekDate];
    [self setupNavBar];
    
    [self setupBarGraph];
    [self setupInitUI];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self queryNetworkWeekData];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.scrollView.mj_header = mj_header;
    
    // 导入数据
    [self.scrollView.mj_header beginRefreshing];
}

-(void)setupNavBar {
    if (self.navigationItem)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        self.navBarMenu = [[CalendarMenuView alloc] initWithWeekFrame:self.navigationItem frame:frame date:self.curDate];
        self.navBarMenu.calendarDelegate = self;
        self.navigationItem.titleView = self.navBarMenu;
        [self.navBarMenu displayMenuInView:self.navigationController.view];
    }
    @weakify(self)
    self.backButton = [self setupBackButtonWithBlock:^{
        
        @strongify(self)
        [self.navBarMenu remove];
    }];
    [self showNavItems];
}


-(void)hideNavItems
{
    self.backButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)showNavItems
{
    self.backButton.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(shareItemAction)];
}

- (void)setupBarGraph
{
    CGRect frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(116.f/667)*[UIScreen mainScreen].bounds.size.height);
    self.barGraph =[MPPlot plotWithType:MPPlotTypeBars frame:frame];
    self.barGraph.delegate      = self;
    self.barGraph.waitToUpdate  = YES;
    [self.barGraphContainer addSubview:self.barGraph];
}

- (void)setupInitUI {
    self.totalStepLbl.text = @"0";
    self.totalDistLbl.text = [NSString stringWithFormat:@"%.1f", 0.f];
    self.totalConsLbl.text = [NSString stringWithFormat:@"%.1f", 0.f];
    self.avagStepLbl.text = @"0";
    self.avagDistLbl.text = [NSString stringWithFormat:@"%.1f", 0.f];
    self.avagConsLbl.text = [NSString stringWithFormat:@"%.1f", 0.f];
    [self.targetLabel setText:[NSString stringWithFormat:@"%td",[RawCacheManager sharedRawCacheManager].stepNumberGoal]];
}

- (void)refreshUI {
    // 刷新柱状图接口
    NSArray<NSNumber *> *values = self.barsGraphData;
    self.barGraph.valueRanges = [MPPlot rangeForValues:values];
    [self.barGraph setValues:values];
    [self.barGraph animate];
    NSInteger totalStep = 0;
    CGFloat totalMeter = 0;
    CGFloat totalConsume = 0;
    BOOL isShowSport = [self isShowSportData];
    for (DailyInfo *dailyInfo in self.dataList) {
        totalConsume += (isShowSport ? dailyInfo.totalConsume : dailyInfo.dailyAndRunConsume);
        totalStep += (isShowSport ? dailyInfo.totalStep : dailyInfo.dailyAndRunStep);
        totalMeter += (isShowSport ? dailyInfo.totalDistance : dailyInfo.dailyAndRunDistance);
    }
    NSInteger count = self.weekDateList.count == 0 ? 1 : self.weekDateList.count;
    NSInteger avagStep = totalStep/count;
    CGFloat avagMeter = totalMeter/(float)count;
    CGFloat avagConsume = totalConsume/(float)count;
    
    self.totalStepLbl.text = @(totalStep).stringValue;
    //self.totalDistLbl.text = [NSString stringWithFormat:@"%.1f", totalMeter/1000];
    self.totalConsLbl.text = [NSString stringWithFormat:@"%.1f", totalConsume];
    if (totalMeter < 1000) {
        self.totalDistLbl.text = [NSString stringWithFormat:@"%.1f", totalMeter];
        self.totalDistUnitStLbl.text = @"M";
    } else {
        self.totalDistLbl.text = [NSString stringWithFormat:@"%.1f", totalMeter/1000];
        self.totalDistUnitStLbl.text = @"KM";
    }
    
    self.avagStepLbl.text = @(avagStep).stringValue;
    //self.avagDistLbl.text = [NSString stringWithFormat:@"%.1f", avagMeter/1000];
    self.avagConsLbl.text = [NSString stringWithFormat:@"%.1f", avagConsume];
    if (avagMeter < 1000) {
        self.avagDistLbl.text = [NSString stringWithFormat:@"%.1f", avagMeter];
        self.avagDistUnitStLbl.text = @"M";
    } else {
        self.avagDistLbl.text = [NSString stringWithFormat:@"%.1f", avagMeter/1000];
        self.avagDistUnitStLbl.text = @"KM";
    }
    
    [self.targetLabel setText:[NSString stringWithFormat:@"%td",[RawCacheManager sharedRawCacheManager].stepNumberGoal]];
    
}

#pragma mark 数据处理

- (void)caculateWeekDate {
    
    NSDate *curDate = self.curDate ? self.curDate : [NSDate date];
    NSDate *nowDate = [NSDate date];
    
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger currentWeekDay = curDate.weekday;
    if (currentWeekDay == 1) {//方便计算， 将周天改为8
        currentWeekDay = 8;
    }
    
    NSDate *firstDate = [curDate dateByAddingDays:2-currentWeekDay];
    NSDate *lastDate = [curDate dateByAddingDays:2-currentWeekDay+6];
    if (([nowDate isLaterThanDate:firstDate] && [lastDate isLaterThanDate:nowDate]) || [firstDate isToday] || [lastDate isToday]) {
        curDate = nowDate;
        currentWeekDay = curDate.weekday;
        if (currentWeekDay == 1) {//方便计算， 将周天改为8
            currentWeekDay = 8;
        }
        
    } else {
        curDate = lastDate;
        currentWeekDay = 8;
    }
    
    
    NSMutableArray *queryDateList = [NSMutableArray arrayWithCapacity:1];
    self.dataList = [NSMutableArray arrayWithCapacity:1];
    self.shouldHasDataDateList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=2; index<=currentWeekDay; index++) {
        NSDate *date = [curDate dateByAddingDays:index-currentWeekDay];
        [queryDateList addObject:date];
        
        DailyInfo *dailyObj = [[DailyInfo alloc] init];
        dailyObj.date = [date timeIntervalSince1970];
        [self.dataList addObject:dailyObj];
        
        [self.shouldHasDataDateList addObject:@(NO)];
        
    }
    self.weekDateList = [queryDateList copy];
}

- (void)queryNetworkWeekData {
    // 加载过程不能点击查看详情
    self.detailButton.enabled = NO;
    NSDate *first = [self.weekDateList firstObject];
    NSDate *last = [self.weekDateList lastObject];
    @weakify(self)
    [DailyRequest queryDailyData:first.timeIntervalSince1970 endDate:last.timeIntervalSince1970 handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
            [self.scrollView.mj_header endRefreshing];
            self.detailButton.enabled = YES;
            
        } else {
            [self updateDataArray:result];
            
            NSDate *lastDate = [self.weekDateList lastObject];
            if (![lastDate isToday] || ([RawCacheManager sharedRawCacheManager].isBindWristband && [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status != iBeaconStatus_Normal)) {
                [self.scrollView.mj_header endRefreshing];
                self.detailButton.enabled = YES;
                [self refreshUI];
                
            } else {
                [self queryiBeaconWeekData];
            }
        }
        
    }];
}

- (void)queryiBeaconWeekData {
    
    [self.shouldHasDataDateList replaceObjectAtIndex:self.shouldHasDataDateList.count-1 withObject:@(NO)]; //当天数据已蓝牙数据为准
    NSMutableArray *syncDateArray = [NSMutableArray new];
    for (int i = 0; i < [self.shouldHasDataDateList count]; i++) {
        NSNumber *number = self.shouldHasDataDateList[i];
        if ([number boolValue] == NO) {
            [syncDateArray addObject:self.weekDateList[i]];
        }
    }
    @weakify(self)
    [[GBBluetoothManager sharedGBBluetoothManager] readMutableCommonModelData:syncDateArray level:GBBluetoothTask_PRIORITY_Normal serviceBlock:^(id data, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self.scrollView.mj_header endRefreshing];
            self.detailButton.enabled = YES;
            
            [self refreshUI];
            
        } else if ([self isSyncSportData]) {
            
            NSDictionary *dailyData = data;
            __block NSArray<DailyInfo *> *dailyInfoList = [LogicManager dailyInfoListWithDic:data];
            
            @weakify(self)
            [[GBBluetoothManager sharedGBBluetoothManager] readMutableSportStepData:syncDateArray level:GBBluetoothTask_PRIORITY_Normal serviceBlock:^(id data, NSError *error) {
                @strongify(self)
                [self.scrollView.mj_header endRefreshing];
                self.detailButton.enabled = YES;
                
                NSDictionary *dailySportDict = data;
                [self syncDailyData:dailyData sportDict:dailySportDict];
                
                if (!error) {
                    NSArray<DailyInfo *> *dailySportInfoList = [LogicManager dailySportInfoListWithDic:data];
                    dailyInfoList = [self combineDailyInfo:dailyInfoList dailySportInfoList:dailySportInfoList];
                }
                [self updateDataArray:dailyInfoList];
                
                [self refreshUI];
                
            }];
            
        } else {
            [self.scrollView.mj_header endRefreshing];
            self.detailButton.enabled = YES;
            
            [self syncDailyData:data sportDict:nil];
            NSArray<DailyInfo *> *dailyInfoList = [LogicManager dailyInfoListWithDic:data];
            [self updateDataArray:dailyInfoList];
            
            [self refreshUI];
        }
        
    }];
}

- (NSArray<DailyInfo *> *)combineDailyInfo:(NSArray<DailyInfo *> *)dailyInfoList dailySportInfoList:(NSArray<DailyInfo *> *)dailySportInfoList {
    if (!dailyInfoList || dailyInfoList.count == 0 || !dailySportInfoList || dailySportInfoList.count == 0) {
        return dailyInfoList;
    }
    
    for (DailyInfo *dailyInfo in dailyInfoList) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:dailyInfo.date];
        for (DailyInfo *dailySportInfo in dailySportInfoList) {
            NSDate *sportDate = [NSDate dateWithTimeIntervalSince1970:dailyInfo.date];
            if ([date isEqualToDateIgnoringTime:sportDate]) {
                dailyInfo.sportStep = dailySportInfo.sportStep;
                dailyInfo.sportDistance = dailySportInfo.sportDistance;
                dailyInfo.sportConsume = dailySportInfo.sportConsume;
                dailyInfo.runStep = dailySportInfo.runStep;
                dailyInfo.runDistance = dailySportInfo.runDistance;
                dailyInfo.runConsume = dailySportInfo.runConsume;
                
                break;
            }
        }
    }
    
    return dailyInfoList;
}

- (void)updateDataArray:(NSArray<DailyInfo *> *)dailyInfoList
{
    if (!dailyInfoList) {
        return;
    }
    for (DailyInfo *dailyInfo in dailyInfoList) {
        for(NSInteger index = 0; index<self.weekDateList.count; index++) {
            NSDate *infoDate = [NSDate dateWithTimeIntervalSince1970:dailyInfo.date];
            NSDate *weekDate = self.weekDateList[index];
            DailyInfo *oldDailyInfo = self.dataList[index];
            if (infoDate.year == weekDate.year &&
                infoDate.month == weekDate.month &&
                infoDate.day == weekDate.day &&
                oldDailyInfo.totalStep < dailyInfo.totalStep) {
                [self.dataList replaceObjectAtIndex:index withObject:dailyInfo];
                
                [self.shouldHasDataDateList replaceObjectAtIndex:index withObject:@(YES)];
                break;
            }
        }
    }
}

- (void)syncDailyData:(NSDictionary *)dict sportDict:(NSDictionary *)sportDict
{
    if (!dict || dict.allKeys.count == 0) {
        return;
    }
    NSData *parseData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSData *parseSportData = nil;
    if (sportDict && sportDict.allKeys.count > 0) {
        parseSportData = [NSJSONSerialization dataWithJSONObject:sportDict options:0 error:nil];
    }
    // 同步数据
    [DailyRequest syncDailyData:parseData sportData:(NSData *)parseSportData handler:^(id result, NSError *error) {
    }];
}

- (BOOL)isSyncSportData {
    return ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S
            && [[GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion floatValue] > 2.1 + 0.0001);
}

- (BOOL)isShowSportData {
    return ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S
            && [RawCacheManager sharedRawCacheManager].userInfo.config.match_add_dail == 1
            && [[GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion floatValue] > 2.1 + 0.0001);
}

@end
