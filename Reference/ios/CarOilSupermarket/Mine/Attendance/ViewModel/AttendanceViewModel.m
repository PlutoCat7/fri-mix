//
//  AttendanceViewModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/20.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "AttendanceViewModel.h"
#import "AttendanceCellModel.h"

#import "UserRequest.h"

@interface AttendanceViewModel ()

@property (nonatomic, strong) AttendanceSituationInfo *attendanceInfo;

@end

@implementation AttendanceViewModel

- (void)getAttendanceDataWithHandler:(void(^)(NSError *error))handler {
    
    [UserRequest getAttendanceDataWithHandler:^(id result, NSError *error) {
        
        if (!error) {
            self.attendanceInfo = result;
            [self handlerNetworkData];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)attendanceTodayWithHandler:(void(^)(NSError *error))handler {
    
    [UserRequest doAttendanceWithHandler:^(id result, NSError *error) {
        
        if (!error) {
            self.attendanceInfo.days += 1;
            for (NSArray<AttendanceCellModel *> *cellModels in self.cellModels) {
                for (AttendanceCellModel *cellModel in cellModels) {
                    if (cellModel.isToday) {
                        cellModel.isAttendance = YES;;
                    }
                }
            }
            //请求接口重新刷新数据
            [self getAttendanceDataWithHandler:^(NSError *error) {
                self.needRefreshView = YES;
            }];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (NSAttributedString *)thisMonthTotalAttendanceCount {
    
    NSString *dayString = @(self.attendanceInfo.days).stringValue;
    NSString *string = [NSString stringWithFormat:@"本月累计签到 %td 天", self.attendanceInfo.days];
    NSMutableAttributedString *mutAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [mutAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17*kAppScale] range:[string rangeOfString:dayString]];
    [mutAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x14B0FF] range:[string rangeOfString:dayString]];
    return [mutAttributedString copy];
}

- (NSString *)allAttendanceDaysString {
    
    return self.attendanceInfo.signInfo;
}

- (NSString *)monthName {
    
    return [NSString stringWithFormat:@"%td月",[self.attendanceInfo serverDate].month];
}

- (NSString *)withdrawInfo {
    
    return self.attendanceInfo.withdrawInfo;
}

- (BOOL)isHasTodayAttendance {
    
    for (NSArray<AttendanceCellModel *> *cellModels in self.cellModels) {
        for (AttendanceCellModel *cellModel in cellModels) {
            if (cellModel.isToday) {
                return cellModel.isAttendance;
            }
        }
    }
    return NO;
}

#pragma mark - Private

- (void)handlerNetworkData {
    
    NSMutableArray<NSArray<AttendanceCellModel *> *> *result = [NSMutableArray arrayWithCapacity:1];
    NSDate *currentDate = [self.attendanceInfo serverDate];
    NSInteger monthDayLength = [self getNumberOfDaysInMonth];
    //创建默认
    NSInteger index = 0;
    for (NSInteger i=0; i<5; i++) {
        NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:7];
        for (NSInteger i=0; i<7; i++) {
            AttendanceCellModel *cellModel = [[AttendanceCellModel alloc] init];
            cellModel.dayString = @(index).stringValue;
            cellModel.day = index;
            cellModel.isToday = (currentDate.day==index);
            if(index==0 || index>monthDayLength) {
                cellModel.dayString = @"";
            }
            [tmpList addObject:cellModel];
            index++;
        }
        [result addObject:[tmpList copy]];
    }
    
    for (AttendanceDateInfo *info in self.attendanceInfo.list) {
        for (NSArray<AttendanceCellModel *> *cellModels in result) {
            for (AttendanceCellModel *cellModel in cellModels) {
                if (info.d == cellModel.day) {
                    cellModel.isAttendance = YES;
                }
            }
        }
    }
    
    self.cellModels = [result copy];
}

// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSDate * currentDate = [self.attendanceInfo serverDate];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                                  forDate:currentDate];
    return range.length;
}

@end
