//
//  OrderDetailViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/17.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PayOrderViewController.h"

#import "MakeOrderTableViewCell.h"
#import "MakeOrderHeaderView.h"
#import "OrderDetailFooterView.h"

#import "OrderRequest.h"

@interface OrderDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) OrderRecordInfo *recordInfo;

@end

@implementation OrderDetailViewController

- (instancetype)initWithInfo:(OrderRecordInfo *)recordInfo {
    
    self = [super init];
    if (self) {
        _recordInfo = recordInfo;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)ActionDone:(id)sender {
    
    switch (self.recordInfo.status) {
        case OrderType_PendingPayment:
            [self.navigationController pushViewController:[[PayOrderViewController alloc] initWithOrderId:self.recordInfo.orderId] animated:YES];
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
            [OrderRequest receiptOrderWithOrderId:self.recordInfo.orderId handler:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    self.recordInfo.status = OrderType_Completed;
                    [self.doneButton setTitle:@"删除" forState:UIControlStateNormal];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Order_Received object:nil];
                }
            }];
        }
            break;
        case OrderType_Completed:
        {
            @weakify(self)
            [self showLoadingToast];
            [OrderRequest deleteOrderWithOrderId:self.recordInfo.orderId handler:^(id result, NSError *error) {
                
                @strongify(self)
                [self dismissToast];
                if (error) {
                    [self showToastWithText:error.domain];
                }else {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Order_Delete object:nil];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"订单详情";
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    
    self.doneButton.layer.borderWidth = 0.5f;
    self.doneButton.layer.cornerRadius = 6.0f;
    self.doneButton.layer.borderColor = [UIColor colorWithHex:0x58595A].CGColor;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.recordInfo.price];
    switch (self.recordInfo.status) {
        case OrderType_PendingPayment:
            [self.doneButton setTitle:@"付款" forState:UIControlStateNormal];
            break;
        case OrderType_Delivered:
            [self.doneButton setTitle:@"联系客服" forState:UIControlStateNormal];
            break;
        case OrderType_Received:
            [self.doneButton setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
        case OrderType_Completed:
            [self.doneButton setTitle:@"删除" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MakeOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MakeOrderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MakeOrderHeaderView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"MakeOrderHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailFooterView" bundle:nil]forHeaderFooterViewReuseIdentifier:@"OrderDetailFooterView"];
}

#pragma mark  Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recordInfo.goods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 105.f*kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95.0f * kAppScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 245.0f*kAppScale;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderRecordGoodsInfo *goodsInfo = self.recordInfo.goods[indexPath.row];
    ShoppingCartModel *model = [[ShoppingCartModel alloc] init];
    model.thumb = goodsInfo.thumb;
    model.title = goodsInfo.title;
    model.marketprice = goodsInfo.price;
    model.productprice = goodsInfo.productprice;
    model.total = goodsInfo.total;
    MakeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MakeOrderTableViewCell"];
    [cell refreshWithModel:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MakeOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MakeOrderHeaderView"];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.nextPageImageView.hidden = YES;
    MakeOrderHeaderModel *model = [[MakeOrderHeaderModel alloc] init];
    model.receiverName = self.recordInfo.address.realname;
    model.phone = self.recordInfo.address.mobile;
    model.address = [NSString stringWithFormat:@"%@%@%@%@", self.recordInfo.address.province, self.recordInfo.address.city, self.recordInfo.address.area, self.recordInfo.address.address];
    [headerView refreshWithModel:model];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    OrderDetailFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderDetailFooterView"];
    footerView.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.recordInfo.price];
    footerView.freightLabel.text = [NSString stringWithFormat:@"￥%.2f", self.recordInfo.freight];
    footerView.remarkLabel.text = self.recordInfo.remark;
    footerView.expresscomLabel.text = self.recordInfo.expresscom;
    footerView.expresssnLabel.text = self.recordInfo.expresssn;
    footerView.timeLabel.text = self.recordInfo.paytime;
    
    return footerView;
}


@end
