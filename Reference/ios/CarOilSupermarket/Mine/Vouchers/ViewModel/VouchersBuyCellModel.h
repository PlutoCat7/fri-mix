//
//  VouchersBuyCellModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/16.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VouchersBuyCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat ratio;  //折扣比例
@property (nonatomic, copy) NSAttributedString *priceAttributedString;
@property (nonatomic, copy) NSString *vouchersInfo;
@property (nonatomic, assign) NSInteger maxBuyCount; //最大购买数
@property (nonatomic, assign) NSInteger buyCount;

- (BOOL)isEnable;

@end
