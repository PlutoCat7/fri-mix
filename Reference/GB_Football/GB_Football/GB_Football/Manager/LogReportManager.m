//
//  LogReportManager.m
//  GB_Football
//
//  Created by yahua on 2017/9/1.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "LogReportManager.h"
#import "BaseNetworkRequest.h"

#import "GBBluetoothManager.h"

@interface LogReportManager ()

/**
 手环状态
 */
@property (nonatomic, assign) iBeaconStatus status;

@end

@implementation LogReportManager

+ (LogReportManager *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[LogReportManager alloc] init];
    });
    return instance;
}

- (void)startMonitoring {
    
    _status = iBeaconStatus_Unknow;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindiBeaconSuccess) name:Notification_ConnectSuccess object:nil];
}

#pragma mark - Public

+ (void)logReportDailyToFootall {
    
    NSString *key = @"football_daily";
    NSDictionary *params = @{@"type":@(0),
                             @"desc":@"日常切换足球成功",
                             @"battery":@([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.battery).stringValue};
    
    [self reportToServiceWithKey:key parameter:params];
    
}

+ (void)logReportFootallSuccess {

    NSString *key = @"football_daily";
    NSDictionary *params = @{@"type":@(1),
                             @"desc":@"足球模式搜星成功",
                             @"battery":@([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.battery).stringValue};
    
    [self reportToServiceWithKey:key parameter:params];
}

+ (void)logReportFootallToDaily {

    NSString *key = @"football_daily";
    NSDictionary *params = @{@"type":@(2),
                             @"desc":@"足球模式切换到日常模式",
                             @"battery":@([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.battery).stringValue};
    
    [self reportToServiceWithKey:key parameter:params];
}

+ (void)logReportDailyToRun{
    
    NSString *key = @"run_daily";
    NSDictionary *params = @{@"type":@(0),
                             @"desc":@"日常切换足球成功",
                             @"battery":@([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.battery).stringValue};
    
    [self reportToServiceWithKey:key parameter:params];
}

+ (void)logReportRunSuccess {
    
    NSString *key = @"run_daily";
    NSDictionary *params = @{@"type":@(1),
                             @"desc":@"跑步模式搜星成功",
                             @"battery":@([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.battery).stringValue};
    
    [self reportToServiceWithKey:key parameter:params];
}

+ (void)logReportRunToDaily{
    
    NSString *key = @"run_daily";
    NSDictionary *params = @{@"type":@(2),
                             @"desc":@"跑步模式切换到日常模式",
                             @"battery":@([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.battery).stringValue};
    
    [self reportToServiceWithKey:key parameter:params];
}

#pragma mark - NOTification


- (void)bindiBeaconSuccess {
    
    //清除旧的监听
    [self.yah_KVOController unobserveAll];
    
    [self.yah_KVOController observe:[GBBluetoothManager sharedGBBluetoothManager].iBeaconObj keyPath:@"status" block:^(id observer, id object, NSDictionary *change) {
        
        iBeaconStatus status = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status;
        if (status == iBeaconStatus_Sport) {
            if (self.status != iBeaconStatus_Sport) {
                [LogReportManager logReportFootallSuccess];
            }
        }else if(status == iBeaconStatus_Run) {
            if (self.status != iBeaconStatus_Run) {
                [LogReportManager logReportRunSuccess];
            }
        }else if (status == iBeaconStatus_Searching) {
            if (self.status == iBeaconStatus_Normal) {
                [LogReportManager logReportDailyToFootall];
            }
        }else if (status == iBeaconStatus_Run_Entering) {
            if (self.status == iBeaconStatus_Normal) {
                [LogReportManager logReportDailyToRun];
            }
        }else if (status == iBeaconStatus_Normal) {
            if (self.status == iBeaconStatus_Searching ||
                self.status == iBeaconStatus_Sport) {
                [LogReportManager logReportFootallToDaily];
            }else if (self.status == iBeaconStatus_Run_Entering ||
                      self.status == iBeaconStatus_Run) {
                [LogReportManager logReportRunToDaily];
            }
        }
        self.status = status;
    }];
}


#pragma mark - Private

//上报服务端
+ (void)reportToServiceWithKey:(NSString *)key parameter:(NSDictionary *)parameter {
    
    NSDateFormatter *strToDataFormatter = [[NSDateFormatter alloc] init];
    [strToDataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [strToDataFormatter stringFromDate:[NSDate date]];
    if (!dateString) {
        dateString = @"";
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameter];
    [params setObject:dateString forKey:@"time"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[params copy] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *mark = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!mark) {
        mark = @"";
    }
    //上报
    [BaseNetworkRequest sendLogReport:key mark:mark];
}

@end
