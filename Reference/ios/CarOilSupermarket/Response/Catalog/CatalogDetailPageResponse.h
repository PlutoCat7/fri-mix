//
//  CatalogDetailPageResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSPageResponseInfo.h"
#import "HomeResponseInfo.h"

@interface CatalogDetailPageInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<HomeGoodsInfo *> *goods;
@property (nonatomic, assign) NSInteger pages;     //总页数

@end

@interface CatalogDetailPageResponse : COSPageResponseInfo

@property (nonatomic, strong) CatalogDetailPageInfo *data;

@end
