//
//  RunRequest.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RunRequest.h"

@implementation RunRequest

// 同步跑步数据
+ (void)syncRunData:(NSInteger)runTime data:(NSData *)data handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_run_manage_controller/dorundatasync";
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"start_run_time":@(runTime),
                                 @"data_1":dataString};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 同步跑步原始数据
+ (void)syncRunSourceData:(NSInteger)runTime data:(NSData *)data handler:(RequestCompleteHandler)handler {
    
    if (!data) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
        const unsigned char *szBuffer = [data bytes];
        for (NSInteger i=0; i < [data length]; ++i) {
            [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        }
        
        NSDictionary *parameters = @{@"start_run_time":@(runTime),
                                     @"origin_data_1":[strTemp copy]};
        NSString *urlString = @"user_run_manage_controller/doorirundatasync";
        [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    BLOCK_EXEC(handler, nil, error);
                }else {
                    BLOCK_EXEC(handler, nil, nil);
                }
            });
        }];
    });
}

+ (void)getRunDataWithRunTime:(NSInteger)runTime handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_run_manage_controller/getuserrundata";
    NSDictionary *parameters = @{@"start_run_time":@(runTime)};
    
    [self POST:urlString parameters:parameters responseClass:[RunResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            RunResponseInfo *info = result;
            info.key = @(runTime).stringValue;
            [info saveCache];
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}


@end
