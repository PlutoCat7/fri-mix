//
//  VouchersBuyCellModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/16.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersBuyCellModel.h"

@implementation VouchersBuyCellModel

- (BOOL)isEnable {
    
    if (self.maxBuyCount>self.buyCount) {
        return YES;
    }
    return NO;
}

@end
