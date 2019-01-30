//
//  MakeOrderViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/12.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfirmOrderResponse.h"

#import "ShoppingCartModel.h"
#import "MakeOrderHeaderModel.h"
#import "MakeOrderFooterModel.h"
#import "MakeOrderPayOptionModel.h"
#import "AddressListResponse.h"
#import "CreateOrderResponse.h"

@interface MakeOrderViewModel : NSObject

//kvo
@property (nonatomic, strong) NSMutableArray<ShoppingCartModel *> *cellModels;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, strong) MakeOrderHeaderModel *headerModel;
@property (nonatomic, strong) MakeOrderFooterModel *footerModel;
@property (nonatomic, strong) MakeOrderPayOptionModel *payOptionModel;
@property (nonatomic, strong) AddressInfo *addressInfo;

- (instancetype)initWithConfirmOrderInfo:(ConfirmOrderInfo *)info;

- (void)makeOrderWithHandler:(void(^)(NSError *error, CreateOrderInfo *orderInfo))hanlder;

- (CGFloat)totalPrice;

@end
