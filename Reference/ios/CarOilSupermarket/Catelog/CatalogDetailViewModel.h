//
//  CatalogDetailViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeResponseInfo.h"
#import "CatalogDetailPageRequets.h"

@interface CatalogDetailViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSArray<HomeGoodsInfo *> *goodsList;
@property (nonatomic, assign, readonly) BOOL isLoadEnd;

@property (nonatomic, assign) CatalogDetailSortType saleType; //销量排序
@property (nonatomic, assign) CatalogDetailSortType priceType; //销量排序

- (instancetype)initWithTitle:(NSString *)title firstCid:(NSInteger)firstCid secondCid:(NSInteger)secondCid;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;

@end
