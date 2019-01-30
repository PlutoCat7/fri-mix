//
//  GoodInfoViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "GoodInfoViewModel.h"
#import "ShoppingRequest.h"
#import "GoodsRequest.h"
#import "GoodsHeaderModel.h"
#import "GoodsContentModel.h"

@interface GoodInfoViewModel ()

@property (nonatomic, strong) GoodsHeaderModel *goodsHeaderModel;
@property (nonatomic, strong) GoodsContentModel *goodsContentModel;
@property (nonatomic, copy) NSString *tipsMsg;

@property (nonatomic, strong,) GoodsInfo *goodsInfo;
@property (nonatomic, assign) NSInteger goodsId;

@end

@implementation GoodInfoViewModel

- (instancetype)initWithGoodsId:(NSInteger)goodsId {
    
    self = [super init];
    if (self) {
        _goodsId = goodsId;
        [self loadNetworkData];
    }
    return self;
}

- (void)addGoodsToShopping:(void(^)(NSError *error))handler {
    
    [ShoppingRequest addToShoppingWithGoodId:self.goodsId number:1 handler:^(id result, NSError *error) {
        
        if (error) {
            self.tipsMsg = error.domain;
        }else {
            self.tipsMsg = @"添加成功，在购物车等亲~";
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Shoping_Add object:nil];
        }
        BLOCK_EXEC(handler, error);
    }];
}

#pragma mark - Private

- (void)loadNetworkData {
    
    [GoodsRequest getGoodInfoWithGoodID:self.goodsId handler:^(id result, NSError *error) {
        if (error) {
            self.tipsMsg = error.domain;
        }else {
            self.goodsInfo = result;
            [self handleData];
        }
    }];
}

- (void)handleData {
    
    GoodsHeaderModel *headerModel = [[GoodsHeaderModel alloc] init];
    headerModel.imagesURL = [self.goodsInfo.images copy];
    headerModel.title = self.goodsInfo.title;
    headerModel.nowPriceString = self.goodsInfo.marketprice;
    headerModel.oldPriceString = self.goodsInfo.productprice;
    headerModel.saleDesc = [NSString stringWithFormat:@"库存 %td   销售 %td", self.goodsInfo.stock, self.goodsInfo.sales];
    headerModel.point = self.goodsInfo.pointsTxt;
    self.goodsHeaderModel = headerModel;
    
    GoodsContentModel *contentModel = [[GoodsContentModel alloc] init];
    contentModel.contentUrl = self.goodsInfo.contentUrl;
    self.goodsContentModel = contentModel;
}

@end
