//
//  RechargeOptionResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"

@interface RechargeTypeInfo : YAHActiveObject

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *label;

@end

@interface RechargeDescInfo : YAHActiveObject

@property (nonatomic, copy) NSString *info;  //"充值说明文字",
@property (nonatomic, assign) NSInteger min;   //最小金额
@property (nonatomic, assign) NSInteger max;   //最大金额
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *placeholder;

@end

@interface RechargeOptionInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<RechargeTypeInfo *> *paymentOpt;
@property (nonatomic, strong) RechargeDescInfo *opt;

@end

@interface RechargeOptionResponse : COSResponseInfo

@property (nonatomic, strong) RechargeOptionInfo *data;

@end
