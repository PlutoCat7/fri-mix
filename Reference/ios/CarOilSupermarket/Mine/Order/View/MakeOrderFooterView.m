//
//  MakeOrderFooterView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/15.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "MakeOrderFooterView.h"

@interface MakeOrderFooterView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendWay;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPricaLabel;

@property (nonatomic, strong) MakeOrderFooterModel *model;

@end

@implementation MakeOrderFooterView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)refreshWithModel:(MakeOrderFooterModel *)model {
    
    self.model = model;
    
    self.priceLabel.text = model.freight;
    self.sendWay.text = model.sendWay;
    self.goodsCountLabel.text = model.goodsCount;
    self.totalPricaLabel.text = model.totalPrice;
}

- (void)textFieldDidChange {
    
    self.model.message = self.messageTextField.text;
}

@end
