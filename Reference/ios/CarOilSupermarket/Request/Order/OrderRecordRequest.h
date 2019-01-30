//
//  OrderRecordRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/12.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "BasePageNetworkRequest.h"
#import "OrderRecordPageResponse.h"

@interface OrderRecordRequest : BasePageNetworkRequest

@property (nonatomic, assign) OrderType type;

@end
