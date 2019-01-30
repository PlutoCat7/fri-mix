//
//  GoodsRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/4.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "GoodsResponse.h"

@interface GoodsRequest : BaseNetworkRequest

/**
 * 获取商品详情
 * @param goodId 商品id
 */
+ (void)getGoodInfoWithGoodID:(NSInteger)goodId handler:(RequestCompleteHandler)handler;

@end
