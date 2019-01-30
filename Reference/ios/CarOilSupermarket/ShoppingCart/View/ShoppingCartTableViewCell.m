//
//  ShoppingCartTableViewCell.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingCartTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ShoppingCartTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@property (nonatomic, strong) ShoppingCartModel *model;

@end

@implementation ShoppingCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numberTextField.delegate = self;
}

- (void)refreshWithModel:(ShoppingCartModel *)model {
    
    _model = model;
    if (model.isEdit) {
        self.selectImageView.image = (model.isDeleteSelect)?[UIImage imageNamed:@"shopping_select"]:[UIImage imageNamed:@"shopping_un_select"];
    }else {
        self.selectImageView.image = (model.isSelect)?[UIImage imageNamed:@"shopping_select"]:[UIImage imageNamed:@"shopping_un_select"];
    }
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.goodNameLabel.text = model.title;
    self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.marketprice];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.productprice];
    self.numberTextField.text = @(model.total).stringValue;
}

#pragma mark - Action

- (IBAction)actionReduce:(id)sender {
    
    if ([_model canReduce]) {
        if ([self.delegate respondsToSelector:@selector(reduceGoodsQuantityWithCell:)]) {
            [self.delegate reduceGoodsQuantityWithCell:self];
        }
    }
}

- (IBAction)actionIncrease:(id)sender {
    
    //if ([_model canIncrease]) {
        if ([self.delegate respondsToSelector:@selector(addGoodsQuantityWithCell:)]) {
            [self.delegate addGoodsQuantityWithCell:self];
        }
    //}
}
- (IBAction)actionSelect:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(goodDidSelectWithCell:)]) {
        [self.delegate goodDidSelectWithCell:self];
    }
}

#pragma mark - Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger total = [textField.text integerValue];
    if (total<=0) {
        textField.text = @(_model.total).stringValue;
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeGoodsQuantityWithCell:count:)]) {
        [self.delegate changeGoodsQuantityWithCell:self count:total];
    }
}

@end
