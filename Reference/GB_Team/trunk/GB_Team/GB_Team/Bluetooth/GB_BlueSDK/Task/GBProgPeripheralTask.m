//
//  GBProgPeripheralTask.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/28.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBProgPeripheralTask.h"

// 调用父类的私有变量
@interface GBPeripheralTask(Extend)

- (void)endTask;

@end


@interface GBProgPeripheralTask()

@property (nonatomic, copy) NSMutableArray *didProgressBlockList;        // 操作进度返回

@end

@implementation GBProgPeripheralTask

- (instancetype)initWithProgressProfile:(ProgressPacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock progress:(ResultProgressBlock)progress {
    
    if(self=[super initWithProfile:profile serviceBlock:serviceBlock]){
        _didProgressBlockList = [NSMutableArray arrayWithCapacity:1];
        if (serviceBlock != nil) {
            [_didProgressBlockList addObject:progress];
        }
        
    }
    return self;
}

// 添加对任务的监听block
- (void)addListenProgressPeripheralTask:(ResultProgressBlock)progressBlock {
    if (progressBlock != nil) {
        [self.didProgressBlockList addObject:progressBlock];
    }
}

// 强制接管任务的block
- (void)forceTakeoverProgressPeripheralTask:(ResultProgressBlock)progressBlock {
    [self.didProgressBlockList removeAllObjects];
    if (progressBlock != nil) {
        [self.didProgressBlockList addObject:progressBlock];
    }
}

- (void)startTask {
    [self setValue:[NSNumber numberWithInteger:TaskState_Doing] forKey:@"taskState"];
    
    if (self.taskDelegate && [self.taskDelegate respondsToSelector:@selector(peripheralTaskStart:)]) {
        [self.taskDelegate peripheralTaskStart:self];
    }
    
    __weak typeof(self) weakSelf = self;
    [(ProgressPacketProfile *)self.profile executeProgressProfile:^(id parseData, id sourceData, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"profile：%@ is error: %@", strongSelf.profile, error.domain);
        }
        
        for (ResultServiceBlock serviceBlock in strongSelf.didServiceBlockList) {
            serviceBlock(parseData, sourceData, error);
        }
        [strongSelf endTask];
        
    } progressBlock:^(NSInteger total, NSInteger index) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (ResultProgressBlock progressBlock in strongSelf.didProgressBlockList) {
            progressBlock(total, index);
        }
    }];

}

- (void)stopTask {
    [self.profile cancelProfile];
}

@end
