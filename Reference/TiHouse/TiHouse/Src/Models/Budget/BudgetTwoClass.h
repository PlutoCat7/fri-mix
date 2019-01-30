//
//  BudgetTwoClass.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/25.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetTwoClass : NSObject


//所属一级分类id，所属二级分类id ,二级分类排序  ,    二级分类显示状态：0不显示，1显示
@property (nonatomic, assign) int cateoneid ,catetwoid ,catetwosort ,catetwostatus;
//预算项目（三级分类）数组
@property (nonatomic, retain) NSMutableArray *catethreeList;
//预算项目（三级分类）排序后的数组筛选后
@property (nonatomic, retain) NSMutableArray *sortList;
//二级分类名称
@property (nonatomic, copy) NSString *catetwoname ,*catetwourlicon;
//                                    一级分类总价
@property (nonatomic, assign) CGFloat twoAmount;

@end
