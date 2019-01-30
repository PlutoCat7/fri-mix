//
//  CatalogModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/13.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "YAHActiveObject.h"

@interface CatalogModel : YAHActiveObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray<CatalogModel *> *subCatalogs;
@property (nonatomic, assign) BOOL expand;   //是否展开

@end
