//
//  BudgetOneClass.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetOneClass : NSObject

//                               所属一级分类id,  一级分类排序
@property (nonatomic, assign) int cateoneid, cateonesort;
//预算项目（二级分类）数组
@property (nonatomic, retain) NSMutableArray *catetwoList;
//一级分类名称
@property (nonatomic, copy) NSString *cateonename ,*urlicon;
//                                    一级分类总价
@property (nonatomic, assign) CGFloat oneAmount;
//                                    一级分类占总价百分比
@property (nonatomic, assign) CGFloat percentage;

@end
