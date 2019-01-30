//
//  WithdrawDetailViewController.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "WithdrawDetailViewController.h"
#import "WithdrawDetailViewModel.h"

@interface WithdrawDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomBankLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;


@property (nonatomic, strong) WithdrawDetailViewModel *viewModel;

@end

@implementation WithdrawDetailViewController

- (instancetype)initWithDetailId:(NSInteger)detailId {
    
    self = [super init];
    if (self) {
        _viewModel = [[WithdrawDetailViewModel alloc] initWithDetailId:detailId];
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

#pragma mark - Private

- (void)loadData {
    
    [self showLoadingToast];
    @weakify(self)
    [_viewModel getDetailInfoHanlder:^(NSString *errorMsg) {
       
        @strongify(self)
        [self dismissToast];
        if (errorMsg) {
            [self showToastWithText:errorMsg];
        }else {
            [self refreshUI];
        }
    }];
}

- (void)setupUI {
    
    self.title = @"提现详情";
    [self setupBackButtonWithBlock:nil];
    
}

- (void)refreshUI {
    
    self.bankLabel.text = _viewModel.detailModel.bank;
    self.moneyLabel.text = _viewModel.detailModel.money;
    self.statusLabel.text = _viewModel.detailModel.status;
    self.nameLabel.text = _viewModel.detailModel.userName;
    self.bottomBankLabel.text = _viewModel.detailModel.bank;
    self.accountLabel.text = _viewModel.detailModel.account;
    self.mobileLabel.text = _viewModel.detailModel.mobile;
    self.createTimeLabel.text = _viewModel.detailModel.createDateString;
    self.contactLabel.text = _viewModel.detailModel.contactUs;
}
@end
