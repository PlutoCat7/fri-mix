//
//  AddTallyLocationViewController.m
//  TiHouse
//
//  Created by AlienJunX on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AddTallyLocationViewController.h"
#import "AddTallyLocationViewCell.h"
#import "Location.h"
#import "AJLocationManager.h"

@interface AddTallyLocationViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (weak, nonatomic) UIView *headerView;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageLimit;
@property (strong, nonatomic) NSString *keyWord;
@property (nonatomic)CLLocationCoordinate2D locationCoordinate2D;
@property (strong, nonatomic) NSString *cityName;
@end

@implementation AddTallyLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    
    [self setup];
    
    [self.tableView registerClass:[AddTallyLocationViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.pageNum = 1;
    self.pageLimit = 20;
    
    
    WEAKSELF
    [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        weakSelf.locationCoordinate2D = locationCorrrdinate;
    } withCity:^(NSString *cityName) {
        weakSelf.cityName = cityName;
        weakSelf.keyWord = cityName;
    } completion:^{
        [weakSelf loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf.dataList count] <= 0) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        weakSelf.pageNum += 1;//下一页
        [weakSelf loadData];
    }];
}

- (void)loadData {
    
    WEAKSELF
    
    [[TiHouse_NetAPIManager sharedManager] requestLocationList:self.pageNum limit:self.pageLimit lng:weakSelf.locationCoordinate2D.longitude lat:weakSelf.locationCoordinate2D.latitude keyStr:weakSelf.keyWord cityName:weakSelf.cityName Block:^(id data, NSError *error) {
        if (data) {
            if (weakSelf.pageNum == 1) {
                [weakSelf.dataList removeAllObjects];
            }
            [weakSelf.dataList addObjectsFromArray:data];
            [weakSelf.tableView reloadData];
        }
        
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)setup {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavigationBarHeight);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    
    // headerview
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    [self.tableView setTableHeaderView:headerView];
    self.headerView = headerView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.placeholder = @"搜索附近位置";
    searchBar.delegate = self;
    [self.headerView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerView);
    }];
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [searchBar resignFirstResponder];
        
        // search
        self.keyWord = searchBar.text;
        self.pageNum = 1;
        [self loadData];
        return NO;
    }
    return YES;
}

#pragma mark - uitableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddTallyLocationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        [cell setNoInfo];
    } else {
        Location *location = self.dataList[indexPath.row];
        [cell setInfo:location.name desc:location.address];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (_block) {
            self.block(nil);
        }
        
    } else {
        Location *location = self.dataList[indexPath.row];
        if (_block) {
            self.block(location);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
