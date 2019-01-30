//
//  ShoppingRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "ShoppingListResponse.h"

@interface ShoppingRequest : BaseNetworkRequest

+ (void)addToShoppingWithGoodId:(NSInteger)goodId number:(NSInteger)number handler:(RequestCompleteHandler)handler;

+ (void)reduceToShoppingWithGoodId:(NSInteger)goodId number:(NSInteger)number handler:(RequestCompleteHandler)handler;

+ (void)removeFromShoppingWithGoodIds:(NSArray<NSNumber *> *)goodIds handler:(RequestCompleteHandler)handler;

+ (void)getShoppingInfoWithHandler:(RequestCompleteHandler)handler;

@end
