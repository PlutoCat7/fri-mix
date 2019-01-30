//
//  AddScheduleModel.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddScheduleModel : NSObject

@property (nonatomic, assign) long scheduleid;//日程id
@property (nonatomic, assign) long houseid;//房屋ID
@property (assign, nonatomic) long uid;//用户ID
@property (copy, nonatomic) NSString * schedulename;//日程名称
@property (assign, nonatomic) int scheduletype;//完成状态，0未完成1已完成
@property (nonatomic, assign) long schedulestarttime;//日程开始时间
@property (nonatomic, assign) long scheduleendtime;//日程结束时间
@property (assign, nonatomic) int scheduletiptype;//日程提醒类型，1不提醒2事件开始时3提前五分钟4提前三十分钟5提前一小时6提前一天7提前两天
@property (copy, nonatomic) NSString * schedulearruidtip;//提醒谁看用户uid数组，以,隔开
@property (copy, nonatomic) NSString * scheduleremark;//日程备注
@property (copy, nonatomic) NSString * schedulecolor;//颜色值，6位大写字母，如CCCCCC

@end
