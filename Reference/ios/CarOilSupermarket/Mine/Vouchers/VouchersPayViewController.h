//
//  VouchersPayViewController.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSBaseViewController.h"
@class VouchersPaymentTypeInfo;

@interface VouchersPayViewController : COSBaseViewController

- (instancetype)initWithNumber:(NSInteger)number
                         showPrice:(CGFloat)showPrice
                        payPrice:(NSInteger)payPrice
                    paymentOpt: (NSArray<VouchersPaymentTypeInfo *> *)paymentOpt;

@end
