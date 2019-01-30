//
//  LogReportManager.h
//  GB_Football
//
//  Created by yahua on 2017/9/1.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogReportManager : NSObject

+ (LogReportManager *)sharedInstance;

//上报监听
- (void)startMonitoring;

//手环模式相关上报
+ (void)logReportDailyToFootall;

+ (void)logReportFootallSuccess;

+ (void)logReportFootallToDaily;

+ (void)logReportDailyToRun;

+ (void)logReportRunSuccess;

+ (void)logReportRunToDaily;

@end
