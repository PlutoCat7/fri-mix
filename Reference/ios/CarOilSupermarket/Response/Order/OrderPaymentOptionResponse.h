//
//  OrderPaymentOptionResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"

@interface OrderPaymentTypeInfo : YAHActiveObject

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *label;

@end

@interface OrderPaymentOrderInfo : YAHActiveObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) CGFloat price;   //商品总价
@property (nonatomic, assign) CGFloat needPay;  //需支付金额，  可能使用了代金券

@end

@interface OrderPaymentOptionInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<OrderPaymentTypeInfo *> *types;
@property (nonatomic, strong) OrderPaymentOrderInfo *order;

@end

@interface OrderPaymentOptionResponse : COSResponseInfo

@property (nonatomic, strong) OrderPaymentOptionInfo *data;

@end
