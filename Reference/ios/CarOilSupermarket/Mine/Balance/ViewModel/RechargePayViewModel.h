//
//  RechargePayViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RechargeOptionResponse.h"

@interface RechargePayViewModel : NSObject

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSArray<RechargeTypeInfo *> *paymentOpt;

- (void)selectWithIndexpath:(NSIndexPath *)indexPath;

- (void)payWithHanlder:(void(^)(NSString *errorMsg))hanlder;

@end
