//
//  VouchersPayViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/17.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersPayViewModel.h"

#import "VouchersRequest.h"
#import "PayManager.h"

@interface VouchersPayViewModel ()

@property (nonatomic, strong) VouchersPaymentTypeInfo *selectPayInfo;

@end

@implementation VouchersPayViewModel

#pragma mark - Public

- (CGFloat)totalPrice {
    
    return self.number * self.showPrice;
}

- (void)selectWithIndexpath:(NSIndexPath *)indexPath {
    
    _selectPayInfo = self.paymentOpt[indexPath.row];
}

- (void)payWithHanlder:(void(^)(NSString *errorMsg))hanlder {
    
    [VouchersRequest orderPayWithPayType:self.selectPayInfo.payType quantity:self.number price:self.payPrice handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(hanlder, error.domain);
        }else {
            OrderPayCallBackInfo *info = result;
            [[PayManager sharedPayManager] payWithOrderPayCallBackInfo:info hanlder:hanlder];
        }
    }];
}

@end
