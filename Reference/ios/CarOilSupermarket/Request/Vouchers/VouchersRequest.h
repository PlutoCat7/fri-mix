//
//  VouchersRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "VouchersBuyListResponse.h"
#import "VouchersPayResponse.h"

@interface VouchersRequest : BaseNetworkRequest

/**
 代金券可购买选项

 @param handler 请求完成回调
 */
+ (void)getVouchersBuyListWithHandler:(RequestCompleteHandler)handler;

/**
 代金券够买

 @param payType 支付类型
 @param quantity 购买数量
 @param price 单个代金券价格
 @param handler 请求完成回调
 */
+ (void)orderPayWithPayType:(NSString *)payType quantity:(NSInteger)quantity price:(NSInteger)price handler:(RequestCompleteHandler)handler;

@end
