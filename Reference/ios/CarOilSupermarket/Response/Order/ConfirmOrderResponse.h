//
//  ConfirmOrderResponse.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/11.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "COSResponseInfo.h"
#import "ShoppingListResponse.h"
#import "AddressListResponse.h"
#import "MyVouchersPageResponse.h"

@interface ConfirmGoodsInfo : ShoppingInfo

@property (nonatomic, copy) NSString *optionstock;
@property (nonatomic, copy) NSString *optiontitle;
@property (nonatomic, assign) NSInteger optionid;
@property (nonatomic, copy) NSString *specs;

@end

@interface ConfirmOrderInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, strong) NSArray<ConfirmGoodsInfo *> *goods;
@property (nonatomic, strong) NSArray<AddressInfo *> *address;
@property (nonatomic, assign) CGFloat freight;  //"freight": "0.0", // 邮费
@property (nonatomic, copy) NSString *dispatch;  //"dispatch": "快递 免邮"
@property (nonatomic, assign) BOOL canUsePoint;  // 1是0否可使用积分支付，
@property (nonatomic, assign) BOOL canUseQuan;   // 1是0否可使用代金券支付
@property (nonatomic, assign) BOOL canUseBalance;  // 1是0否可使用余额支付
@property (nonatomic, strong) NSArray<MyVouchersInfo *> *quanList;
@property (nonatomic, assign) CGFloat userBalance;  // 用户人民币余额
@property (nonatomic, assign) CGFloat userPoint;  // 用户积分余额

@end

@interface ConfirmOrderResponse : COSResponseInfo

@property (nonatomic, strong) ConfirmOrderInfo *data;

@end
