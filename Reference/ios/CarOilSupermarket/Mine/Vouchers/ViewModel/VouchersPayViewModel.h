//
//  VouchersPayViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VouchersBuyListResponse.h"

@interface VouchersPayViewModel : NSObject

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) CGFloat showPrice;
@property (nonatomic, assign) NSInteger payPrice;
@property (nonatomic, strong) NSArray<VouchersPaymentTypeInfo *> *paymentOpt;

- (CGFloat)totalPrice;

- (void)selectWithIndexpath:(NSIndexPath *)indexPath;

- (void)payWithHanlder:(void(^)(NSString *errorMsg))hanlder;

@end
