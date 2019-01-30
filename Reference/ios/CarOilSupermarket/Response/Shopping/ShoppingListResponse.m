//
//  ShoppingListResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "ShoppingListResponse.h"

@implementation ShoppingInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"shoppingId":@"id",
             @"goodsId":@"goodsid"};
}

@end

@implementation ShoppingListInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"ShoppingInfo"};
}

- (NSString *)getCacheKey {
    
    NSString *cacheKey = [super getCacheKey];
    return [NSString stringWithFormat:@"%@-%@", cacheKey, [RawCacheManager sharedRawCacheManager].userId];
}

@end

@implementation ShoppingListResponse

@end
