//
//  ShoppingCartModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel

- (BOOL)canIncrease {
    
    if (self.maxbuy == 0 && self.total<self.stock) {  //不限制
        return YES;
    }else if (self.total<self.maxbuy && self.total<self.stock) {
        return YES;
    }
    
    return NO;
}

- (BOOL)canReduce {
    
    if (self.total>1) {
        return YES;
    }
    return NO;
}

- (CGFloat)goodsTotalPrice {
    
    return self.total*self.marketprice;
}

@end
