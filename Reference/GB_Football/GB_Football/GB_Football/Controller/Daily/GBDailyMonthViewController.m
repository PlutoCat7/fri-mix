//
//  GBDailyMonthViewController.m
//  GB_Football
//
//  Created by gxd on 17/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBDailyMonthViewController.h"
#import "GBMenuViewController.h"
#import "GBDailyDetailViewController.h"

#import "MPBarsGraphView.h"
#import "MJRefresh.h"
#import "DailyRequest.h"
#import "GBBluetoothManager.h"
#import "CalendarMenuView.h"
#import "GBSharePan.h"
#import "UMShareManager.h"

@interface GBDailyMonthViewController () <MPBarsGraphViewDelegate, GBSharePanDelegate, CalendarMenuDelegate>

// 目标步数指示标签
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
// 年月标签
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 柱状图容器
@property (weak, nonatomic) IBOutlet UIView *barGraphContainer;
// 柱状图
@property (strong, nonatomic) MPBarsGraphView *barGraph;

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

@property (weak, nonatomic) IBOutlet UILabel *totalDistLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalStepLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalConsLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagDistLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagStepLbl;
@property (weak, nonatomic) IBOutlet UILabel *avagConsLbl;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property (nonatomic, strong) NSArray<NSDate *> *monthDateList;
@property (nonatomic, strong) NSMutableArray<DailyInfo *> *dataList;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *shouldHasDataDateList;  //应该有数据的日期，
@property (nonatomic, assign) NSInteger curYear;
@property (nonatomic, assign) NSInteger curMonth;

// 分享功能
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic)  GBSharePan   *sharePan;
@property (strong, nonatomic)  UIImage      *shotImage;

@property (nonatomic, strong) CalendarMenuView *navBarMenu;

@end

@implementation GBDailyMonthViewController

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
    return Analy_Page_Daily_Month;
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

- (instancetype)initWithYearMonth:(NSInteger)curYear month:(NSInteger)curMonth {
    self = [super init];
    if (self) {
        _curYear = curYear;
        _curMonth = curMonth;
    }
    return self;
}

- (void)dealloc{
    
}

#pragma mark - action

- (IBAction)actionViewDetail:(id)sender {
    NSString *title = [NSString stringWithFormat:@"%td/%02td", self.curYear, self.curMonth];
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
    return TYPE_MONTH;
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
- (void)didSelectDate:(NSInteger)year month:(NSInteger)month {
    if (self.curYear == year && self.curMonth == month) {
        return;
    }
    self.curYear = year;
    self.curMonth = month;
    [self caculateMonthDate];
    
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
    [self caculateMonthDate];
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
        self.navBarMenu = [[CalendarMenuView alloc] initWithMonthFrame:self.navigationItem frame:frame year:self.curYear month:self.curMonth];
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
    self.dateLabel.text = [NSString stringWithFormat:@"%td/%02td", [NSDate date].year, [NSDate date].month];
}

- (void)refreshUI {
    // 刷新柱状图接口
    NSArray<NSNumber *> *values = self.barsGraphData;
    self.barGraph.valueRanges = [MPPlot rangeForValues:values];
    [self.barGraph setValues:values];
    [self.barGraph animate];
    NSInteger totalStep = 0;
    CGFloat totalMeter = 0.f;
    CGFloat totalConsume = 0.f;
    NSInteger dayCount = self.monthDateList.count == 0 ? 1 : self.monthDateList.count;
    BOOL isShowSport = [self isShowSportData];
    for (DailyInfo *dailyInfo in self.dataList) {
        totalConsume += (isShowSport ? dailyInfo.totalConsume : dailyInfo.dailyAndRunConsume);
        totalStep += (isShowSport ? dailyInfo.totalStep : dailyInfo.dailyAndRunStep);
        totalMeter += (isShowSport ? dailyInfo.totalDistance : dailyInfo.dailyAndRunDistance);
    }
    NSInteger avagStep = totalStep/dayCount;
    CGFloat avagMeter = totalMeter/(float)dayCount;
    CGFloat avagConsume = totalConsume/(float)dayCount;
    
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
    self.dateLabel.text = [NSString stringWithFormat:@"%td/%02td", self.curYear, self.curMonth];
}

#pragma mark 数据处理

- (void)caculateMonthDate {
    
    NSDateFormatter *strToDataFormatter = [[NSDateFormatter alloc] init];
    [strToDataFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *firstDate = [strToDataFormatter dateFromString:[NSString stringWithFormat:@"%td-%02td-%02d", self.curYear, self.curMonth, 1]];
    NSInteger dayCount = [self howManyDaysInThisYear:self.curYear withMonth:self.curMonth];
    
    NSDate *todayDate = [NSDate date];
    if (todayDate.year == self.curYear && todayDate.month == self.curMonth) {
        dayCount = dayCount > todayDate.day ? todayDate.day : dayCount;
    }
    
    self.dataList = [NSMutableArray arrayWithCapacity:1];
    self.shouldHasDataDateList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *queryDateList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=0; index<dayCount; index++) {
        NSDate *date = [firstDate dateByAddingDays:index];
        [queryDateList addObject:date];
        
        DailyInfo *dailyObj = [[DailyInfo alloc] init];
        dailyObj.date = [date timeIntervalSince1970];
        [self.dataList addObject:dailyObj];
        
        [self.shouldHasDataDateList addObject:@(NO)];
    }
    self.monthDateList = [queryDateList copy];
}

- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
        return 28;
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

- (void)queryNetworkWeekData {
    // 加载过程不能点击查看详情
    self.detailButton.enabled = NO;
    NSDate *first = [self.monthDateList firstObject];
    NSDate *last = [self.monthDateList lastObject];
    @weakify(self)
    [DailyRequest queryDailyData:first.timeIntervalSince1970 endDate:last.timeIntervalSince1970 handler:^(id result, NSError *error) {
        
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
            [self.scrollView.mj_header endRefreshing];
            self.detailButton.enabled = YES;
            
        } else {
            [self updateDataArray:result];
            
            NSDate *lastDate = [self.monthDateList lastObject];
            if (![lastDate isToday] || ([RawCacheManager sharedRawCacheManager].isBindWristband && [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status != iBeaconStatus_Normal)) {
                [self.scrollView.mj_header endRefreshing];
                self.detailButton.enabled = YES;
                [self refreshUI];
                
            } else {
                [self queryiBeaconMonthData];
            }
        }
        
    }];
}

- (void)queryiBeaconMonthData {
    
    [self.shouldHasDataDateList replaceObjectAtIndex:self.shouldHasDataDateList.count-1 withObject:@(NO)]; //当天数据已蓝牙数据为准
    NSMutableArray *syncDateArray = [NSMutableArray new];
    for (int i = 0; i < [self.shouldHasDataDateList count]; i++) {
        NSNumber *number = self.shouldHasDataDateList[i];
        if ([number boolValue] == NO) {
            [syncDateArray addObject:self.monthDateList[i]];
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
        for(NSInteger index = 0; index<self.monthDateList.count; index++) {
            NSDate *infoDate = [NSDate dateWithTimeIntervalSince1970:dailyInfo.date];
            NSDate *monthDate = self.monthDateList[index];
            DailyInfo *oldDailyInfo = self.dataList[index];
            if (infoDate.year == monthDate.year &&
                infoDate.month == monthDate.month &&
                infoDate.day == monthDate.day &&
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
