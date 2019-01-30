//
//  WithdrawViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "WithdrawViewModel.h"
#import "BalanceRequest.h"

@interface WithdrawViewModel ()

@property (nonatomic, strong) WithdrawOptionData *optionData;

@end

@implementation WithdrawViewModel

- (void)getWithdrawInfoWithHanlder:(void(^)(NSString *errorMsg))hanlder {
    
    [BalanceRequest getWithdrawOptionWithHandler:^(id result, NSError *error) {
        
        if (!error) {
            self.optionData =  result;
        }
        BLOCK_EXEC(hanlder, error.domain);
    }];
}

- (NSString *)moneyTextFieldPlaceholder {
    
    return @"请输入提现金额";
}

- (NSString *)tips {
    
    return self.optionData.opt.info;
}

- (BOOL)checkInputVaild:(CGFloat)money
                   bank:(NSString *)bank
                account:(NSString *)account
                   name:(NSString *)name
                 mobile:(NSString *)mobile
                 points:(NSString *)points {
    
    if (points.length>0) { //points非必填
        if (points.integerValue<0 || points.integerValue>[RawCacheManager sharedRawCacheManager].userInfo.point) {
            return NO;
        }
    }
    
    if (bank.length>0 &&
        account.length>0 &&
        name.length>0 &&
        [LogicManager isPhoneBumber:mobile] &&
        (money>=self.optionData.opt.min && money<=self.optionData.opt.max)) {
        
        return YES;
    }
    return NO;
}

- (void)withdrawWithMoney:(NSString *)money
                     bank:(NSString *)bank
                  account:(NSString *)account
                     name:(NSString *)name
                   mobile:(NSString *)mobile
                   points:(NSString *)points
                  hanlder:(void(^)(NSString *errorMsg, BOOL isSuccess, NSString *successTips))hanlder {
    
    [BalanceRequest withdrawWithMoney:money bank:bank account:account name:name mobile:mobile points:points handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(hanlder, error.domain, NO, nil);
        }else {
            BLOCK_EXEC(hanlder, nil, YES, @"提现成功！");
        }
    }];
}

@end
