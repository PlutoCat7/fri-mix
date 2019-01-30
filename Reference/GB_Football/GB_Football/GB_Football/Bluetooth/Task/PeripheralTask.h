//
//  PeripheralTask.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PacketProfile.h"

@interface PeripheralTask : NSObject

@property (nonatomic, strong) __kindof PacketProfile *profile;
@property (nonatomic, copy) void(^doTask)();
@property (nonatomic, assign) GBBluetoothTask_PRIORITY_Level taskLevel;

- (instancetype)initWithProfile:(PacketProfile *)profile doTask:(void(^)())doTask;
- (void)startTask;
- (void)endTask;
- (void)stopTask;

@end
