//
//  MakeOrderTableViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/11.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "MakeOrderTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MakeOrderTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (nonatomic, strong) ShoppingCartModel *model;


@end

@implementation MakeOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numberTextField.userInteractionEnabled = NO;
}

- (void)refreshWithModel:(ShoppingCartModel *)model {
    
    _model = model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.goodNameLabel.text = model.title;
    self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.marketprice];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.productprice];
    self.numberTextField.text = [NSString stringWithFormat:@"X%td", model.total];
}

@end
