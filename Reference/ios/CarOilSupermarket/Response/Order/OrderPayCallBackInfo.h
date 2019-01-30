//
//  OrderPayCallBackInfo.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "YAHActiveObject.h"

@interface PayCallBackDataInfo : YAHActiveObject

//支付宝
@property (nonatomic, copy) NSString *orderString;

//微信
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, assign) UInt32 timestamp;
@property (nonatomic, copy) NSString *sign;

@end

@interface OrderPayCallBackInfo : YAHActiveObject

@property (nonatomic, copy) NSString *payType;
@property (nonatomic, strong) PayCallBackDataInfo *payData;

@end
