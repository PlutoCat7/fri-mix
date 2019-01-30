//
//  DailyRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "DailyRequest.h"

@implementation DailyRequest

+ (void)queryDailyData:(long)startDate endDate:(long)endDate handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_daily_data_query_controller/douserdailydataquery";
    NSDictionary *parameters = @{@"start_date":@(startDate),
                                 @"end_date":@(endDate)};
    
    [self POST:urlString parameters:parameters responseClass:[DailyResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            DailyResponeInfo *info = (DailyResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)querySpecifyDailyData:(long)specifyDate handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_daily_data_query_controller/dogetcurrRange";
    NSDictionary *parameters = @{@"current_time":@(specifyDate)};
    
    [self POST:urlString parameters:parameters responseClass:[DailySummaryResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            DailySummaryResponeInfo *info = (DailySummaryResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)queryWhichDayNotSync:(long)startDate endDate:(long)endDate handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_which_day_not_sync_controller/dowhichdaynotsync";
    NSDictionary *parameters = @{@"start_date":@(startDate),
                                 @"end_date":@(endDate)};
    
    [self POST:urlString parameters:parameters responseClass:[DailyHasDataResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            DailyHasDataResponseInfo *info = (DailyHasDataResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)syncDailyData:(NSData *)data sportData:(NSData *)sportData handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_daily_data_sync_controller/dodailydatasync";
    NSDictionary *parameters = @{@"data":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]};
    if (sportData) {
        parameters = @{@"data":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],
                       @"match_data":[[NSString alloc] initWithData:sportData encoding:NSUTF8StringEncoding]};
    }
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

@end
