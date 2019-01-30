//
//  OrderRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderRequest.h"

@implementation OrderRequest

+ (void)confirmOrderWithIds:(NSArray<NSString *> *)ids handler:(RequestCompleteHandler)handler {
    
    NSString *cartids = [ids componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"act":@"confirm",
                                 @"do":@"order",
                                 @"cartids":cartids,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[ConfirmOrderResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            ConfirmOrderResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)createOrderWithGoods:(NSArray<NSString *> *)goods
                     cartids:(NSArray<NSString *> *)cartids
                      remark:(NSString *)remark
                   addressId:(NSString *)addressId
                     quanIds:(NSString *)quanIds
                    usePoint:(NSInteger)usePoint
                  useBalance:(NSInteger)useBalance
                     handler:(RequestCompleteHandler)handler {
    
    NSString *goodsString = [goods componentsJoinedByString:@"|"];
    NSString *cartidsString = [cartids componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"act":@"create",
                                 @"do":@"order",
                                 @"goods":goodsString,
                                 @"cartids":cartidsString,
                                 @"remark":remark,
                                 @"addressid":addressId,
                                 @"quanId":quanIds,
                                 @"usePoint":@(usePoint),
                                 @"useBalance":@(useBalance),
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[CreateOrderResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            CreateOrderResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)orderPayOptionsWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"option",
                                 @"do":@"order",
                                 @"orderId":orderId,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[OrderPaymentOptionResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            OrderPaymentOptionResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)orderPayWithOrderId:(NSString *)orderId payType:(NSString *)payType handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"pay",
                                 @"do":@"order",
                                 @"orderId":orderId,
                                 @"payType":payType,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[OrderPayResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            OrderPayResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)cancelOrderWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"cancel",
                                 @"do":@"order",
                                 @"orderId":orderId,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)deleteOrderWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"delete",
                                 @"do":@"order",
                                 @"orderId":orderId,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)receiptOrderWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"complete",
                                 @"do":@"order",
                                 @"orderId":orderId,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

@end
