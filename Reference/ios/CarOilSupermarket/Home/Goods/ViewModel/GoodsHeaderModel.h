//
//  GoodsHeaderModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/18.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsHeaderModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *imagesURL;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *nowPriceString;  // 售价
@property (nonatomic, copy) NSString *oldPriceString;  // 原价
@property (nonatomic, copy) NSString *saleDesc;
@property (nonatomic, copy) NSString *point;

@end
