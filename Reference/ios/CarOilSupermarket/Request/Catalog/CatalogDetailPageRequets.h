//
//  CatalogDetailPageRequets.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "CatalogDetailPageResponse.h"

typedef NS_ENUM(NSUInteger, CatalogDetailSortType) {
    CatalogDetailSortType_Desc = 1,  //降序
    CatalogDetailSortType_Asc,       //升序
};

@interface CatalogDetailPageRequets : BasePageNetworkRequest

@property (nonatomic, assign) NSInteger firstCid;
@property (nonatomic, assign) NSInteger secondCid;
@property (nonatomic, assign) CatalogDetailSortType saleType;
@property (nonatomic, assign) CatalogDetailSortType priceType;

@end
