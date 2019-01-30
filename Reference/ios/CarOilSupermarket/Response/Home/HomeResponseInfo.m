//
//  HomeResponseInfo.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "HomeResponseInfo.h"

@implementation HomeBannerInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"goodsId":@"id",
             @"price":@"marketprice"};
}

@end

@implementation HomeCategoryInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"name":@"label",
             @"icon":@"ico"};
}

- (CategoryType)type {
    
    CategoryType type = CategoryType_None;
    if ([self.act isEqualToString:@"category"]) {
        type = CategoryType_Normal;
    }else if ([self.act isEqualToString:@"categoryMore"]) {
        type = CategoryType_More;
    }
    return type;
}

@end

@implementation HomeGoodsInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"goodsId":@"id",
             @"price":@"marketprice"};
}

@end

@implementation HomeNetworkData

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"bannerList":@"banner",
             @"goodsList":@"goods",
             @"categoryList":@"category"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"bannerList":@"HomeBannerInfo",
             @"goodsList":@"HomeGoodsInfo",
             @"categoryList":@"HomeCategoryInfo"};
}

@end

@implementation HomeResponseInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"bannerList":@"banner",
             @"categoryList":@"category",
             @"goodsList":@"goods"};
}

@end
