//
//  GBDailyDetailViewController.m
//  GB_Football
//
//  Created by gxd on 17/6/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBDailyDetailViewController.h"
#import "GBMenuViewController.h"

#import "GBDailyDetailCell.h"
#import "GBBluetoothManager.h"

@interface GBDailyDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dateStLbl;
@property (weak, nonatomic) IBOutlet UILabel *stepStLbl;
@property (weak, nonatomic) IBOutlet UILabel *mileageStLbl;
@property (weak, nonatomic) IBOutlet UILabel *calorieStLbl;

@property (nonatomic, strong) NSMutableArray<DailyInfo *> *dataList;
@property (nonatomic, copy) NSString *navTitle;

@end

@implementation GBDailyDetailViewController


#pragma mark -
#pragma mark Memory

- (void)localizeUI {
    self.dateStLbl.text = LS(@"week.label.date");
    self.stepStLbl.text = LS(@"week.label.step");
    self.mileageStLbl.text = LS(@"week.label.mileage");
    self.calorieStLbl.text = LS(@"week.label.calorie");
}

- (void)dealloc{
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

- (instancetype)initWithData:(NSArray *)data title:(NSString *)title {
    self = [super init];
    if (self) {
        _navTitle = title;
        _dataList = [NSMutableArray arrayWithArray:data];
    }
    return self;
}

- (BOOL)isShowSportData {
    return ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S
            && [RawCacheManager sharedRawCacheManager].userInfo.config.match_add_dail == 1
            && [[GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion floatValue] > 2.1 + 0.0001);
}

#pragma mark - Delegate
// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBDailyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBDailyDetailCell"];
    DailyInfo *dailyInfo = self.dataList[indexPath.row];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dailyInfo.date];
    cell.dateLabel.text = [NSString stringWithFormat:@"%02td / %02td", date.month, date.day];
    
    float distance = 0.f;
    NSInteger step = 0;
    float consume = 0.f;
    if ([self isShowSportData]) {
        distance = dailyInfo.totalDistance;
        step = dailyInfo.totalStep;
        consume = dailyInfo.totalConsume;
    } else {
        distance = dailyInfo.dailyAndRunDistance;
        step = dailyInfo.dailyAndRunStep;
        consume = dailyInfo.dailyAndRunConsume;
    }
    
    cell.stepLabel.text = @(step).stringValue;
    cell.kcalLabel.text = [NSString stringWithFormat:@"%.1f", consume];
    
    if (distance < 1000) {
        cell.meterLabel.text = [NSString stringWithFormat:@"%.1f", distance];
        cell.distanceStLbl.text = LS(@"week.label.item.m");
    } else {
        cell.meterLabel.text = [NSString stringWithFormat:@"%.1f", distance/1000];
        cell.distanceStLbl.text = LS(@"week.label.item.km");
    }
    
    return cell;
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = self.navTitle;
    [self setupBackButtonWithBlock:nil];
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBDailyDetailCell" bundle:nil] forCellReuseIdentifier:@"GBDailyDetailCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView reloadData];
}

@end
