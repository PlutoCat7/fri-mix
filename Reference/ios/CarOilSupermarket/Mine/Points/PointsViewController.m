//
//  PointsViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "PointsViewController.h"
#import "PointsDescViewController.h"

#import "MJRefresh.h"
#import "PointsCell.h"
#import "PointsNoneCell.h"
#import "UIScrollView+COSEmpty.h"

#import "PointsViewModel.h"

@interface PointsViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PointsViewModel *viewModel;

@end

@implementation PointsViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _viewModel = [[PointsViewModel alloc] init];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"cellModels" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView showEmptyView:self.viewModel.cellModels.count==0];
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Action

- (void)rightBarItemAction {
    
    PointsDescViewController *vc = [[PointsDescViewController alloc] initWithInfos:_viewModel.infos];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"积分记录";
    [self setupBackButtonWithBlock:nil];
    
    [self setupRightButton];
    [self setupTableView];
}

- (void)setupRightButton {
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"积分规则?" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction)];
    [rightBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.f],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PointsCell" bundle:nil] forCellReuseIdentifier:@"PointsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PointsNoneCell" bundle:nil] forCellReuseIdentifier:@"PointsNoneCell"];
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel getFirstPageDataWithHandler:^(NSError *error) {
            [self handlerRequestWithError:error];
        }];
    }];
    self.tableView.mj_header = mj_header;
}

- (void)handlerRequestWithError:(NSError *)error {
    
    [self.tableView.mj_header endRefreshing];
    if (error) {
        [self showToastWithText:error.domain];
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.viewModel.cellModels.count>0) {
        return self.viewModel.cellModels.count + 1;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row<self.viewModel.cellModels.count) {
        return kPointsCellHeight;
    }else {
        return kPointsNoneCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row<self.viewModel.cellModels.count) {
        PointsCellModel *model = self.viewModel.cellModels[indexPath.row];
        PointsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointsCell"];
        [cell refreshWithModel:model];
        
        return cell;
    }else {
        PointsNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointsNoneCell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.viewModel isLoadEnd] &&
        self.viewModel.cellModels.count-1 == indexPath.row) {
        [self.viewModel getNextPageDataWithHandler:^(NSError *error) {
            
            [self handlerRequestWithError:error];
        }];
    }
}

@end
