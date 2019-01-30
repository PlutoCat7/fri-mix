//
//  DailyRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"

#import "DailyResponeInfo.h"
#import "DailyHasDataResponseInfo.h"
#import "DailySummaryResponeInfo.h"

@interface DailyRequest : BaseNetworkRequest

// 查看日常数据
+ (void)queryDailyData:(long)startDate endDate:(long)endDate handler:(RequestCompleteHandler)handler;

// 获取指定某天的数据详情
+ (void)querySpecifyDailyData:(long)specifyDate handler:(RequestCompleteHandler)handler;

// 查看哪天没有数据
+ (void)queryWhichDayNotSync:(long)startDate endDate:(long)endDate handler:(RequestCompleteHandler)handler;

// 同步数据
+ (void)syncDailyData:(NSData *)data sportData:(NSData*)sportData handler:(RequestCompleteHandler)handler;


@end
