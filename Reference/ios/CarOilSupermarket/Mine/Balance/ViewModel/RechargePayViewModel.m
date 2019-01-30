//
//  RechargePayViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "RechargePayViewModel.h"

#import "BalanceRequest.h"
#import "PayManager.h"

@interface RechargePayViewModel ()

@property (nonatomic, strong) RechargeTypeInfo *selectPayInfo;

@end

@implementation RechargePayViewModel

- (void)selectWithIndexpath:(NSIndexPath *)indexPath {
    
    _selectPayInfo = self.paymentOpt[indexPath.row];
}

- (void)payWithHanlder:(void(^)(NSString *errorMsg))hanlder {
    
    [BalanceRequest rechargePayWithPayType:self.selectPayInfo.payType money:_price handler:^(id result, NSError *error) {
       
        if (error) {
            BLOCK_EXEC(hanlder, error.domain);
        }else {
            OrderPayCallBackInfo *info = result;
            [[PayManager sharedPayManager] payWithOrderPayCallBackInfo:info hanlder:hanlder];
        }
    }];
}


@end
