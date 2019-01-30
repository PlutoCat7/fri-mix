//
//  BudgetThreeClass.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetThreeClass : NSObject<NSCopying>
//                             预算金额，单位(分), 预算id， 预算项目自增长id ,所属一级分类id
@property (nonatomic, assign) long amountzj ,budgetid ,budgetproid, cateoneid;
//三级分类显示状态，0不显示(可删除)1显示(不可删除)，对应catethree表
@property (nonatomic, assign) int catethreestatus;
//所属二级分类id，关联catetwo表的catetwoid
@property (nonatomic, assign) long catetwoid;
//二级分类显示状态：0不显示，1显示
@property (nonatomic, assign) int catetwostatus;
//预算项目名称
@property (nonatomic, copy) NSString *proname;
//预算项目备注
@property (nonatomic, copy) NSString *proremark;
//星标项目类型，0非星标1星标项目
@property (nonatomic, assign) int protypexb;
//已购项目类型，0非已购1已购项目
@property (nonatomic, assign) int protypeyg;
//预算金额，单位(元)
@property (nonatomic, assign) CGFloat doubleamountzj;

@property (nonatomic, copy) NSString *catethreetipb;//B区提醒文字
@property (nonatomic, copy) NSString *catethreetipa;//A区提醒文字
@property (nonatomic, copy) NSString *catethreeunit;//单位

@property (nonatomic, assign) long catethreepricelow;//经济型单价，单位：分
@property (nonatomic, assign) long catethreepricelowmid;//舒适性单价，单位：分
@property (nonatomic, copy) NSString *catethreeunitname; //单位名称

@property (nonatomic, assign) long catethreepricemid;//品质型单价，单位：分
@property (nonatomic, assign) long catethreepricehig;//轻奢型单价，单位：分
@property (nonatomic, assign) CGFloat pronum;//数量个数/面积数
@property (nonatomic, assign) long proamountunit;//预算单价，单位(分)


//添加预算项目
- (NSString *)AddBudgetPortoPath;
- (NSDictionary *)AddBudgetPorParams;
//编辑预算项目
- (NSString *)EidtBudgetPortoPath;
- (NSDictionary *)EidtBudgetPorParams;
//删除预算项目
- (NSString *)RemoveBudgetPortoPath;
- (NSDictionary *)RemoveBudgetPorParams;


@end
