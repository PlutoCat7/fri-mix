//
//  CatalogDetailPageRequets.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogDetailPageRequets.h"

@implementation CatalogDetailPageRequets

- (Class)responseClass {
    
    return [CatalogDetailPageResponse class];
}

- (NSDictionary *)parameters {
    
    return @{@"act":@"list",
             @"do":@"goods",
             @"cid1":@(self.firstCid),
             @"cid2":@(self.secondCid),
             @"sort1":@(self.saleType),
             @"sort2":@(self.priceType),
             @"mid":[RawCacheManager sharedRawCacheManager].userId};
}

@end
