//
//  CatalogDetailPageResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogDetailPageResponse.h"

@implementation CatalogDetailPageInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"goods":@"HomeGoodsInfo"};
}

@end

@implementation CatalogDetailPageResponse

- (NSArray *)onePageData {
    
    return self.data.goods;
}

- (NSInteger)totalPageCount {
    
    return self.data.pages;
}

@end
