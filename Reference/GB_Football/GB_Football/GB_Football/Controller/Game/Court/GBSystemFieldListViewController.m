//
//  GBSystemFieldListViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSystemFieldListViewController.h"
#import "AIMTableViewIndexBar.h"
#import "GBFieldCell.h"
#import "MJRefresh.h"
#import "CourtRequest.h"
#import "GBBaseViewController+Empty.h"
#import <AMapLocationKit/AMapLocationManager.h>

@interface GBSystemFieldListViewController ()<
UITableViewDelegate,
UITableViewDataSource,
AIMTableViewIndexBarDelegate,
UITextFieldDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>
// 表头视图
@property (strong, nonatomic) IBOutlet UIView *tableHeader;
// 表控件
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
// 搜索输入框
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
// 索引条
@property (strong, nonatomic) IBOutlet AIMTableViewIndexBar *indexBar;

//正常显示
@property (nonatomic, strong) NSArray<CourtResponseData *>  *originCourtDataList;
@property (nonatomic, strong) NSArray<CourtResponseData *> *showCourtDataList;

// 定位
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) NSString *cityName;

@end

@implementation GBSystemFieldListViewController

#pragma mark -
#pragma mark Memory

- (void)localizeUI {
    
    self.searchTextField.placeholder = LS(@"create.searchbox.name");
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.tableHeader.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,(208.f/1334)*[UIScreen mainScreen].bounds.size.height);
    [self.tableView setTableHeaderView:self.tableHeader];
}

#pragma mark - Public

- (void)clearSearchResult {
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    if (notification.object != self.searchTextField) {
        return;
    }
    [self searchCourt];
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        //收起键盘
        [self.searchTextField resignFirstResponder];
        return NO;
    }
    return YES;
}

// section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showCourtDataList.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showCourtDataList[section].items.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBFieldCell"];
    CourtInfo *info = self.showCourtDataList[indexPath.section].items[indexPath.row];
    [cell setCourtName:info.courtName address:info.courtAddress];
    return cell;
    
}
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.f;
}

// section的title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.showCourtDataList[section].name;
}

// 设置SectionHeader风格与样式
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= [UIColor blackColor];
    header.textLabel.font = [UIFont fontWithName:header.textLabel.font.fontName size:10.f];
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourtInfo *info = self.showCourtDataList[indexPath.section].items[indexPath.row];
    
    NSDictionary *dic = @{@"court_id":@(info.courtId),
                          @"court_name":info.courtName};
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_SelectedCourt object:nil userInfo:dic];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - AIMTableViewIndexBarDelegate

- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index
{
    if ([self.tableView numberOfSections] > index && index > -1){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

#pragma mark - Action

- (IBAction)actionSearch:(id)sender {
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - Private

-(void)setupUI
{
    self.indexBar.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"GBFieldCell" bundle:nil] forCellReuseIdentifier:@"GBFieldCell"];
    self.tableView.tableHeaderView = self.tableHeader;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor blackColor];
    self.emptyScrollView = self.tableView;
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self getCourtList];
    }];
    mj_header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = mj_header;
    
    self.searchTextField.delegate = self;
}

- (void)initPageData {
    
    [self requestLocation];
}

- (void)analyseData {
    
    NSMutableArray *letterList = [NSMutableArray arrayWithCapacity:1];
    for (CourtResponseData *data in self.originCourtDataList) {
        [letterList addObject:data.name];
    }
    [self.indexBar setIndexes:letterList];

}

- (void)getCourtList {
    
    @weakify(self)
    [CourtRequest getCourtList:@"" type:CourtType_Standard cityName:self.cityName handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self showToastWithText:error.domain];
        }else {
            self.originCourtDataList = result;
            [self analyseData];
            [self searchCourt];
        }
    }];
}

- (void)searchCourt {
    
    NSString *search = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([NSString stringIsNullOrEmpty:search]) {
        self.showCourtDataList = self.originCourtDataList;
    }else {
        NSMutableArray *searchList = [NSMutableArray arrayWithCapacity:1];
        for (CourtResponseData *data in self.originCourtDataList) {
            CourtResponseData *searchData = [CourtResponseData new];
            for (CourtInfo *courtInfo in data.items) {
                if ([courtInfo.courtName containsString:search] || [courtInfo.courtAddress containsString:search]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:searchData.items];
                    [items addObject:courtInfo];
                    searchData.items = [items copy];
                    searchData.name = data.name;
                }
            }
            if (searchData.items.count>0) {
                [searchList addObject:searchData];
            }
        }
        self.showCourtDataList = [searchList copy];
    }
    self.isShowEmptyView = self.showCourtDataList.count == 0;
    [self.tableView reloadData];
}

- (void)requestLocation {
    
    [self showLoadingToastWithText:LS(@"locate.tip.locating")];
    @weakify(self)
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self)
        [self dismissToast];
        if (error) {
            [self showToastWithText:LS(@"locate.tip.failed")];
            self.cityName = @"";
            [self.tableView.mj_header beginRefreshing];
        }else {
            if (location.coordinate.latitude == 0 && location.coordinate.longitude == 0) {
                [self showToastWithText:LS(@"locate.tip.failed")];
                self.cityName = @"";
                [self.tableView.mj_header beginRefreshing];
                return;
            }
            self.cityName = regeocode.city;
            [self getCourtList];
            
            //
            [RawCacheManager sharedRawCacheManager].isHongKong = [regeocode.adcode hasPrefix:HongKongCityCode_Prefix];
            [RawCacheManager sharedRawCacheManager].isMacao = [regeocode.adcode hasPrefix:MacaoCityCode_Prefix];
        }
    }];
}

#pragma mark - Getters & Setters

#pragma mark - Getters & Setters

- (AMapLocationManager *)locationManager {
    
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 定位超时时间，可修改，最小2s
        _locationManager.locationTimeout = 2;
        // 逆地理请求超时时间，可修改，最小2s
        _locationManager.reGeocodeTimeout = 3;
    }
    
    return _locationManager;
}

@end
