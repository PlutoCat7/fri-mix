//
//  TweetSchedule.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetSchedule : NSObject

//房屋id
@property (nonatomic, assign) long houseid;
//日程开始时间
@property (nonatomic ,assign) long schedulestarttime;
//日程结束时间
@property (nonatomic ,assign) long scheduleendtime;
//日程事件
@property (nonatomic, copy) NSString *schedulename;
//提醒的用户头像URL，
@property (nonatomic ,copy) NSString *urlschedulearruidtip;
//提醒的用户头像URL数组
@property (nonatomic, retain) NSArray *urlschedulearruidtipArr;
//行程完成状态
@property (nonatomic, assign) NSInteger scheduletype;

-(TweetSchedule *)transformTweetSchedule;

@property (nonatomic, assign) long scheduleid;
///房屋ID
//@property (nonatomic, assign) long houseid;
///日程ID
@property (nonatomic, assign) long uid;
///日程名称
//@property (nonatomic, copy) NSString *schedulename;
///日程创建时间
@property (nonatomic, assign) long schedulectime;
///完成状态，0未完成1已完成
//@property (nonatomic, assign) int scheduletype;
///日程开始时间
//@property (nonatomic, assign) long schedulestarttime;
///日程结束时间
//@property (nonatomic, assign) long scheduleendtime;
///日程提醒时间
@property (nonatomic, assign) long scheduletiptime;
///日程提醒类型，1不提醒2事件开始时3提前五分钟4提前三十分钟5提前一小时6提前一天7提前两天
@property (nonatomic, assign) long scheduletiptype;
///提醒谁看用户uid数组，以,隔开
@property (nonatomic, copy) NSString *schedulearruidtip;
///日程备注
@property (nonatomic, copy) NSString *scheduleremark;
///颜色值，6位大写字母，如CCCCCC
@property (nonatomic, copy) NSString *schedulecolor;
///提醒谁看用户头像 以,隔开
//@property (nonatomic, copy) NSString *urlschedulearruidtip;
///跨天开始日期
//@property (nonatomic, copy) NSString *schedulestarttime;
///提醒谁看用户姓名 以,隔开
@property (nonatomic, copy) NSString *nameschedulearruidtip;



@end
