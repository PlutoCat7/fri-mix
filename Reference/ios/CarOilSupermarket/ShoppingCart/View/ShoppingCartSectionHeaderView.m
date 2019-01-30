//
//  ShoppingCartSectionHeaderView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingCartSectionHeaderView.h"

@implementation ShoppingCartSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)actionSelectAll:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSelectAll:)]) {
        [self.delegate didClickSelectAll:self];
    }
}

@end
