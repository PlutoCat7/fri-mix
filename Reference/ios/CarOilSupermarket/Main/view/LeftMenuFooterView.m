//
//  LeftMenuFooterView.m
//  MagicBean
//
//  Created by yahua on 16/3/29.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "LeftMenuFooterView.h"

@implementation LeftMenuFooterView

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.topLine.height = 0.5f;
}

- (void)reloadWithBtcPrice:(NSString *)btcPrice {
    
    if ([NSString stringIsNullOrEmpty:btcPrice]) {
        return;
    }
    self.btcPriceLabel.text = btcPrice;
}

@end
