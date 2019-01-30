//
//  PayOrderViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderPaymentOptionResponse.h"

@interface PayOrderViewModel : NSObject

@property (nonatomic, strong) OrderPaymentOptionInfo *info;

- (instancetype)initWithOrderId:(NSString *)orderId;

- (void)getNetData:(void(^)(NSError *error))hanlder;

- (void)selectWithIndexpath:(NSIndexPath *)indexPath;

- (void)payWithHanlder:(void(^)(NSString *errorMsg))hanlder;

@end
