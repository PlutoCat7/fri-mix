//
//  GBDailyDayViewController.m
//  GB_Football
//
//  Created by gxd on 17/5/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBDailyDayViewController.h"
#import "GBMenuViewController.h"
#import "GBDailyWeekViewController.h"
#import "GBDailyMonthViewController.h"
#import "GBWebBrowserViewController.h"
#import "GBStartRunViewController.h"
#import "GBEndRunViewController.h"

#import "DayProgressView.h"
#import "MJRefresh.h"
#import "GBBluetoothManager.h"
#import "POPNumberAnimation.h"
#import "DailyRequest.h"
#import "CalendarMenuView.h"
#import "GBSharePan.h"
#import "UMShareManager.h"
#import "AGPSManager.h"
#import "RunLogic.h"

@interface GBDailyDayViewController () <GBSharePanDelegate, CalendarMenuDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DayProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *distanceStLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeStLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekStLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthStLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekDistStLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekStepStLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekConsStLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthDistStLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthStepStLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthConsStLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayDistUnitStLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekDistUnitStLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthDistUnitStLabel;
@property (weak, nonatomic) IBOutlet UILabel *runStLbl;

@property (weak, nonatomic) IBOutlet UILabel *dayDistLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayConsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekDistLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekConsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthDistLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthConsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

// 分享功能
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic)  GBSharePan   *sharePan;
@property (strong, nonatomic)  UIImage      *shotImage;

@property (nonatomic, strong) CalendarMenuView *navBarMenu;

@property (nonatomic, strong) DailyInfo *dailyInfo;
@property (nonatomic, copy) NSDate *curDate;
@property (nonatomic, strong) DailySummaryInfo *curDailySummary;

@end

@implementation GBDailyDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Daily_Day;
}

- (void)shareSuccess {
    [UMShareManager event:Analy_Click_Share_Daily];
}

#pragma Calendar Delegate
- (void)didSelectDate:(NSDate *)date {
    if ([self.curDate isEqualToDateIgnoringTime:date]) {
        return;
    }
    self.curDate = date;
    
    // 导入数据
    [self.scrollView.mj_header beginRefreshing];
}

- (void)didShowCalendarMenuBefore {
    [self hideNavItems];
}

- (void)didHideCalendarMenuAfter {
    [self showNavItems];
}

#pragma mark - action
- (IBAction)actionWeekDetail:(id)sender {
    GBDailyWeekViewController *viewController = [[GBDailyWeekViewController alloc]initWithCurDate:self.curDate];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionMonthDetail:(id)sender {
    NSInteger year = self.curDate.year;
    NSInteger month = self.curDate.month;
    GBDailyMonthViewController *viewController = [[GBDailyMonthViewController alloc]initWithYearMonth:year month:month];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)actionRun:(id)sender {
    
    switch ([AGPSManager shareInstance].status) {
        case iBeaconStatus_Run:
        {
            [self showLoadingToast];
            @weakify(self)
            [[GBBluetoothManager sharedGBBluetoothManager] readRunTime:^(id data, NSError *error) {
                @strongify(self)
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self dismissToast];
                    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[RunLogic runBeginTime:data]];
                    GBEndRunViewController *viewController = [[GBEndRunViewController alloc]initWithStartDate:startDate];
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            } level:GBBluetoothTask_PRIORITY_Hight];
        }
            break;
        default:
        {
            [UMShareManager event:Analy_Click_Daily_GoRun];
            
            GBStartRunViewController *viewController = [[GBStartRunViewController alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
    }
    
}

#pragma mark - Private
- (void)localizeUI {
    self.distanceStLabel.text = LS(@"today.label.mileage");
    self.consumeStLabel.text = LS(@"today.label.calorie");
    
    self.weekStLabel.text = LS(@"today.label.week.data");
    self.weekDistStLabel.text = LS(@"today.label.mileage");
    self.weekStepStLabel.text = LS(@"today.label.step");
    self.weekConsStLabel.text = LS(@"today.label.calorie");
    
    self.monthStLabel.text = LS(@"today.label.month.data");
    self.monthDistStLabel.text = LS(@"today.label.mileage");
    self.monthStepStLabel.text = LS(@"today.label.step");
    self.monthConsStLabel.text = LS(@"today.label.calorie");
    
    self.runStLbl.text = LS(@"today.label.run");
    
}

-(void)setupUI {
    self.curDate = [NSDate date];
    [self setupNavBar];
    
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        
        [self loadDailyData];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.scrollView.mj_header = mj_header;
    
    [self updateCurDailyUI];
    // 导入数据
    [self.scrollView.mj_header beginRefreshing];
}

-(void)setupNavBar {
    if (self.navigationItem)
    {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        self.navBarMenu = [[CalendarMenuView alloc] initWithDayFrame:self.navigationItem frame:frame date:self.curDate];
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

- (void)updateCurDailyUI {
    
    DailyInfo *todayInfo = self.curDailySummary.day;
    
    if ([self.curDate isToday] && (([self isShowSportData] && self.dailyInfo.totalStep > self.curDailySummary.day.totalStep) || (![self isShowSportData] && self.dailyInfo.dailyAndRunStep > self.curDailySummary.day.dailyAndRunStep))) {
        todayInfo = self.dailyInfo;
    }
    
    float weekDistance = 0.f;
    NSInteger weekStep = 0;
    float weekConsume = 0.f;
    float monthDistance = 0.f;
    NSInteger monthStep = 0;
    float monthConsume = 0.f;
    if ([self isShowSportData]) {
        weekDistance = self.curDailySummary.week.totalDistance - self.curDailySummary.day.totalDistance + todayInfo.totalDistance;
        weekStep = self.curDailySummary.week.totalStep - self.curDailySummary.day.totalStep + todayInfo.totalStep;
        weekConsume = self.curDailySummary.week.totalConsume - self.curDailySummary.day.totalConsume + todayInfo.totalConsume;
        
        monthDistance = self.curDailySummary.month.totalDistance - self.curDailySummary.day.totalDistance + todayInfo.totalDistance;
        monthStep = self.curDailySummary.month.totalStep - self.curDailySummary.day.totalStep + todayInfo.totalStep;
        monthConsume = self.curDailySummary.month.totalConsume - self.curDailySummary.day.totalConsume + todayInfo.totalConsume;
    } else {
        weekDistance = self.curDailySummary.week.dailyAndRunDistance - self.curDailySummary.day.dailyAndRunDistance + todayInfo.dailyAndRunDistance;
        weekStep = self.curDailySummary.week.dailyAndRunStep - self.curDailySummary.day.dailyAndRunStep + todayInfo.dailyAndRunStep;
        weekConsume = self.curDailySummary.week.dailyAndRunConsume - self.curDailySummary.day.dailyAndRunConsume + todayInfo.dailyAndRunConsume;
        
        monthDistance = self.curDailySummary.month.dailyAndRunDistance - self.curDailySummary.day.dailyAndRunDistance + todayInfo.dailyAndRunDistance;
        monthStep = self.curDailySummary.month.dailyAndRunStep - self.curDailySummary.day.dailyAndRunStep + todayInfo.dailyAndRunStep;
        monthConsume = self.curDailySummary.month.dailyAndRunConsume - self.curDailySummary.day.dailyAndRunConsume + todayInfo.dailyAndRunConsume;
    }
    
    self.weekStepLabel.text = [NSString stringWithFormat:@"%td", weekStep];
    self.weekConsLabel.text = [NSString stringWithFormat:@"%0.1f", weekConsume];
    if (weekDistance < 1000) {
        self.weekDistLabel.text = [NSString stringWithFormat:@"%0.1f", weekDistance];
        self.weekDistUnitStLabel.text = @"M";
    } else {
        self.weekDistLabel.text = [NSString stringWithFormat:@"%0.1f", weekDistance/1000];
        self.weekDistUnitStLabel.text = @"KM";
    }
    
    self.monthStepLabel.text = [NSString stringWithFormat:@"%td", monthStep];
    self.monthConsLabel.text = [NSString stringWithFormat:@"%0.1f", monthConsume];
    if (monthDistance < 1000) {
        self.monthDistLabel.text = [NSString stringWithFormat:@"%0.1f", monthDistance];
        self.monthDistUnitStLabel.text = @"M";
    } else {
        self.monthDistLabel.text = [NSString stringWithFormat:@"%0.1f", monthDistance/1000];
        self.monthDistUnitStLabel.text = @"KM";
    }
    
    float dayDistance = 0.f;
    NSInteger dayStep = 0;
    float dayConsume = 0.f;
    if ([self isShowSportData]) {
        dayDistance = todayInfo.totalDistance;
        dayStep = todayInfo.totalStep;
        dayConsume = todayInfo.totalConsume;
    } else {
        dayDistance = todayInfo.dailyAndRunDistance;
        dayStep = todayInfo.dailyAndRunStep;
        dayConsume = todayInfo.dailyAndRunConsume;
    }
    self.dayConsLabel.text = [NSString stringWithFormat:@"%0.1f", dayConsume];
    [self.progressView setStep:dayStep];
    if (dayDistance < 1000) {
        self.dayDistLabel.text = [NSString stringWithFormat:@"%0.1f", dayDistance];
        self.dayDistUnitStLabel.text = @"M";
    } else {
        self.dayDistLabel.text = [NSString stringWithFormat:@"%0.1f", dayDistance/1000];
        self.dayDistUnitStLabel.text = @"KM";
    }
    
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger currentWeekDay = self.curDate.weekday;
    if (currentWeekDay == 1) {//方便计算， 将周天改为8
        currentWeekDay = 8;
    }
    NSDate *firstDate = [self.curDate dateByAddingDays:2-currentWeekDay];
    NSDate *lastDate = [self.curDate dateByAddingDays:2-currentWeekDay+6];
    NSString *weekTitle = [NSString stringWithFormat:@"(%02td/%02td~%02td/%02td)", firstDate.month, firstDate.day, lastDate.month, lastDate.day];
    self.weekLabel.text = weekTitle;
    
    NSString *monthTitle = [NSString stringWithFormat:@"(%td/%02td)", self.curDate.year, self.curDate.month];
    self.monthLabel.text = monthTitle;
}

- (void)loadDailyData {
    if (self.curDate && [self.curDate isToday]) {
        [self loadTodayDailyData];
        
        //同步7天的日常数据
        [LogicManager async7Day_DailyData];
        
    } else {
        [self loadCurDateDailyData];
    }
}

- (void)loadTodayDailyData {
    // 足球模式下无法读取日出数据
    BOOL canReadDaily = YES;
    if ([RawCacheManager sharedRawCacheManager].isBindWristband && [GBBluetoothManager sharedGBBluetoothManager].ibeaconConnectState == iBeaconConnectState_Connected && [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status != iBeaconStatus_Normal) {
        // [self.scrollView.mj_header endRefreshing];
        // [self showToastWithText:LS(@"daily.toast.read.error")];
        canReadDaily = NO;
    }
    
    if (canReadDaily) {
        @weakify(self)
        [[GBBluetoothManager sharedGBBluetoothManager] readMutableCommonModelData:@[[NSDate date]] level:GBBluetoothTask_PRIORITY_Normal serviceBlock:^(id data, NSError *error) {
            
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
                [self loadCurDateDailyData];
                
            }else {
                NSArray<DailyInfo *> *dailyInfoList = [LogicManager dailyInfoListWithDic:data];
                DailyInfo *dailyInfo = dailyInfoList.firstObject;
                if (dailyInfo == nil) {
                    dailyInfo = [[DailyInfo alloc] init];
                }
                self.dailyInfo = dailyInfo;
                
                if ([self isSyncSportData]) {
                    
                    [[GBBluetoothManager sharedGBBluetoothManager] readMutableSportStepData:@[[NSDate date]] level:GBBluetoothTask_PRIORITY_Normal serviceBlock:^(id data, NSError *error) {
                        
                        if (!error) {
                            NSArray<DailyInfo *> *dailySportInfoList = [LogicManager dailySportInfoListWithDic:data];
                            DailyInfo *dailySportInfo = dailySportInfoList.firstObject;
                            
                            self.dailyInfo.sportStep = dailySportInfo.sportStep;
                            self.dailyInfo.sportDistance = dailySportInfo.sportDistance;
                            self.dailyInfo.sportConsume = dailySportInfo.sportConsume;
                            self.dailyInfo.runStep = dailySportInfo.runStep;
                            self.dailyInfo.runDistance = dailySportInfo.runDistance;
                            self.dailyInfo.runConsume = dailySportInfo.runConsume;
                        }
                        
                        [self loadCurDateDailyData];
                    }];
                    
                } else {
                    [self loadCurDateDailyData];
                }
            }
            
        }];
    } else {
        [self loadCurDateDailyData];
    }
}

- (void)loadCurDateDailyData {
    @weakify(self)
    [DailyRequest querySpecifyDailyData:self.curDate.timeIntervalSince1970 handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.scrollView.mj_header endRefreshing];
        if (error) {
            self.curDailySummary = nil;
            [self showToastWithText:error.domain];
        } else {
            self.curDailySummary = result;
            
        }
        [self updateCurDailyUI];
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
