//
//  MineArticleViewController.m
//  TiHouse
//
//  Created by admin on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineArticleViewController.h"
#import "MineFindMainContentCell.h"
#import "Login.h"
#import "NSDate+Extend.h"
#import "AssemarcModel.h"
#import "Paginator.h"

static NSString *const articleCellId = @"articleCellId";

@interface MineArticleViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) Paginator *pager;

@end

@implementation MineArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self tableView];
    _dataArray = [[NSMutableArray alloc] init];
    _heightArray = [[NSMutableArray alloc] init];
    
    _pager = [Paginator new];
    _pager.page = 1;
    _pager.perPage = 10;
    _pager.willLoadMore = YES;
    _pager.canLoadMore = YES;
    
    User *user =[Login curLoginUser];
    
    if (user.uid == _uid) {
        self.title = @"我发布的文章";
        [self getOtherData];
    } else {
        self.title = [NSString stringWithFormat:@"%@发布的文章", _u.username];
        [self getOtherData];
    }
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = kRKBViewControllerBgColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        if (@available(iOS 11.0, *)) {
        //            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //            self.automaticallyAdjustsScrollViewInsets = YES;
        //        } else {
        //            self.automaticallyAdjustsScrollViewInsets = NO;
        //        }
        [self.view addSubview:_tableView];
        WEAKSELF
        _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf refreshMore];
        }];
        _tableView.estimatedRowHeight = kRKBHEIGHT(70);
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_heightArray[indexPath.section] floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        MineFindMainContentCell *cell = [tableView dequeueReusableCellWithIdentifier:articleCellId];
        if (!cell) {
            cell = [[MineFindMainContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:articleCellId];
        }
    
        cell.model = _dataArray[indexPath.section];
        return cell;
}

#pragma mark - private method
- (void)getFindData {
    
    if (!_pager.canLoadMore) {
        return;
    }
    
    User *user = [Login curLoginUser];
    WEAKSELF
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/assemarc/page" withParams:@{@"uid": @(user.uid),@"assemarctype": @1, @"start": @((_pager.page - 1) * _pager.perPage), @"limit": @(_pager.perPage)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            
            if ([data[@"allCount"] intValue] > [_dataArray count] + 2) {
                _pager.canLoadMore = YES;
            } else {
                _pager.canLoadMore = NO;
            }
            
            for (NSDictionary *dic in data[@"data"]) {
                AssemarcModel *model = [AssemarcModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:model];
                XWLog(@"current type ___  %d", model.assemarctype );
                // 分别计算高度
                CGFloat height;
                // 文章内容高度
                CGFloat topHeight = kRKBHEIGHT(15 + 40 + 12 + 1 + 10);
                CGFloat titleHeight = [model.assemarctitle getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                CGFloat subTitleHeight = [model.assemarctitlesub getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                CGFloat bottomHeight = kRKBHEIGHT(57);
                height = topHeight + kRKBHEIGHT(175) + titleHeight + subTitleHeight + bottomHeight;
                [_heightArray addObject:@(height)];
            }
            [weakSelf.tableView reloadData];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)getOtherData {
    
    if (!_pager.canLoadMore) {
        return;
    }
    
    User *user = [Login curLoginUser];
    
    
    WEAKSELF
    [[TiHouseNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"/api/inter/assemarc/pageByUidother" withParams:@{@"uid": @(user.uid),@"uidother": @(user.uid),@"assemarctype": @1, @"start": @((_pager.page - 1) * _pager.perPage), @"limit": @(_pager.perPage)} withMethodType:Post autoShowError:YES andBlock:^(id data, NSError *error) {
        if ([data[@"is"] intValue]) {
            
            if ([data[@"allCount"] intValue] > [_dataArray count] + 2) {
                _pager.canLoadMore = YES;
            } else {
                _pager.canLoadMore = NO;
            }
            
            for (NSDictionary *dic in data[@"data"]) {
                AssemarcModel *model = [AssemarcModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:model];
                // 分别计算高度
                CGFloat height;
                // 文章内容高度
                CGFloat topHeight = kRKBHEIGHT(15 + 40 + 12 + 1 + 10);
                CGFloat titleHeight = [model.assemarctitle getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                CGFloat subTitleHeight = [model.assemarctitlesub getHeightWithFont:ZISIZE(14) constrainedToSize:CGSizeMake(kRKBWIDTH(275), MAXFLOAT)];
                CGFloat bottomHeight = kRKBHEIGHT(57);
                height = topHeight + kRKBHEIGHT(175) + titleHeight + subTitleHeight + bottomHeight;
                [_heightArray addObject:@(height)];
            }
            [weakSelf.tableView reloadData];
        } else {
            [NSObject showHudTipStr:data[@"msg"]];
        }
    }];
}

- (void)refreshMore {
    if (!_pager.canLoadMore) {
        [_tableView.mj_footer endRefreshing];
        _tableView.mj_footer.state = MJRefreshStateNoMoreData;
        [_tableView.mj_footer resetNoMoreData];
        return;
    }
    _pager.page = _pager.page + 1;
    
    User *user = [Login curLoginUser];
    if (user.uid == _uid) {
        [self getFindData];
    } else {
        [self getOtherData];
    }
}

@end
