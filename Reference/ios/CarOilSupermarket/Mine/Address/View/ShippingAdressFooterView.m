//
//  ShippingAdressFooterView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShippingAdressFooterView.h"

@implementation ShippingAdressFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)actionClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickShippingAdressFooterView)]) {
        [self.delegate didClickShippingAdressFooterView];
    }
}

@end
