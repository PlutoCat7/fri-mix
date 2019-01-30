//
//  PayOrderViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/15.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "PayOrderViewController.h"
#import "MyOrderViewController.h"
#import "OrderDetailViewController.h"

#import "PayOrderTableViewCell.h"

#import "PayOrderViewModel.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PayOrderViewController () <
UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, strong) PayOrderViewModel *viewModel;

@end

@implementation PayOrderViewController

- (instancetype)initWithOrderId:(NSString *)orderId {
    
    self = [super init];
    if (self) {
        _viewModel = [[PayOrderViewModel alloc] initWithOrderId:orderId];
        @weakify(self)
        [self.yah_KVOController observe:_viewModel keyPath:@"info" block:^(id observer, id object, NSDictionary *change) {
            
            @strongify(self)
            [self refreshUI];
        }];
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

- (IBAction)payAction:(id)sender {
    
    [self.viewModel payWithHanlder:^(NSString *errorMsg) {
       
        if (errorMsg) {
            [self showToastWithText:errorMsg];
        }else {
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers removeLastObject];
            UIViewController *lastVC = viewControllers.lastObject;
            if ([lastVC isKindOfClass:[OrderDetailViewController class]]) {
                [viewControllers removeLastObject];
            }
            lastVC = viewControllers.lastObject;
            if ([lastVC isKindOfClass:[MyOrderViewController class]]) {
                [viewControllers removeLastObject];
            }
            MyOrderViewController *vc = [[MyOrderViewController alloc] initWithIndex:1];
            vc.hidesBottomBarWhenPushed = YES;
            [viewControllers addObject:vc];
            [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
        }
    }];
    
}

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    [self.viewModel getNetData:^(NSError *error) {
        [self dismissToast];
        if (error) {
            [self showToastWithText:error.domain];
        }
    }];
}

- (void)setupUI {
    
    self.title = @"收银台";
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    
    self.payButton.layer.cornerRadius = 8;
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PayOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"PayOrderTableViewCell"];
}

- (void)refreshUI {
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.viewModel.info.order.needPay];
    self.goodsName.text = @"";
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark  Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.info.types.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *imageDic = @{@"21":@"wechat",
                                @"22":@"zhifubao"};
    PayOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayOrderTableViewCell"];
    OrderPaymentTypeInfo *typeInfo = self.viewModel.info.types[indexPath.row];
    NSString *imageName = [imageDic objectForKey:typeInfo.payType];
    cell.typeImageView.image = [UIImage imageNamed:imageName];
    cell.typeName.text = typeInfo.label;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel selectWithIndexpath:indexPath];
}

@end
