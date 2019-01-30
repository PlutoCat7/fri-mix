//
//  ShoppingCartModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/5.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAHActiveObject.h"

@interface ShoppingCartModel : YAHActiveObject

@property (nonatomic, assign) NSInteger shoppingId;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger stock;
@property (nonatomic, assign) NSInteger maxbuy;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumb;
@property (nonatomic, assign) CGFloat marketprice;
@property (nonatomic, assign) CGFloat productprice;

@property (nonatomic, assign) BOOL isSelect;        //是否购买选择
@property (nonatomic, assign) BOOL isEdit;          //是否处于编辑状态
@property (nonatomic, assign) BOOL isDeleteSelect;  //是否删除选择

//可以增加吗
- (BOOL)canIncrease;

- (BOOL)canReduce;

- (CGFloat)goodsTotalPrice;

@end
