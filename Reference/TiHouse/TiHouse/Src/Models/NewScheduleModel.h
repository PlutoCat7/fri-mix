//
//  NewScheduleModel.h
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewModel.h"
#import "ScheduleModel.h"

@interface NewScheduleModel : BaseViewModel

@property (nonatomic, strong) RACSubject * remindPeopleSubject;
@property (nonatomic, strong) RACSubject * remindTimeSubject;
@property (nonatomic, strong) RACSubject * finishSubject;//保存或者编辑成功
///日程列表和日历模型
@property (strong, nonatomic) ScheduleModel * scheduleM;
///创建时间
@property (copy, nonatomic) NSDate * createDate;

/**
 请求删除日程
 */
- (void)requestDeleteSchedule:(void (^)(id data))block;

@end
