//
//  RunLogic.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunLogic.h"
#import "RunSyncDataView.h"

#import "GBBluetoothManager.h"
#import "AGPSManager.h"

#import "RunRequest.h"

@implementation RunLogic

+ (void)startAsyncRunData:(void(^)(BOOL success, NSInteger runBeginTime))completeBlock {
    
    RunSyncDataView *syncCircle = [[NSBundle mainBundle] loadNibNamed:@"RunSyncDataView" owner:nil options:nil].firstObject;
    syncCircle.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:syncCircle];
    [syncCircle.syncCircle showWithCompletionBlock:^{
        [syncCircle.syncCircle syncWithCompletionBlock:^{}];
        
        //只有普通模式才能读取足球数据
        if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status != iBeaconStatus_Normal) {
            [[AGPSManager shareInstance] leaveAGPS:^(NSError *error) {
                if (!error) {
                    [self startSyncData:syncCircle complete:completeBlock];
                }else {
                    [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
                    [syncCircle removeFromSuperview];
                    BLOCK_EXEC(completeBlock, NO, 0);
                }
            }];
        }else {
            [self startSyncData:syncCircle complete:completeBlock];
        }
    }];
}

+ (void)startSyncData:(RunSyncDataView *)syncCircle complete:(void(^)(BOOL success, NSInteger runBeginTime))completeBlock {
    
    // 只要有数据就读取，所以这里日期用0
    NSInteger month = 0;
    NSInteger day = 0;
    [[GBBluetoothManager sharedGBBluetoothManager] readRunModelData:month day:day progressBlock:^(NSInteger total, NSInteger index) {
        
        GBLog(@"同步进度:%f", index*1.0/total);
        [syncCircle.syncCircle setPercent:(CGFloat)index*1.0/total*100];
    } serviceBlock:^(id data, id sourceData, NSError *error) {

        if (error)
        {   GBLog(@"跑步数据读取失败");
            [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
            [syncCircle removeFromSuperview];
            BLOCK_EXEC(completeBlock, NO, 0);
        }else {
            GBLog(@"跑步数据读取成功");
            NSTimeInterval beginTime = [self runBeginTime:data];
            if (data) {
                [syncCircle.syncCircle setPercent:100];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                    [syncCircle.syncCircle analysisWithCompletionBlock:^{}];
                    NSData *parseData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
                    [RunRequest syncRunData:beginTime data:parseData handler:^(id result, NSError *error) {
                        if (error) {
                            [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
                            [syncCircle removeFromSuperview];
                            BLOCK_EXEC(completeBlock, NO, 0);
                        }else {
                            [syncCircle performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5f];
                            BLOCK_EXEC(completeBlock, YES, beginTime);
                            [[GBBluetoothManager sharedGBBluetoothManager] cleanRunData:^(id data, NSError *error) {
                                if (error) {
                                    GBLog(@"跑步数据同步成功后， 删除数据成功");
                                }else {
                                    GBLog(@"跑步数据同步成功后， 删除数据失败");
                                }
                            }];
                        }
                    }];
                });
            }
            if (sourceData)
            {
                [RunRequest syncRunSourceData:beginTime data:sourceData handler:nil];
            }
            
        }
    }];
}

+ (NSInteger)runBeginTime:(NSDictionary *)dataDict {
    
    if (!dataDict) {
        return 0;
    }
    
    NSDateComponents *GMT8DateComponents = [[NSDate date] dateComponentsWithGMT8];
    // 计算开始时间
    NSInteger year = GMT8DateComponents.year;
    NSInteger month = [[dataDict objectForKey:@"month"] integerValue];
    NSInteger day = [[dataDict objectForKey:@"day"] integerValue];
    NSInteger hour = [[dataDict objectForKey:@"hour"] integerValue];
    NSInteger minute = [[dataDict objectForKey:@"minute"] integerValue];
    NSInteger second = [[dataDict objectForKey:@"second"] integerValue];
    //判断比赛记录是否比当前日期大
    if (month>GMT8DateComponents.month) {
        year -= 1;
    }else if (month==GMT8DateComponents.month) {
        if (day>GMT8DateComponents.day) {
            year -= 1;
        }else if (day == GMT8DateComponents.day) {
            if (hour>GMT8DateComponents.hour) {
                year -= 1;
            }else if (hour == GMT8DateComponents.hour) {
                if (minute>GMT8DateComponents.minute) {
                    year -= 1;
                }
            }
        }
    }
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    NSDate *localBeginDate = [NSDate dateWithGMT8DateComponents:dateComponents];
    
    return localBeginDate.timeIntervalSince1970;
}

@end
