//
//  BalanceDetailsCellModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BalanceDetailsCellModel : NSObject

@property (nonatomic, assign) NSInteger detailId;
@property (nonatomic, assign) BOOL canSelect; //能否被选择
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, strong) UIColor *moneyColor;
@property (nonatomic, copy) NSString *state;

@end
