//
//  BalanceRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "RechargeOptionResponse.h"
#import "RechargePayResponse.h"
#import "WithdrawDetailResponse.h"
#import "WithdrawOptionResponse.h"

@interface BalanceRequest : BaseNetworkRequest

/**
 余额充值选项

 */
+ (void)getRechargeOptionWithHandler:(RequestCompleteHandler)handler;

/**
 余额充值支付

 @param payType 支付类型
 @param money 支付的money
 */
+ (void)rechargePayWithPayType:(NSString *)payType money:(CGFloat)money handler:(RequestCompleteHandler)handler;

/**
 获取余额明细的体现的详情

 @param detailId 明细id
 */
+ (void)getWithdrawWithId:(NSInteger)detailId handler:(RequestCompleteHandler)handler;

/**
 对余额进行体现

 @param money 体现金额
 @param bank 开户银行
 @param account 帐号
 @param name 开户姓名
 @param mobile 开户者手机号

 */
+ (void)withdrawWithMoney:(NSString *)money bank:(NSString *)bank account:(NSString *)account name:(NSString *)name mobile:(NSString *)mobile points:(NSString *)points handler:(RequestCompleteHandler)handler;

/**
 余额提现选项
 
 */
+ (void)getWithdrawOptionWithHandler:(RequestCompleteHandler)handler;

@end
