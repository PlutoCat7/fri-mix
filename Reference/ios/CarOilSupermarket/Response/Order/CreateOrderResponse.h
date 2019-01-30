//
//  CreateOrderResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"

// needPay说明：还需要第三方支付的金额，0代表订单已支付成功，直接跳到订单列表；大于0表示需要第三方支付的金额，跳到选择第三方支付方式页面

@interface CreateOrderInfo : YAHActiveObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) CGFloat needPay;

@end

@interface CreateOrderResponse : COSResponseInfo

@property (nonatomic, strong) CreateOrderInfo *data;

@end
