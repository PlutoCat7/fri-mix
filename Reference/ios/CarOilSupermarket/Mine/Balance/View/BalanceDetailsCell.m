//
//  BalanceDetailsCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BalanceDetailsCell.h"

#import "BalanceDetailsCellModel.h"

@interface BalanceDetailsCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation BalanceDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(BalanceDetailsCellModel *)model {
    
    self.nameLabel.text = model.name;
    self.moneyLabel.text = model.money;
    self.moneyLabel.textColor = model.moneyColor;
    self.dateLabel.text = model.dateString;
    self.stateLabel.text = model.state;
}

@end
