//
//  ShopResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2016/12/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "ShopResponseInfo.h"

@implementation ShopItemInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"itemId":@"id"};
}


@end

@implementation ShopInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"banner": @"ShopItemInfo",
             @"list": @"ShopItemInfo"};
}

@end

@implementation ShopResponseInfo

@end
