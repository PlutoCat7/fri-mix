//
//  FollowingViewController.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/15.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "FollowingViewController.h"
#import "FollowTableViewCell.h"
#import "MineFindMainOtherViewController.h"
#import "Login.h"
#import "Paginator.h"
#import "User.h"
#import "PersonProfileViewController.h"

@interface FollowingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Paginator *pager;
@end

@implementation FollowingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"我关注的喵友";
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = _navTitle;
    if (!_pager) {
        _pager = [Paginator new];
        _pager.page = 1;
        _pager.perPage = 10;
        _pager.willLoadMore = YES;
        _pager.canLoadMore = YES;
    }
    if (!_followings) {
        _followings = [NSMutableArray array];
    }
    [self tableView];
    [self getFollowings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_followings count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[FollowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.bottomLineStyle = CellLineStyleDefault;
    cell.user = [User mj_objectWithKeyValues:_followings[indexPath.row]];
    cell.isBtnShow = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kRKBHEIGHT(80);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonProfileViewController *mfmVC = [PersonProfileViewController new];
    User *user = [User mj_objectWithKeyValues:_followings[indexPath.row]];
    mfmVC.uid = user.uid;
//    mfmVC.uid = user.uid;
//    mfmVC.other = user;
//    WEAKSELF
//    mfmVC.reloadBlock = ^{
//        [weakSelf reloadFollowings];
//    };
    [self.navigationController pushViewController:mfmVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - getters and setters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0));
        }];
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        WEAKSELF
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf refreshMore];
        }];
    }
    return _tableView;
}

- (void)reloadFollowings {
    // reset
    _pager.page = 1;
    _pager.willLoadMore = YES;
    _pager.canLoadMore = YES;
    [_followings removeAllObjects];
    [self getFollowings];
}

-(void)getFollowings{
//    [_config setObject:@(YES) forKey:@"isLoading"];
//    User *user = [Login curLoginUser];
    if (_followings.count <= 0) {
//        [self.view beginLoading];
    }
    if (!_pager.canLoadMore) {
        return;
    }
    WEAKSELF
    
    NSDictionary *params = @{@"uidother":@(_uid), @"start": [NSString stringWithFormat:@"%ld", (_pager.page - 1) * _pager.perPage], @"limit": [NSString stringWithFormat:@"%ld", (long)_pager.perPage]};
    
    [[TiHouseNetAPIClient changeJsonClient] requestJsonDataWithPath:@"api/inter/user/pageFollowingByUid" withParams:params withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([data[@"is"] intValue]) {
            if ([data[@"allCount"] intValue] > [_followings count] + 2) {
                _pager.canLoadMore = YES;
            } else {
                _pager.canLoadMore = NO;
            }
            [_followings addObjectsFromArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)refreshMore {
    // _config.isLoading ||
    if (!_pager.canLoadMore) {
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _pager.page = _pager.page + 1;
    [self getFollowings];
}

@end

