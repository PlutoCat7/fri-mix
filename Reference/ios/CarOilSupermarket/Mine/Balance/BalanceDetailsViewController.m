//
//  BalanceDetailsViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BalanceDetailsViewController.h"
#import "WithdrawDetailViewController.h"

#import "MJRefresh.h"
#import "BalanceDetailsCell.h"
#import "PointsNoneCell.h"
#import "UIScrollView+COSEmpty.h"

#import "BalanceDetailsViewModel.h"

@interface BalanceDetailsViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BalanceDetailsViewModel *viewModel;

@end

@implementation BalanceDetailsViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _viewModel = [[BalanceDetailsViewModel alloc] init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"明细";
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BalanceDetailsCell" bundle:nil] forCellReuseIdentifier:@"BalanceDetailsCell"];
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
        return kBalanceDetailsCellHeight;
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
        BalanceDetailsCellModel *model = self.viewModel.cellModels[indexPath.row];
        BalanceDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceDetailsCell"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BalanceDetailsCellModel *model = self.viewModel.cellModels[indexPath.row];
    if (model.canSelect) {
        [self.navigationController pushViewController:[[WithdrawDetailViewController alloc] initWithDetailId:model.detailId] animated:YES];
    }
}

@end
