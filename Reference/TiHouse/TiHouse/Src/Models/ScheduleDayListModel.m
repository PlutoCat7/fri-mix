//
//  ScheduleDayListModel.m
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleDayListModel.h"

@implementation ScheduleDayListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"scheduleList" : [ScheduleModel class],
             @"scheduleadvertList" : [ScheduleadvertListDataModel class]
             };
}
@end
