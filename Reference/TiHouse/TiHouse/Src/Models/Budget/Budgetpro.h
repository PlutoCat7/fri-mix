//
//  Budgetpro.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Budget.h"
@interface Budgetpro : NSObject

@property (nonatomic, assign) long budgetid;
@property (nonatomic, assign) long budgetproid;
//                                       期望总价         预算总价
@property (nonatomic, assign) CGFloat budgetamount, budgetproamount;
//                                    期望单价
@property (nonatomic, assign) CGFloat proprice;
//                                    期望单价
@property (nonatomic, assign) NSInteger budgetarea;
//                                    预算单价
@property (nonatomic, assign) CGFloat budgetprice;
//                                    超额或节省金额 -- 差价
@property (nonatomic, assign) CGFloat priceDifference;
//预算项目（一级分类）数组
@property (nonatomic, retain) NSMutableArray *cateoneList;
//预算项目
@property (nonatomic, retain) Budget *budget;
//预算项目
@property (nonatomic, copy) NSString *budgetname;


//星标 ，已够  --------  筛选
@property (nonatomic, assign) BOOL selectBuy;
@property (nonatomic, assign) BOOL selectMoney;
//价格排序
@property (nonatomic, assign) BOOL isSort;//是否排序
@property (nonatomic, assign) BOOL ascending;//是否升序


//更新数据将期望单价 数据补齐，UI用到
//isSort 是否排序
//ascending   升序
-(Budgetpro *)upDataBudgetpro;


@end
