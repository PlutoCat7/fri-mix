//
//  GoodInfoViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/8.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsContentModel;
@class GoodsHeaderModel;

@interface GoodInfoViewModel : NSObject

@property (nonatomic, strong, readonly) GoodsHeaderModel *goodsHeaderModel;
@property (nonatomic, strong, readonly) GoodsContentModel *goodsContentModel;
@property (nonatomic, copy, readonly) NSString *tipsMsg;

- (instancetype)initWithGoodsId:(NSInteger)goodsId;
- (void)addGoodsToShopping:(void(^)(NSError *error))handler;

@end
