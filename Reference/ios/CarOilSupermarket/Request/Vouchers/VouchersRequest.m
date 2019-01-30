//
//  VouchersRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersRequest.h"

@implementation VouchersRequest

+ (void)getVouchersBuyListWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"buyOpt",
                                 @"do":@"quan",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId,
                                 @"v":@(1)
                                 };
    
    [self POSTWithParameters:parameters responseClass:[VouchersBuyListResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            VouchersBuyListResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)orderPayWithPayType:(NSString *)payType quantity:(NSInteger)quantity price:(NSInteger)price handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"pay",
                                 @"do":@"quan",
                                 @"qty":@(quantity),
                                 @"price":@(price),
                                 @"payType":payType,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[VouchersPayResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            VouchersPayResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
