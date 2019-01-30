//
//  Budgetpro.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "Budgetpro.h"
#import "Budget.h"
#import "BudgetOneClass.h"
#import "BudgetTwoClass.h"
#import "BudgetThreeClass.h"

@implementation Budgetpro

-(instancetype)init{
    if (self = [super init]) {
        _isSort = NO;
        _selectBuy = NO;
        _selectMoney = NO;
    }
    return self;
}

/* 数组中存储模型数据，需要说明数组中存储的模型数据类型 */
+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"cateoneList" : @"BudgetOneClass"
             };
}








-(Budgetpro *)upDataBudgetpro{
    __block CGFloat budgetproamount;
    [self.cateoneList enumerateObjectsUsingBlock:^(BudgetOneClass *oneClass, NSUInteger idx, BOOL * _Nonnull stop) {
        __block CGFloat oneAllAmount;
        [oneClass.catetwoList enumerateObjectsUsingBlock:^(BudgetTwoClass *twoClass, NSUInteger idx, BOOL * _Nonnull stop) {
            //清空数字
            if (!twoClass.sortList) {
                twoClass.sortList = [NSMutableArray new];
            }
            [twoClass.sortList removeAllObjects];
            __block CGFloat twoAllAmount = 0;
            [twoClass.catethreeList enumerateObjectsUsingBlock:^(BudgetThreeClass *threeClass, NSUInteger idx, BOOL * _Nonnull stop) {
                 //累加计算总价
                 twoAllAmount += threeClass.amountzj;
                if (_selectMoney && _selectBuy && threeClass.protypeyg && threeClass.protypexb) {
                    [twoClass.sortList addObject:threeClass];
                }
                //添加显示购买
                if (_selectMoney && threeClass.protypeyg && !_selectBuy) {
                    [twoClass.sortList addObject:threeClass];
                }
                //添加显示星标
                if (_selectBuy && threeClass.protypexb && !_selectMoney) {
                    [twoClass.sortList addObject:threeClass];
                }
                //如果都不是全部添加
                if (!_selectBuy && !_selectMoney) {
                    [twoClass.sortList addObject:threeClass];
                }
                
            }];
            if (_isSort) {
                NSSortDescriptor *des1 = [NSSortDescriptor sortDescriptorWithKey:@"amountzj" ascending:_ascending];
                [twoClass.sortList sortUsingDescriptors:@[des1]];
            }
            //二级总金额
            twoClass.twoAmount = twoAllAmount;
            //累加计算二级总金额给一级
            oneAllAmount += twoAllAmount;
        }];
        //一级总金额
        oneClass.oneAmount = oneAllAmount;
        budgetproamount += oneAllAmount;
    }];
    self.budgetproamount = budgetproamount;
    [self.cateoneList enumerateObjectsUsingBlock:^(BudgetOneClass *oneClass, NSUInteger idx, BOOL * _Nonnull stop) {
        //百分比
        if ((int)self.budgetproamount == 0) {
            oneClass.percentage = 0.00;
        }else{
            oneClass.percentage = oneClass.oneAmount/self.budgetproamount;
        }
    }];
    
//    Budget *budget = self.budget;
    //期望单价
    self.proprice = self.budgetamount/(_budgetarea*1.0);
    //预算单价
    self.budgetprice = self.budgetproamount/(_budgetarea*1.0);
   //差价
    self.priceDifference = self.budgetamount - self.budgetproamount;
    
    return self;
}



@end
