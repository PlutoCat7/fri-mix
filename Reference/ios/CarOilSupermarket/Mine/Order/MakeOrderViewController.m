//
//  MakeOrderViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/10.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "MakeOrderViewController.h"
#import "PayOrderViewController.h"
#import "ShippingAddressViewController.h"
#import "MyOrderViewController.h"

#import "MakeOrderTableViewCell.h"
#import "MakeOrderPayOptionTableViewCell.h"
#import "MakeOrderHeaderView.h"
#import "MakeOrderFooterView.h"

#import "MakeOrderViewModel.h"

@interface MakeOrderViewController ()<MakeOrderHeaderViewDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *makeButton;

@property (nonatomic, strong) MakeOrderViewModel *viewModel;

@end

@implementation MakeOrderViewController

- (instancetype)initWithConfirmOrderInfo:(ConfirmOrderInfo *)info
{
    self = [super init];
    if (self) {
        _viewModel = [[MakeOrderViewModel alloc] initWithConfirmOrderInfo:info];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"errorMsg" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self showToastWithText:self.viewModel.errorMsg];
        }];
    }
    return self;
}

#pragma mark - Private

- (void)loadData {
    
}

- (void)setupUI {
    
    self.title = @"确认订单";
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    
    [self refreshUI];
    @weakify(self)
    [self.yah_KVOController observe:self.viewModel.payOptionModel keyPaths:@[@"selectVouchersInfos",@"pointSwitchOn",@"balanceSwitchOn"] block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        [self refreshUI];
    }];
}

- (void)refreshUI {
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.viewModel totalPrice]];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MakeOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MakeOrderPayOptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderPayOptionTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MakeOrderHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"MakeOrderHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MakeOrderFooterView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"MakeOrderFooterView"];
}

#pragma mark MakeOrderHeaderViewDelegate

- (void)didClickHeaderView:(MakeOrderHeaderView *)view {
    
    @weakify(self)
    ShippingAddressViewController *vc = [[ShippingAddressViewController alloc] initWithSelectBlock:^(AddressInfo *info) {
        
        @strongify(self)
        self.viewModel.addressInfo = info;
        [self.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionCreate:(id)sender {
    
    [self.viewModel makeOrderWithHandler:^(NSError *error, CreateOrderInfo *orderInfo) {
       
        if (!error) {
            if (!orderInfo.needPay) {
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [viewControllers removeLastObject];
                MyOrderViewController *vc = [[MyOrderViewController alloc] initWithIndex:1];
                vc.hidesBottomBarWhenPushed = YES;
                [viewControllers addObject:vc];
                [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
            }else {
                NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [viewControllers removeLastObject];
                PayOrderViewController *vc = [[PayOrderViewController alloc] initWithOrderId:orderInfo.orderId];
                vc.hidesBottomBarWhenPushed = YES;
                [viewControllers addObject:vc];
                [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
            }
        }
    }];}


#pragma mark  Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = self.viewModel.cellModels.count;
    if ([self.viewModel.payOptionModel isShow]) {
        count += 1;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 105.f*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.viewModel.payOptionModel isShow]) {
        if (indexPath.row == self.viewModel.cellModels.count) {
            return [self.viewModel.payOptionModel showHeight];
        }
    }
    
    return 95.0f * kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 253.0f * kAppScale;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.viewModel.payOptionModel isShow]) {
        if (indexPath.row == self.viewModel.cellModels.count) {
            MakeOrderPayOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderPayOptionTableViewCell"];
            cell.nav = self.navigationController;
            @weakify(self)
            cell.needRefreshTableView = ^{
                @strongify(self)
                [self.tableView reloadData];
            };
            [cell refreshWithModel:self.viewModel.payOptionModel];
            return cell;
        }
    }
    ShoppingCartModel *model = self.viewModel.cellModels[indexPath.row];
    MakeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderTableViewCell"];
    [cell refreshWithModel:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    MakeOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MakeOrderHeaderView"];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.delegate = self;
    [headerView refreshWithModel:self.viewModel.headerModel];

    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    MakeOrderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MakeOrderFooterView"];
    [footerView refreshWithModel:self.viewModel.footerModel];

    return footerView;
}

@end
