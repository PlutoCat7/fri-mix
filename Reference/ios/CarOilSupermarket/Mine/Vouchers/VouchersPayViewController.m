//
//  VouchersPayViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersPayViewController.h"

#import "PayOrderTableViewCell.h"

#import "VouchersPayViewModel.h"

@interface VouchersPayViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, strong) VouchersPayViewModel *viewModel;

@end

@implementation VouchersPayViewController

- (instancetype)initWithNumber:(NSInteger)number
                     showPrice:(CGFloat)showPrice
                      payPrice:(NSInteger)payPrice
                    paymentOpt: (NSArray<VouchersPaymentTypeInfo *> *)paymentOpt {
    
    self = [super init];
    if (self) {
        _viewModel = [[VouchersPayViewModel alloc] init];
        _viewModel.number = number;
        _viewModel.showPrice = showPrice;
        _viewModel.payPrice = payPrice;
        _viewModel.paymentOpt = paymentOpt;
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

- (IBAction)payAction:(id)sender {
    
    [self.viewModel payWithHanlder:^(NSString *errorMsg) {
        
        if (errorMsg) {
            [self showToastWithText:errorMsg];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Vouchers_Buy_Success object:nil];
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers removeLastObject];
            [viewControllers removeLastObject];
            [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
        }
    }];
    
}

- (void)setupUI {
    
    self.title = @"收银台";
    [self setupBackButtonWithBlock:nil];
    
    [self setupTableView];
    
    self.payButton.layer.cornerRadius = 8;
    
    [self refreshUI];
}

- (void)setupTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PayOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"PayOrderTableViewCell"];
}

- (void)refreshUI {
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.viewModel totalPrice]];
    
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.viewModel selectWithIndexpath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark  Table Delegate

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.viewModel.paymentOpt.count;
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *imageDic = @{@"21":@"wechat",
                               @"22":@"zhifubao",
                               @"1":@"daijinquan_yier"
                               };
    PayOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayOrderTableViewCell"];
    VouchersPaymentTypeInfo *typeInfo = self.viewModel.paymentOpt[indexPath.row];
    NSString *imageName = [imageDic objectForKey:typeInfo.payType];
    cell.typeImageView.image = [UIImage imageNamed:imageName];
    cell.typeName.text = typeInfo.label;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel selectWithIndexpath:indexPath];
}

@end
