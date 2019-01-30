//
//  BalanceRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BalanceRequest.h"

@implementation BalanceRequest

+ (void)getRechargeOptionWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"chargeOpt",
                                 @"do":@"balance",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId
                                 };
    
    [self POSTWithParameters:parameters responseClass:[RechargeOptionResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            RechargeOptionResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)rechargePayWithPayType:(NSString *)payType money:(CGFloat)money handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"charge",
                                 @"do":@"balance",
                                 @"amt":@(money),
                                 @"payType":payType,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[RechargePayResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            RechargePayResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getWithdrawWithId:(NSInteger)detailId handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"wDetail",
                                 @"do":@"balance",
                                 @"id":@(detailId),
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[WithdrawDetailResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            WithdrawDetailResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)withdrawWithMoney:(NSString *)money bank:(NSString *)bank account:(NSString *)account name:(NSString *)name mobile:(NSString *)mobile points:(NSString *)points handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"withdraw",
                                 @"do":@"balance",
                                 @"amt":money,
                                 @"acc":account,
                                 @"bank":bank,
                                 @"name":name,
                                 @"mobile":mobile,
                                 @"points":points,
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId};
    
    [self POSTWithParameters:parameters responseClass:[COSResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)getWithdrawOptionWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"withdrawOpt",
                                 @"do":@"balance",
                                 @"mid":[RawCacheManager sharedRawCacheManager].userId
                                 };
    
    [self POSTWithParameters:parameters responseClass:[WithdrawOptionResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            WithdrawOptionResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
