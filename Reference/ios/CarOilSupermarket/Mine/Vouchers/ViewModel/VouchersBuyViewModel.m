//
//  VouchersBuyViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/16.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "VouchersBuyViewModel.h"
#import "VouchersRequest.h"

@interface VouchersBuyViewModel ()

@property (nonatomic, strong) VouchersBuyListInfo *buyListInfo;

@end

@implementation VouchersBuyViewModel

- (void)getVouchersDataWithHandler:(void(^)(NSError *error))handler {
    
    [VouchersRequest getVouchersBuyListWithHandler:^(id result, NSError *error) {
        
        if (!error) {
            
            self.buyListInfo = result;
            [self handlerNetworkData];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (NSString *)diyTextFieldPlaceholder {
    
    return self.buyListInfo.diyOpt.placeholder;;
}

- (BOOL)getDiyEnabel {
    
    return self.buyListInfo.diyOpt.enable;
}

- (BOOL)checkDiyPriceEnabel:(CGFloat)price {
    
    if (price>=self.buyListInfo.diyOpt.min &&
        price<=self.buyListInfo.diyOpt.max &&
        price-floor(price) <= 0) {
        return YES;
    }
    return NO;
}

- (void)clearBuyCount {
    
    for (VouchersBuyCellModel *model in self.cellModels) {
        model.buyCount = 0;
    }
}

- (VouchersBuyCellModel *)getWillBuyCellModel {
    
    for (VouchersBuyCellModel *model in self.cellModels) {
        if (model.buyCount > 0) {
            return model;
        }
    }
    
    return nil;
}

- (NSArray<VouchersPaymentTypeInfo *> *)getPaymentTypeInfoList {
    
    return self.buyListInfo.paymentOpt;
}

#pragma mark - Private

- (void)handlerNetworkData {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (VouchersBuyInfo *buyInfo in self.buyListInfo.list) {
        VouchersBuyCellModel *cellModel = [[VouchersBuyCellModel alloc] init];
        cellModel.title = buyInfo.name;
        cellModel.price = buyInfo.price;
        cellModel.ratio = buyInfo.ratio;
        cellModel.vouchersInfo = buyInfo.info;
        cellModel.maxBuyCount = buyInfo.maxBuy;
        NSString *worthString = [NSString stringWithFormat:@"¥ %td", (NSInteger)buyInfo.price];
        NSMutableAttributedString *mutAttributedString = [[NSMutableAttributedString alloc] initWithString:worthString];
        [mutAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13*kAppScale] range:[worthString rangeOfString:@"¥"]];
        cellModel.priceAttributedString = [mutAttributedString copy];
        
        [result addObject:cellModel];
    }
    
    self.cellModels = [result copy];
}

@end
