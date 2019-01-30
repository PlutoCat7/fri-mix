//
//  VouchersViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/14.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MyVouchersViewController.h"
#import "VouchersBuyViewController.h"

#import "MJRefresh.h"
#import "MyVouchersCell.h"
#import "UIScrollView+COSEmpty.h"

#import "MyVouchersViewModel.h"

@interface MyVouchersViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *unUseVouchersView;

@property (nonatomic, strong) MyVouchersViewModel *viewModel;
@property (nonatomic, copy) void(^selectBlock)(NSArray<MyVouchersInfo *> *infos);

@end

@implementation MyVouchersViewController

- (instancetype)init
{
    return [self initWithSelectInfos:nil orderPrice:0 block:nil];
}

- (instancetype)initWithSelectInfos:(NSArray<MyVouchersInfo *> *)selectedInfo orderPrice:(CGFloat)orderPrice block:(void(^)(NSArray<MyVouchersInfo *> *infos))block {
    
    self = [super init];
    if (self) {
        _selectBlock = block;
        _viewModel = [[MyVouchersViewModel alloc] init];
        _viewModel.selectedVouchersInfos = selectedInfo;
        _viewModel.orderPrice = orderPrice;
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

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
}

#pragma mark - Action

- (IBAction)actionUnUseVouchers:(id)sender {
    
    BLOCK_EXEC(self.selectBlock, nil);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"我的代金券";
    [self setupBackButtonWithBlock:nil];
    
    [self setupRightButton];
    [self setupTableView];
    
    _unUseVouchersView.hidden = !self.selectBlock;
}

- (void)setupRightButton {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:CGSizeMake(48, 24)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [button setTitle:@"购买" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    @weakify(self)
    [button addActionHandler:^(NSInteger tag) {
        
        @strongify(self)
        VouchersBuyViewController *vc = [[VouchersBuyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)setupTableView {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyVouchersCell" bundle:nil] forCellReuseIdentifier:@"MyVouchersCell"];
    @weakify(self)
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel getFirstPageDataWithHandler:^(NSError *error) {
            [self handlerRequestWithError:error];
        }];
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.selectBlock?55*kAppScale:0, 0);
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
    
    return self.viewModel.cellModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 115*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 25.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyVouchersCellModel *model = self.viewModel.cellModels[indexPath.row];
    MyVouchersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyVouchersCell"];
    [cell refreshWithModel:model];
    
    return cell;
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
    
    if (self.selectBlock) {
        
        [self.viewModel selectVouchersWithIndexPath:indexPath];
        [self.tableView reloadData];
        BLOCK_EXEC(self.selectBlock, self.viewModel.selectedVouchersInfos);
    }
}

@end
