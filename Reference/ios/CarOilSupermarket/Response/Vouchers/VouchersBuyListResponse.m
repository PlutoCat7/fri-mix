//
//  VouchersBuyListResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersBuyListResponse.h"

@implementation VouchersBuyInfo

@end
@implementation VouchersPaymentTypeInfo

@end
@implementation VouchersDiyInfo

@end
@implementation VouchersBuyListInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"VouchersBuyInfo",
             @"paymentOpt":@"VouchersPaymentTypeInfo"
             };
}

@end

@implementation VouchersBuyListResponse

@end
