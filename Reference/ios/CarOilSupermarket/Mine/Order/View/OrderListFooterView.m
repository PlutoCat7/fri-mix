//
//  OrderListFooterView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/17.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderListFooterView.h"

@interface OrderListFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;


@end

@implementation OrderListFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setType:(OrderType)type {
    
    self.button2.hidden = YES;
    self.button2.layer.borderWidth = 0.5f;
    self.button2.layer.cornerRadius = 6.0f;
    self.button2.layer.borderColor = [UIColor colorWithHex:0x2e2f30].CGColor;
    [self.button2 setTitleColor:[UIColor colorWithHex:0x2e2f30] forState:UIControlStateNormal];
    
    self.button1.layer.borderWidth = 0.5f;
    self.button1.layer.cornerRadius = 6.0f;
    self.button1.layer.borderColor = [UIColor colorWithHex:0x2e2f30].CGColor;
    [self.button1 setTitleColor:[UIColor colorWithHex:0x2e2f30] forState:UIControlStateNormal];
    switch (type) {
        case OrderType_PendingPayment:
            self.button2.hidden = NO;
            [self.button2 setTitle:@"取消订单" forState:UIControlStateNormal];
            self.button1.layer.borderColor = [UIColor colorWithHex:0xF9623D].CGColor;
            [self.button1 setTitle:@"付款" forState:UIControlStateNormal];
            [self.button1 setTitleColor:[UIColor colorWithHex:0xF9623D] forState:UIControlStateNormal];
            break;
        case OrderType_Delivered:
            [self.button1 setTitle:@"联系客服" forState:UIControlStateNormal];
            break;
        case OrderType_Received:
            [self.button1 setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
        case OrderType_Completed:
            [self.button1 setTitle:@"删除订单" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (IBAction)aactionButton1:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickMenu1:)]) {
        [self.delegate didClickMenu1:self];
    }
}

- (IBAction)antionButton2:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickMenu2:)]) {
        [self.delegate didClickMenu2:self];
    }
}

@end
