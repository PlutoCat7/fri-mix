//
//  OrderPaymentOptionResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderPaymentOptionResponse.h"

@implementation OrderPaymentTypeInfo

@end

@implementation OrderPaymentOrderInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"orderId":@"id"};
}

@end

@implementation OrderPaymentOptionInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"types":@"OrderPaymentTypeInfo"};
}

@end

@implementation OrderPaymentOptionResponse

@end
