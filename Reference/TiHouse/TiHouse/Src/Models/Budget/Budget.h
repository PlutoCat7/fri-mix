//
//  Budget.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class House;
@interface Budget : NSObject
//                                    自增长id  ,期望总价，单位(分), 房屋id, 创建时间
@property (nonatomic, assign) long budgetid, amountqwzj, houseid, budgetupdatetime, amountzj;
//                   县区id,关联region表的regionid, 面积，单位：平方米, 室数量, 厅数量, 厨房数量, 卫生间数量, 阳台数量, 预算状态，1正常2删除 ,是否一键生成预算表（1=是， 0=否）
@property (nonatomic, assign) NSInteger regionid, area, numroom, numhall, numkichen, numtoilet, numbalcony, budgetstatus, type ,lev ,budgetopetype;
//                            预算总价 单位(元)        , 期望总价，单位(元)
@property (nonatomic, assign) CGFloat doubleamountzj, doubleamountqwzj;
//             预算版本名称
@property (nonatomic, copy) NSString *budgetname, *budgetopename, *provname, *cityname, *regionname, *urlshare;
// 分享连接
@property (nonatomic, copy) NSString *linkshare;
//             预算房屋
@property (nonatomic, retain) House *house;

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading, islatestedit;

-(instancetype)initWithHouse:(House *)house;

- (NSString *)NewBudgetToPath;
- (NSDictionary *)NewBudgetToParams;

- (NSString *)RemoveBudgetToPath;
- (NSDictionary *)RemoveBudgetToParams;

+(NSString *)TipStr:(Budget *)Budget;

@end
