//
//  PayOrderTableViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/15.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "PayOrderTableViewCell.h"

@interface PayOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation PayOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectButton.selected = selected;
}

@end
