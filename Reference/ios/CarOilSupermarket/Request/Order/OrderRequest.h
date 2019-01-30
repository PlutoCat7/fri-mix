//
//  OrderRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "ConfirmOrderResponse.h"
#import "CreateOrderResponse.h"
#import "OrderPaymentOptionResponse.h"
#import "OrderPayResponse.h"

@interface OrderRequest : BaseNetworkRequest

+ (void)confirmOrderWithIds:(NSArray<NSString *> *)ids handler:(RequestCompleteHandler)handler;

/**
 创建

 @param goods 格式：// 123,1,2|124,11,3   商品id,规格id,数量|商品id,规格id,数量
 @param cartids 购物车id，4.26购物车列表的ID，格式：12,34
 @param remark 留言
 @param addressId 地址id
 */
+ (void)createOrderWithGoods:(NSArray<NSString *> *)goods
                     cartids:(NSArray<NSString *> *)cartids
                      remark:(NSString *)remark
                   addressId:(NSString *)addressId
                     quanIds:(NSString *)quanIds
                    usePoint:(NSInteger)usePoint
                  useBalance:(NSInteger)useBalance
                     handler:(RequestCompleteHandler)handler;

+ (void)orderPayOptionsWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler;

+ (void)orderPayWithOrderId:(NSString *)orderId payType:(NSString *)payType handler:(RequestCompleteHandler)handler;

+ (void)cancelOrderWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler;

+ (void)deleteOrderWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler;

//确认收货
+ (void)receiptOrderWithOrderId:(NSString *)orderId handler:(RequestCompleteHandler)handler;

@end
