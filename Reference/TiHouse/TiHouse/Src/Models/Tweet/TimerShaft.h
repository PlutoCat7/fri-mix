//
//  TimerShaft.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class modelDairy, TunerBudget ,modelTallys,TweetScheduleMap;
@interface TimerShaft : NSObject
//数据类型 1 日记 2预算 3记账 4日程
@property (nonatomic, assign) NSInteger type;
//最后更新时间
@property (nonatomic, assign) long latesttime;
//时间轴model
@property (nonatomic, retain) modelDairy *modelDairy;
//预算model
@property (nonatomic, retain) TunerBudget *modelBudget;
//账单model
@property (nonatomic, retain) modelTallys *modelTally;
//日程model
@property (nonatomic, retain) TweetScheduleMap *scheduleMap;


@end
