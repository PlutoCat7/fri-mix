//
//  WithdrawViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawViewModel : NSObject

- (void)getWithdrawInfoWithHanlder:(void(^)(NSString *errorMsg))hanlder;

- (NSString *)moneyTextFieldPlaceholder;

- (NSString *)tips;

- (BOOL)checkInputVaild:(CGFloat)money
                   bank:(NSString *)bank
                account:(NSString *)account
                   name:(NSString *)name
                 mobile:(NSString *)mobile
                 points:(NSString *)points;

- (void)withdrawWithMoney:(NSString *)money
                     bank:(NSString *)bank
                  account:(NSString *)account
                     name:(NSString *)name
                   mobile:(NSString *)mobile
                   points:(NSString *)points
                  hanlder:(void(^)(NSString *errorMsg, BOOL isSuccess, NSString *successTips))hanlder;

@end
