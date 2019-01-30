//
//  ScheduleDayListModel.h
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleModel.h"
#import "ScheduleadvertListDataModel.h"

@interface ScheduleDayListModel : NSObject

@property (nonatomic, assign) long day;

@property (nonatomic, strong) NSArray <ScheduleModel*>*scheduleList;

@property (nonatomic, strong) NSArray <ScheduleadvertListDataModel*> *scheduleadvertList;

@end
