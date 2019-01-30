//
//  CatalogResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogResponse.h"

@implementation CatalogInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"catalogId":@"id"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"children":@"CatalogInfo"};
}

@end

@implementation CatalogResponseData

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"catalogs":@"category"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"catalogs":@"CatalogInfo"};
}

@end

@implementation CatalogResponse

@end
