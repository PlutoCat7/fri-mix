//
//  HouseNewsViewController.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "HouseNewsViewController.h"
#import "HouseNewsTableViewCell.h"
#import "UITableView+EmptyData.h"
#import "Paginator.h"
#import "Login.h"

@interface HouseNewsViewController ()<UITableViewDelegate, UITableViewDataSource, HouseNewsDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Paginator *pager;
@property (nonatomic, strong) NSMutableArray *houses;

@end

@implementation HouseNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"房屋动态";
    
    _pager = [[Paginator alloc] init];
    _pager.page = 1;
    _pager.perPage = 10;
    _pager.willLoadMore = YES;
    _pager.canLoadMore = YES;
    
    _houses = [[NSMutableArray alloc] init];
    
    [self tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getHouseActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters && setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(@(kNavigationBarHeight));
        }];
        WEAKSELF
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf refreshMore];
        }];
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [tableView tableViewDisplayWitMsg:@"暂无相关房屋信息" ifNecessaryForRowCount:[_houses count]];
    return [_houses count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    HouseNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HouseNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_houses.count > 0) {
        cell.switchControl.on = [_houses[indexPath.row][@"housepersonisrecei"] boolValue];
        [cell.portraitImgv sd_setImageWithURL:[NSURL URLWithString:_houses[indexPath.row][@"urlfront"]]];
        cell.titleLabel.text = _houses[indexPath.row][@"housename"];
        cell.houseid = _houses[indexPath.row][@"houseid"];
    }
    cell.delegate = self;
    cell.topLineStyle = cell.bottomLineStyle = CellLineStyleFill;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private method
- (void)getHouseActivity {
    User *user = [Login curLoginUser];
    if (_houses.count <= 0) {
        [self.view beginLoading];
    }
    if (!_pager.canLoadMore) {
        return;
    }
    WEAKSELF
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/house/pageByUid" withParams:@{@"start": @((_pager.page - 1) * _pager.perPage), @"limit": @(_pager.perPage), @"uid": @(user.uid)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        [weakSelf.view endLoading];
        [weakSelf.tableView.mj_footer endRefreshing];
        if ([data[@"is"] intValue]) {
            NSLog(@"--- %@",data);
            if ([data[@"allCount"] intValue] > [_houses count] + 2) {
                _pager.canLoadMore = YES;
            } else {
                _pager.canLoadMore = NO;
            }
            [_houses addObjectsFromArray:data[@"data"]];
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
    [self getHouseActivity];
}

#pragma mark - HouseNewsDelegate
-(void)editIsreceiOpen:(HouseNewsTableViewCell *)cell {    
    
    User *user = [Login curLoginUser];
    
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/houseperson/editIsreceiOpen" withParams:@{@"uid": @(user.uid), @"houseid": cell.houseid} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)editIsreceiClose:(HouseNewsTableViewCell *)cell {
    User *user = [Login curLoginUser];
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/houseperson/editIsreceiClose" withParams:@{@"uid": @(user.uid), @"houseid": cell.houseid} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            [NSObject showHudTipStr:data[@"msg"]];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];

}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
