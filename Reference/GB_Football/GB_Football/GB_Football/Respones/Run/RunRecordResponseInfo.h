//
//  RunRecordResponseInfo.h
//  GB_Football
//
//  Created by gxd on 17/7/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@interface RunRecordInfo : YAHActiveObject

@property (nonatomic, assign) long startTime;
@property (nonatomic, assign) float avgSpeed;
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) float consume;
@property (nonatomic, assign) NSInteger consumeTime;

@property (nonatomic, copy) NSString *withSpeedString;
@property (nonatomic, copy) NSString *consumeTimeString;

@end

@interface RunRecordResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<RunRecordInfo *> *data;

@end
