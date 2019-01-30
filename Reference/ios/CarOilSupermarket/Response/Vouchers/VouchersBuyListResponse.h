//
//  VouchersBuyListResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"

//"price": "100", // 面值
//"maxBuy": "2", // 单次最大可购买
//"name": "代金券", //名称
//"info": "身份1"  // 描述

@interface VouchersBuyInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat pricePay;
@property (nonatomic, assign) CGFloat ratio;  //折扣比率
@property (nonatomic, assign) NSInteger maxBuy;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;

@end

@interface VouchersPaymentTypeInfo : YAHActiveObject

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *label;

@end

@interface VouchersDiyInfo : YAHActiveObject

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, copy) NSString *placeholder;

@end

@interface VouchersBuyListInfo : YAHActiveObject

@property (nonatomic, strong) VouchersDiyInfo *diyOpt;
@property (nonatomic, strong) NSArray<VouchersPaymentTypeInfo *> *paymentOpt;
@property (nonatomic, strong) NSArray<VouchersBuyInfo *> *list;

@end

@interface VouchersBuyListResponse : COSResponseInfo

@property (nonatomic, strong) VouchersBuyListInfo *data;

@end
