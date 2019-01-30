//
//  VouchersBuyViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/16.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VouchersBuyCellModel.h"
@class VouchersPaymentTypeInfo;

@interface VouchersBuyViewModel : NSObject

@property (nonatomic, strong) NSArray<VouchersBuyCellModel *> *cellModels;

- (void)getVouchersDataWithHandler:(void(^)(NSError *error))handler;

- (NSString *)diyTextFieldPlaceholder;

- (BOOL)getDiyEnabel;

- (BOOL)checkDiyPriceEnabel:(CGFloat)price;

/**
 获取选择的优惠券cell model

 @return if nil则表示没有优惠券被选择
 */
- (VouchersBuyCellModel *)getWillBuyCellModel;

- (NSArray<VouchersPaymentTypeInfo *> *)getPaymentTypeInfoList;

- (void)clearBuyCount;

@end
