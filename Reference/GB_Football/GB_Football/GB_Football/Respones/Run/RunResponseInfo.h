//
//  RunResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface RunDetailInfo : YAHActiveObject

@property (nonatomic, assign) float avgSpeed;
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) float consume;
@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, assign) NSInteger consumeTime;
@property (nonatomic, strong) NSDictionary *run_data;

@property (nonatomic, copy) NSString *withSpeedString;
@property (nonatomic, copy) NSString *consumeTimeString;

@end

@interface RunResponseInfo : GBResponseInfo

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) RunDetailInfo *data;

@end
