//
//  ShoppingRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingRequest.h"

@implementation ShoppingRequest

+ (void)addToShoppingWithGoodId:(NSInteger)goodId number:(NSInteger)number handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"add",
                                 @"do":@"cart",
                                 @"goodsId":@(goodId),
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId,
                                 @"qty":@(number)};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            COSResponseInfo *info = result;
            BLOCK_EXEC(handler, info.msg, nil);
        }
    }];
}

+ (void)reduceToShoppingWithGoodId:(NSInteger)goodId number:(NSInteger)number handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"reduce",
                                 @"do":@"cart",
                                 @"goodsId":@(goodId),
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId,
                                 @"qty":@(number)};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            COSResponseInfo *info = result;
            BLOCK_EXEC(handler, info.msg, nil);
        }
    }];
}

+ (void)removeFromShoppingWithGoodIds:(NSArray<NSNumber *> *)goodIds handler:(RequestCompleteHandler)handler {
    
    NSMutableString *listString = [NSMutableString string];
    for (NSNumber *idNumber in goodIds) {
        if ([NSString stringIsNullOrEmpty:listString]) {
            [listString appendString:idNumber.stringValue];
        } else {
            [listString appendFormat:@",%@", idNumber.stringValue];
        }
    }
    
    NSDictionary *parameters = @{@"act":@"remove",
                                 @"do":@"cart",
                                 @"idStr":[listString copy],
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getShoppingInfoWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"list",
                                 @"do":@"cart",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[ShoppingListResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            ShoppingListResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
