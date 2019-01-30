//
//  Logbudgetope.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logbudgetope : NSObject
//                                 预算项目备注,   预算项目名称   , 一级分类名称   ,   二级分类名称
@property (nonatomic, copy) NSString *proremark, *budgetname ,*cateonename , *catetwoname,*budgetopename;
//               自增长id        ,对应budget表的budgetid,        操作时间  ,  所属一级分类id，所属二级分类id,    所属三级分类id    ,  预算总价
@property (nonatomic, assign) long  logbudgetopeid, budgetid, budgetopetime, cateoneid, catetwoid , catethreeid, amountzj, doubleamountzj;
// 预算操作类型，1添加2修改3删除4设置星标5设置已购
@property (nonatomic, assign) int budgetopetype;


@end

