//
//  PayOrderViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "PayOrderViewModel.h"
#import "OrderRequest.h"

#import "PayManager.h"

@interface PayOrderViewModel ()

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) OrderPaymentTypeInfo *selectPayInfo;

@end

@implementation PayOrderViewModel

- (instancetype)initWithOrderId:(NSString *)orderId {
    
    self = [super init];
    if (self) {
        _orderId = orderId;
    }
    return self;
}

- (void)getNetData:(void(^)(NSError *error))hanlder {
    
    [OrderRequest orderPayOptionsWithOrderId:self.orderId handler:^(id result, NSError *error) {
       
        if (!error) {
            self.info = result;
            _selectPayInfo = self.info.types[0];
        }
        BLOCK_EXEC(hanlder, error);
    }];
}

- (void)selectWithIndexpath:(NSIndexPath *)indexPath {
    
    _selectPayInfo = self.info.types[indexPath.row];
}

- (void)payWithHanlder:(void(^)(NSString *errorMsg))hanlder {
    

    [OrderRequest orderPayWithOrderId:self.info.order.orderId payType:_selectPayInfo.payType handler:^(id result, NSError *error) {

        if (error) {
            BLOCK_EXEC(hanlder, error.domain);
        }else {
            OrderPayCallBackInfo *info = result;
            [[PayManager sharedPayManager] payWithOrderPayCallBackInfo:info hanlder:hanlder];
        }
    }];
}

@end
