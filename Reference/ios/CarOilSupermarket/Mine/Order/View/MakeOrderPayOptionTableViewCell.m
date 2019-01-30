//
//  MakeOrderPayOptionTableViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/23.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MakeOrderPayOptionTableViewCell.h"
#import "MyVouchersViewController.h"

@interface MakeOrderPayOptionTableViewCell ()
    
@property (weak, nonatomic) IBOutlet UILabel *vouchersLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pointSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *balanceSwitch;

@property (weak, nonatomic) IBOutlet UIView *vouchersView;
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UIView *balanceView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voucherViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *balanceViewHeightLayoutConstraint;

@property (nonatomic, strong)MakeOrderPayOptionModel *model;

@end

@implementation MakeOrderPayOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

#pragma mark - Public

- (void)refreshWithModel:(MakeOrderPayOptionModel *)model {
    
    _model = model;
    [self refreshUI];
}

#pragma mark - Action

- (IBAction)actionVoucher:(id)sender {
    
    @weakify(self)
    MyVouchersViewController *vc = [[MyVouchersViewController alloc] initWithSelectInfos:self.model.selectVouchersInfos orderPrice:self.model.orderPrice block:^(NSArray<MyVouchersInfo *> *infos) {
        
        @strongify(self)
        self.model.selectVouchersInfos = infos;
        [self refreshUI];
    }];
    [self.nav pushViewController:vc animated:YES];
}

- (IBAction)switchPoint:(id)sender {
    
    self.model.pointSwitchOn = !self.model.pointSwitchOn;
    self.pointSwitch.on = self.model.pointSwitchOn;
    BLOCK_EXEC(self.needRefreshTableView);
}

- (IBAction)switchBalance:(id)sender {
    
    self.model.balanceSwitchOn = !self.model.balanceSwitchOn;
    self.balanceSwitch.on = self.model.balanceSwitchOn;
}

#pragma mark - Private

- (void)refreshUI {
    
    self.voucherViewHeightLayoutConstraint.constant = self.model.canUseVoucher?50*kAppScale:0;
    self.pointViewHeightLayoutConstraint.constant = self.model.canUsePoint?50*kAppScale:0;
    self.balanceViewHeightLayoutConstraint.constant = self.model.canUseBalance?50*kAppScale:0;
    self.vouchersView.hidden = !self.model.canUseVoucher;
    self.pointView.hidden = !self.model.canUsePoint;
    self.balanceView.hidden = !self.model.canUseBalance;
    
    self.vouchersLabel.text = [NSString stringWithFormat:@"抵扣%td元", (NSInteger)[self.model totalVouchersPrice]];
    self.pointsLabel.text = [NSString stringWithFormat:@"当前%td积分", self.model.usePoint];
    self.pointSwitch.on = self.model.pointSwitchOn;
    self.balanceSwitch.on = self.model.balanceSwitchOn;
    self.balanceLabel.text = [NSString stringWithFormat:@"当前可用余额%.2f元", self.model.useBalance];
}

@end
