//
//  CatalogDetailViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CatalogDetailViewModel.h"
#import "CatalogDetailPageRequets.h"

@interface CatalogDetailViewModel ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger firstCid;
@property (nonatomic, assign) NSInteger secondCid;

@property (nonatomic, strong) CatalogDetailPageRequets *pageRequest;
@property (nonatomic, strong) NSArray<HomeGoodsInfo *> *goodsList;

@end

@implementation CatalogDetailViewModel

- (instancetype)initWithTitle:(NSString *)title firstCid:(NSInteger)firstCid secondCid:(NSInteger)secondCid; {
    
    self = [self init];
    if (self) {
        
        _title = title;
        _firstCid = firstCid;
        _secondCid = secondCid;
        
        _pageRequest = [[CatalogDetailPageRequets alloc] init];
        _pageRequest.firstCid = firstCid;
        _pageRequest.secondCid = secondCid;
        _pageRequest.saleType = _saleType;
        _pageRequest.priceType = _priceType;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _saleType = CatalogDetailSortType_Asc;
        _priceType = CatalogDetailSortType_Desc;
    }
    return self;
}

#pragma mark - Public

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            self.goodsList = self.pageRequest.responseInfo.items;
        }
        BLOCK_EXEC(handler, error);
    }];
}
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            self.goodsList = self.pageRequest.responseInfo.items;
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (BOOL)isLoadEnd {
    
    return self.pageRequest.isLoadEnd;
}

#pragma mark - Private

- (void)setGoodsList:(NSArray<HomeGoodsInfo *> *)goodsList {
    
    _goodsList = goodsList;
}

#pragma mark - Setter and Getter

- (void)setSaleType:(CatalogDetailSortType)saleType {
    
    _saleType = saleType;
    self.pageRequest.saleType = saleType;
    [self getFirstPageDataWithHandler:nil];
}

- (void)setPriceType:(CatalogDetailSortType)priceType {
    
    _priceType = priceType;
    self.pageRequest.priceType = priceType;
    [self getFirstPageDataWithHandler:nil];
}

@end
