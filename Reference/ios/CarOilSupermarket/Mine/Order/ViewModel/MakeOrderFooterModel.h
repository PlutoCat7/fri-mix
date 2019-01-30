//
//  MakeOrderFooterModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/15.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakeOrderFooterModel : NSObject

@property (nonatomic, copy) NSString *freight;
@property (nonatomic, copy) NSString *sendWay;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *goodsCount;
@property (nonatomic, copy) NSString *totalPrice;

@end
