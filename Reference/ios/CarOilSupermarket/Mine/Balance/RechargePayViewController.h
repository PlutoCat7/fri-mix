//
//  RechargePayViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSBaseViewController.h"

@class RechargeTypeInfo;

@interface RechargePayViewController : COSBaseViewController

- (instancetype)initWithPrice:(CGFloat)price
                    paymentOpt: (NSArray<RechargeTypeInfo *> *)paymentOpt;


@end
