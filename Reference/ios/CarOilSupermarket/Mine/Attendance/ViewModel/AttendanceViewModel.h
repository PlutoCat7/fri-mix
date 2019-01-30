//
//  AttendanceViewModel.h
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AttendanceCellModel;

@interface AttendanceViewModel : NSObject

@property (nonatomic, assign) BOOL needRefreshView;
@property (nonatomic, strong) NSArray<NSArray<AttendanceCellModel *> *> *cellModels;

- (void)getAttendanceDataWithHandler:(void(^)(NSError *error))handler;

- (void)attendanceTodayWithHandler:(void(^)(NSError *error))handler;

- (NSAttributedString *)thisMonthTotalAttendanceCount;

- (NSString *)allAttendanceDaysString;

- (NSString *)monthName;

- (NSString *)withdrawInfo;

/**
 今天是否已签到
 */
- (BOOL)isHasTodayAttendance;

@end
