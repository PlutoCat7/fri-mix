//
//  OrderPayResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"
#import "OrderPayCallBackInfo.h"

@interface OrderPayResponse : COSResponseInfo

@property (nonatomic, strong) OrderPayCallBackInfo *data;

@end
