//
//  MyOrderTableViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MyOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end


@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithModel:(OrderRecordGoodsInfo *)model {
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.goodNameLabel.text = model.title;
    self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.marketprice];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.productprice];
    self.countLabel.text = [NSString stringWithFormat:@"X%td", model.total];
}

@end
