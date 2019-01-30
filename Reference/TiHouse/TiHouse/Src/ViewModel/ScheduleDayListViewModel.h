//
//  ScheduleDayListViewModel.h
//  TiHouse
//
//  Created by apple on 2018/1/28.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleViewModel.h"
#import "ScheduleDayModel.h"


@interface ScheduleDayListViewModel : ScheduleViewModel

@property (nonatomic, strong) RACSubject *addSchedule;

@property (nonatomic, strong) ScheduleDayModel * scheduleDay;
    
@property (nonatomic, strong) NSDate *lastMonthDate;
    
@property (nonatomic, strong) NSDate *nextMonthDate;

///请求的年月yyyy-MM
@property (nonatomic, copy) NSString *loadDate;


/**
 请求日历列表
 */
- (void)requestScheduleList;


@end
