//
//  MakeOrderViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/12.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "MakeOrderViewModel.h"
#import "OrderRequest.h"

@interface MakeOrderViewModel ()

@property (nonatomic, strong) ConfirmOrderInfo *orderInfo;

@end

@implementation MakeOrderViewModel

- (instancetype)initWithConfirmOrderInfo:(ConfirmOrderInfo *)info
{
    self = [super init];
    if (self) {
        _orderInfo = info;
        [self handlerNetworkData];
    }
    return self;
}

- (void)makeOrderWithHandler:(void(^)(NSError *error, CreateOrderInfo *orderInfo))hanlder {
    
    NSString *addressId = self.addressInfo.addressId;
    if ([NSString stringIsNullOrEmpty:addressId]) {
        self.errorMsg = @"请选择收货地址";
        return;
    }
    
    NSMutableArray *cartidList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *goodidList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=0; index<self.orderInfo.goods.count; index++) {
        ConfirmGoodsInfo *info = self.orderInfo.goods[index];
        [cartidList addObject:@(info.shoppingId).stringValue];
        [goodidList addObject:[NSString stringWithFormat:@"%td,0,%td",info.goodsId, info.total]];
    }
    NSString *remark = @"";
    if (self.footerModel.message) {
        remark = self.footerModel.message;
    }
    
    [OrderRequest createOrderWithGoods:[goodidList copy]
                               cartids:[cartidList copy]
                                remark:remark
                             addressId:addressId
                               quanIds:self.payOptionModel.vouchersId
                              usePoint:self.payOptionModel.pointSwitchOn
                            useBalance:self.payOptionModel.balanceSwitchOn
                               handler:^(id result, NSError *error) {
        
        if (error) {
            self.errorMsg = error.domain;
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Order_Create object:nil];
        }
        BLOCK_EXEC(hanlder, error, result);
    }];
}

- (MakeOrderHeaderModel *)headerModel {
    
    MakeOrderHeaderModel *headerModel = [[MakeOrderHeaderModel alloc] init];
    AddressInfo *addressInfo = self.addressInfo;
    if (addressInfo) {
        headerModel.receiverName = addressInfo.realname;
        headerModel.phone = addressInfo.mobile;
        headerModel.address = [NSString stringWithFormat:@"%@%@%@%@", addressInfo.province, addressInfo.city, addressInfo.area, addressInfo.address];
    }else {
        headerModel.address = @"新增地址";
    }
    
    return headerModel;
}

- (CGFloat)totalPrice {
    
    if (self.payOptionModel.pointSwitchOn) {
        return 0;
    }
    
    CGFloat price = self.orderInfo.price - [self.payOptionModel totalVouchersPrice];
    if (self.payOptionModel.balanceSwitchOn) {
        price -= self.payOptionModel.useBalance;
    }
    if (price<0) {
        price = 0;
    }
    return price;
}

#pragma mark - Private

- (void)handlerNetworkData {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.orderInfo.goods.count];
    for (ConfirmGoodsInfo *info in self.orderInfo.goods) {
        
        ShoppingCartModel *model =  [[ShoppingCartModel alloc] init];
        model.shoppingId = info.shoppingId;
        model.total = info.total;
        model.goodsId = info.goodsId;
        model.stock = info.stock;
        model.maxbuy = info.maxbuy;
        model.title = info.title;
        model.thumb = info.thumb;
        model.marketprice = info.marketprice;
        model.productprice = info.productprice;
        
        [result addObject:model];
    }
    self.cellModels = result;
    
    MakeOrderFooterModel *footerModel = [[MakeOrderFooterModel alloc] init];
    footerModel.freight = [NSString stringWithFormat:@"￥%.2f", self.orderInfo.freight];
    footerModel.sendWay = self.orderInfo.dispatch;
    footerModel.goodsCount = [NSString stringWithFormat:@"共%td件商品", self.orderInfo.goods.count];
    footerModel.totalPrice = [NSString stringWithFormat:@"￥%.2f", self.orderInfo.price];
    self.footerModel = footerModel;
    
    self.addressInfo = self.orderInfo.address.firstObject;
    
    MakeOrderPayOptionModel *payOptionModel = [[MakeOrderPayOptionModel alloc] init];
    payOptionModel.orderPrice = self.orderInfo.price;
    payOptionModel.canUseVoucher = self.orderInfo.canUseQuan;
    payOptionModel.canUsePoint = self.orderInfo.canUsePoint;
    payOptionModel.canUseBalance = self.orderInfo.canUseBalance;
    payOptionModel.usePoint = self.orderInfo.userPoint;
    payOptionModel.useBalance = self.orderInfo.userBalance;
    self.payOptionModel = payOptionModel;
}


@end
