//
//  BalanceViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BalanceViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "BalanceDetailsViewController.h"

@interface BalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.rechargeButton.layer.cornerRadius = 5.0f;
    self.withdrawButton.layer.cornerRadius = 5.0f;
    self.withdrawButton.layer.borderColor = [UIColor colorWithHex:0xDADBDD].CGColor;
    self.withdrawButton.layer.borderWidth = 0.5f;
}

#pragma mark - Action

- (IBAction)actionRecharge:(id)sender {
    
    RechargeViewController *vc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionWithdraw:(id)sender {
    
    WithdrawViewController *vc = [[WithdrawViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = @"余额";
    [self setupBackButtonWithBlock:nil];
    
    [self setupRightButton];
}

- (void)setupRightButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setSize:CGSizeMake(48, 24)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [button setTitle:@"明细" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    @weakify(self)
    [button addActionHandler:^(NSInteger tag) {
        
        @strongify(self)
        BalanceDetailsViewController *vc = [[BalanceDetailsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)refreshUI {
    
    self.balanceLabel.text = [NSString stringWithFormat:@"¥ %.2f", [RawCacheManager sharedRawCacheManager].userInfo.balance];
    self.withdrawButton.hidden = ![RawCacheManager sharedRawCacheManager].userInfo.canWithdraw;
}

@end
