//
//  RechargePayResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"
#import "OrderPayCallBackInfo.h"

@interface RechargePayResponse : COSResponseInfo

@property (nonatomic, strong) OrderPayCallBackInfo *data;
@end
