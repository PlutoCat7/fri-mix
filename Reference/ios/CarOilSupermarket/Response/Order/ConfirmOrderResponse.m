//
//  ConfirmOrderResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "ConfirmOrderResponse.h"

@implementation ConfirmGoodsInfo
@end

@implementation ConfirmOrderInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"goods":@"ConfirmGoodsInfo",
             @"address":@"AddressInfo",
             @"quanList":[MyVouchersInfo class]
             };
}

@end

@implementation ConfirmOrderResponse

@end
