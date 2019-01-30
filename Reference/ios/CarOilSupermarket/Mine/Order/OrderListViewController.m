//
//  OrderListViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderListViewController.h"
#import "PayOrderViewController.h"
#import "OrderDetailViewController.h"

#import "MyOrderTableViewCell.h"
#import "OrderListFooterView.h"
#import "MJRefresh.h"
#import "UIScrollView+COSEmpty.h"

#import "OrderListViewModel.h"
#import "OrderRequest.h"

@interface OrderListViewController () <UITableViewDelegate,
UITableViewDataSource,
OrderListFooterViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) OrderListViewModel *viewModel;
@end

@implementation OrderListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithType:(OrderType)type {
    
    self = [super init];
    if (self) {
        _viewModel = [[OrderListViewModel alloc] initWithType:type];
        @weakify(self)
        [self.yah_KVOController observe:self.viewModel keyPath:@"recordlist" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self.tableView reloadData];
            [self.tableView showEmptyView:self.viewModel.recordlist.count==0];
        }];
    }
    
    return self;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.tableView.frame = self.view.bounds;
    });
}

#pragma mark - Notification

- (void)receivedOrderNotification {
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)deleteOrderNotification {
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Private

- (void)loadPageData {
    
    if (!self.viewModel.recordlist) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)setupUI {
    
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedOrderNotification) name:Notification_Order_Received object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOrderNotification) name:Notification_Order_Delete object:nil];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListFooterView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"OrderListFooterView"];
    
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

#pragma mark  Table Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.viewModel.recordlist.count;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.recordlist[section].goods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95.0f * kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 100.0f*kAppScale;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderRecordGoodsInfo *model = self.viewModel.recordlist[indexPath.section].goods[indexPath.row];
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
    [cell refreshWithModel:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderRecordInfo *info = self.viewModel.recordlist[section];
    OrderListFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderListFooterView"];
    footerView.delegate = self;
    footerView.type = self.viewModel.type;
    footerView.tag = section;
    footerView.countLabel.text = [NSString stringWithFormat:@"共%td件商品", info.goods.count];
    footerView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", info.price];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![self.viewModel isLoadEnd] &&
        self.viewModel.recordlist.count-1 == indexPath.section) {
        [self.viewModel getNextPageDataWithHandler:^(NSError *error) {
            
            [self handlerRequestWithError:error];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderRecordInfo *info = self.viewModel.recordlist[indexPath.section];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] initWithInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - OrderListFooterViewDelegate

- (void)didClickMenu1:(OrderListFooterView *)footerView {
    
    NSInteger section = footerView.tag;
    OrderRecordInfo *info = self.viewModel.recordlist[section];
    switch (self.viewModel.type) {
        case OrderType_PendingPayment:
            [self.navigationController pushViewController:[[PayOrderViewController alloc] initWithOrderId:info.orderId] animated:YES];
            break;
        case OrderType_Delivered:
        {
            NSURL *phone_url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [RawCacheManager sharedRawCacheManager].config.serviceNumber]];
            [[UIApplication sharedApplication] openURL:phone_url];
        }
            break;
        case OrderType_Received:
        {
            @weakify(self)
            [self showLoadingToast];
            [OrderRequest receiptOrderWithOrderId:info.orderId handler:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self.tableView.mj_header beginRefreshing];
                }
            }];
        }
            break;
        case OrderType_Completed:
        {
            @weakify(self)
            [self showLoadingToast];
            [OrderRequest deleteOrderWithOrderId:info.orderId handler:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self.tableView.mj_header beginRefreshing];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)didClickMenu2:(OrderListFooterView *)footerView {
    
    NSInteger section = footerView.tag;
    OrderRecordInfo *info = self.viewModel.recordlist[section];
    if (self.viewModel.type == OrderType_PendingPayment) {
        @weakify(self)
        [self showLoadingToast];
        [OrderRequest cancelOrderWithOrderId:info.orderId handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self.tableView.mj_header beginRefreshing];
            }
        }];
    }
}

@end
