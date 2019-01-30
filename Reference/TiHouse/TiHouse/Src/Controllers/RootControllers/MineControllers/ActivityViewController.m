//
//  ActivityViewController.m
//  TiHouse
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityDetailTableViewCell.h"
#import "Paginator.h"
#import "TweetDetailsViewController.h"
#import "FindPhotoDetailViewController.h"
#import "FindArticleDetailViewController.h"
#import "AssemarcModel.h"
#import "House.h"

@interface ActivityViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) NSMutableArray *assemarcs;
@property (nonatomic, strong) Paginator *pager;
@property (nonatomic, strong) House *house;
@end

@implementation ActivityViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self wr_setNavBarBarTintColor:kColorWhite];

    if (!_activities) {
        _activities = [NSMutableArray array];
    }
    if (!_assemarcs) {
        _assemarcs = [NSMutableArray array];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self tableView];
    if (self.houseid) {
        self.title = [NSString stringWithFormat:@"%@ 的动态", self.housename];
        // Mark: 获取House用于编辑按钮判断
        [[TiHouse_NetAPIManager sharedManager]request_HouseInfoWithPath:@"api/inter/house/get" Params:@{@"houseid":[NSString stringWithFormat:@"%ld",_houseid]} Block:^(id data, NSError *error) {
            if (data) {
                self.house = data;
//                weakSelf.house.edit = YES;
                [self getHouseIdTime];
            }
        }];
    } else {
        self.title = @"发现的动态";
        [self getMyConcern];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundView = [UIView new];
        _tableView.backgroundColor = XWColorFromHex(0xF8F8F8);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
        }];
        WEAKSELF
        if (self.houseid) {
            _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                [weakSelf refreshMoreMyConcern];
            }];
        } else {
            _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                [weakSelf refreshMoreHouseIdTime];
            }];
        }
    }
    return _tableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRKBHEIGHT(10);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.houseid) {
        return [_activities count];
    } else {
        return [_assemarcs count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return kRKBHEIGHT(80);
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.houseid) {
        NSDictionary *dic = _activities[indexPath.row];
        if ([@[@1, @2, @3, @4, @5] containsObject:dic[@"logdairyopetype"]]) {
            [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/dairy/getnew" withParams:@{@"dairyid":dic[@"dairyid"]} withMethodType:(Post) autoShowError:YES andBlock:^(id data, NSError *error) {
                if (SHVALUE(data)[@"is"].intValue == 1) {
                    TweetDetailsViewController *TweetDetailsVC = [[TweetDetailsViewController alloc] init];
                    House *house = [[House alloc] init];
                    house.houseid = [dic[@"houseid"] longValue];
                    TweetDetailsVC.title = self.housename;
                    TweetDetailsVC.house = self.house;
                    TweetDetailsVC.dairyid = [dic[@"dairyid"] longValue];
                    TweetDetailsVC.modelDairy = [modelDairy mj_objectWithKeyValues:data[@"data"]];
                    [self.navigationController pushViewController:TweetDetailsVC animated:YES];
                }
            }];
        }
    } else {
        AssemarcModel *assemarc = [_assemarcs objectAtIndex:indexPath.row];
        if ([@[@1, @2, @3, @5] containsObject:[NSNumber numberWithInt:assemarc.logassemarcopetype]]) {
            WEAKSELF
            [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/assemarc/get" withParams:@{@"assemarcid":[NSString stringWithFormat:@"%ld", assemarc.assemarcid]} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
                if ([data[@"is"] intValue]) {
                    FindAssemarcInfo *info = [FindAssemarcInfo yy_modelWithJSON:[data objectForKey:@"data"]];
                    if (assemarc.assemarctype == 1) {
                        FindArticleDetailViewController *findArticleDetailViewController = [[FindArticleDetailViewController alloc] initWithAssemarcInfo:info];
                        [weakSelf.navigationController pushViewController:findArticleDetailViewController animated:YES];
                    } else {
                        FindPhotoDetailViewController *fpdvc = [[FindPhotoDetailViewController alloc] initWithAssemarcInfo:info];
                        [weakSelf.navigationController pushViewController:fpdvc animated:YES];
                    }
                } else {
                    NSLog(@"%@", error);
                }
            }];
        }
    }
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
        static NSString *cellId = @"cellId";
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (self.houseid) {
            cell.activity = [_activities objectAtIndex:indexPath.row];
        } else {
            cell.assemarc = [_assemarcs objectAtIndex:indexPath.row];
        }
        cell.topLineStyle = CellLineStyleNone;
        cell.bottomLineStyle = CellLineStyleNone;
        return cell;
}

-(void) getHouseIdTime {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger time = [date timeIntervalSince1970];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/logdairyope/pageByHouseidTime" withParams:@{@"houseid":[NSString stringWithFormat:@"%ld", self.houseid], @"start": [NSString stringWithFormat:@"%d", 0], @"limit": [NSString stringWithFormat:@"%d", 10], @"lasttime": [NSString stringWithFormat:@"%ld", (long)time]} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([data[@"is"] intValue]) {
            [_activities addObjectsFromArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }]; 
}

-(void) getMyConcern {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger time = [date timeIntervalSince1970];
    WEAKSELF
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"/api/inter/logassemarc/pageMyconcernByTime" withParams:@{@"start": [NSString stringWithFormat:@"%d", 0], @"limit": [NSString stringWithFormat:@"%d", 10]} withMethodType:Get autoShowError:YES andBlock:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([data[@"is"] intValue]) {
            _assemarcs = [AssemarcModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)refreshMoreHouseIdTime {
    if (!_pager.canLoadMore) {
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _pager.page = _pager.page + 1;
    [self getHouseIdTime];
}

- (void)refreshMoreMyConcern {
    if (!_pager.canLoadMore) {
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _pager.page = _pager.page + 1;
    [self getMyConcern];
}

@end
