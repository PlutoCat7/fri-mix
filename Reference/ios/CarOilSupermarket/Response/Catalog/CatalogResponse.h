//
//  CatalogResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSResponseInfo.h"

@interface CatalogInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger catalogId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<CatalogInfo *> *children;

@end

@interface CatalogResponseData : YAHDataResponseInfo

@property (nonatomic, strong) NSArray<CatalogInfo *> *catalogs;

@end


@interface CatalogResponse : COSResponseInfo

@property (nonatomic, strong) CatalogResponseData *data;

@end
