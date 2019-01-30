//
//  PeripheralTask.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PeripheralTask.h"

@implementation PeripheralTask

- (instancetype)initWithProfile:(PacketProfile *)profile doTask:(void(^)())doTask {
    
    if(self=[super init]){
        _profile = profile;
        _doTask = doTask;
        _taskLevel = GBBluetoothTask_PRIORITY_Normal;
    }
    return self;
}

- (void)startTask {
    
    [self.profile startTask];
    BLOCK_EXEC(self.doTask);
}

- (void)endTask {
    
    [self.profile stopTask];
}

- (void)stopTask {
    
    [self.profile stopTask];
    self.doTask = nil;
}

@end
