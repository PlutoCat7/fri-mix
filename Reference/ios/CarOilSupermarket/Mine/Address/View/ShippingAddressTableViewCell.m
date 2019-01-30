//
//  ShippingAddressTableViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShippingAddressTableViewCell.h"

@interface ShippingAddressTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;  //是否为默认地址

@end

@implementation ShippingAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self localizeUI];
}

- (void)localizeUI {
    
    self.editButton.layer.cornerRadius = 3.0f;
    self.editButton.layer.borderWidth = .5f;
    self.editButton.layer.borderColor = [UIColor colorWithHex:0x5B5C5D].CGColor;
    
    self.deleteButton.layer.cornerRadius = 3.0f;
    self.deleteButton.layer.borderWidth = .5f;
    self.deleteButton.layer.borderColor = [UIColor colorWithHex:0x5B5C5D].CGColor;
}

- (void)refreshWithAddressModel:(AddressModel *)model {
    
    self.userNameLabel.text = model.realname;
    self.phoneLabel.text = model.mobile;
    self.addressLabel.text = model.allAddress;
    self.defaultButton.selected = model.isdefault;
}

#pragma mark - Action

- (IBAction)actionDefault:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickDefaultCell:)]) {
        [self.delegate didClickDefaultCell:self];
    }
}

- (IBAction)actionEdit:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickEditCell:)]) {
        [self.delegate didClickEditCell:self];
    }
}

- (IBAction)actionDelete:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickDeleteCell:)]) {
        [self.delegate didClickDeleteCell:self];
    }
}

@end
