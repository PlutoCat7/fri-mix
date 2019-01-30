//
//  MakeOrderPayOptionModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/23.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyVouchersPageResponse.h"

//特别说明 积分与代金券、余额不能一起使用
@interface MakeOrderPayOptionModel : NSObject

@property (nonatomic, assign) CGFloat orderPrice;

@property (nonatomic, strong) NSArray<MyVouchersInfo *> *selectVouchersInfos;
@property (nonatomic, copy, readonly) NSString *vouchersId; //已选择劵id，
@property (nonatomic, assign) BOOL canUseVoucher;

@property (nonatomic, assign) BOOL canUsePoint;  //是否能使用
@property (nonatomic, assign) BOOL pointSwitchOn; //是否使用
@property (nonatomic, assign) NSInteger usePoint; //可用积分

@property (nonatomic, assign) BOOL canUseBalance; //是否能使用
@property (nonatomic, assign) BOOL balanceSwitchOn; //是否使用
@property (nonatomic, assign) CGFloat useBalance;  //可用余额

- (CGFloat)totalVouchersPrice;

//是否显示
- (BOOL)isShow;

//显示时的高度
- (CGFloat)showHeight;

@end
