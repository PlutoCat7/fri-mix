//
//  RechargeOptionResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "RechargeOptionResponse.h"

@implementation RechargeTypeInfo

@end

@implementation RechargeDescInfo

@end

@implementation RechargeOptionInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"paymentOpt":@"RechargeTypeInfo"};
}

@end

@implementation RechargeOptionResponse

@end
