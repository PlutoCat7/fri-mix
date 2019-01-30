//
//  ScheduleViewModel.h
//  TiHouse
//
//  Created by apple on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseListViewModel.h"
#import "ScheduleOptionsViewModel.h"
#import "ScheduleDayListModel.h"

#define kDate @"kDate"
#define kScheduleList @"kScheduleList"

typedef void(^RequestSuccess)(BOOL status);

@interface ScheduleViewModel : BaseListViewModel

@property (nonatomic, strong) ScheduleOptionsViewModel *scheduleOptionsViewModel;

@property (nonatomic, strong) NSMutableArray <ScheduleModel *>*arrSysData;

@property (nonatomic, strong) NSMutableArray *arrSectionData;

@property (nonatomic, assign) NSInteger deleteScheduleId;

@property (nonatomic, assign) NSInteger houseId;

@property (nonatomic, assign) BOOL isEdit;

- (NSDictionary *)getParamWithPage:(NSInteger)page;

/**
 请求删除日程
 */
- (void)requestDeleteSchedule:(RequestSuccess)block;

/**
 请求完成日程
 */
- (void)requestFinishSchedule:(RequestSuccess)block;

@end

