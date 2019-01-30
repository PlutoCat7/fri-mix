//
//  RunRequest.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "RunResponseInfo.h"

@interface RunRequest : BaseNetworkRequest

// 同步跑步数据
+ (void)syncRunData:(NSInteger)runTime data:(NSData *)data handler:(RequestCompleteHandler)handler;

// 同步跑步原始数据
+ (void)syncRunSourceData:(NSInteger)runTime data:(NSData *)data handler:(RequestCompleteHandler)handler;

+ (void)getRunDataWithRunTime:(NSInteger)runTime handler:(RequestCompleteHandler)handler;

@end
