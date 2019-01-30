//
//  TunerBudget.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TunerBudget : NSObject

//用户昵称
@property (nonatomic, copy) NSString *nickname;
//预算项目id
@property (nonatomic, assign) long budgetid;
//预算名称
@property (nonatomic, copy) NSString *budgetname;
//详情内容
@property (nonatomic, retain) NSArray *listModelLogbudgetope;
//最新更新时间
@property (nonatomic, assign) long latesttime;
// 分享图片链接
@property (nonatomic, copy) NSString *urlshare;
// 分享链接
@property (nonatomic, copy) NSString *linkshare;

@end
