//
//  GBPeripheralTask.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/16.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBPeripheralTask.h"
#import "PacketProfile.h"

@interface GBPeripheralTask()

@property (nonatomic, copy) NSMutableArray *didServiceBlockList;         // 处理蓝牙返回
@property (nonatomic, assign) TaskState taskState;

@end

@implementation GBPeripheralTask

- (void)dealloc
{
    
}

- (instancetype)initWithProfile:(PacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock {
    
    if(self=[super init]){
        _profile = profile;
        _taskState = TaskState_Wait;
        
        _didServiceBlockList = [NSMutableArray arrayWithCapacity:1];
        if (serviceBlock != nil) {
            [_didServiceBlockList addObject:serviceBlock];
        }
        
    }
    return self;
}

// 添加对任务的监听block
- (void)addListenPeripheralTask:(ResultServiceBlock)serviceBlock {
    if (serviceBlock != nil) {
        [self.didServiceBlockList addObject:serviceBlock];
    }
}

// 强制接管任务的block
- (void)forceTakeoverPeripheralTask:(ResultServiceBlock)serviceBlock {
    [self.didServiceBlockList removeAllObjects];
    if (serviceBlock != nil) {
        [self.didServiceBlockList addObject:serviceBlock];
    }
}
    
- (BOOL)isEqualTask:(id)object {
    if (![object isMemberOfClass:[GBPeripheralTask class]]) {
        return NO;
    }

    if (![self.profile isEqualProfile:((GBPeripheralTask *) object).profile]) {
        return NO;
    }
    return YES;
}
    
- (void)startTask {
    _taskState = TaskState_Doing;
    if (self.taskDelegate && [self.taskDelegate respondsToSelector:@selector(peripheralTaskStart:)]) {
        [self.taskDelegate peripheralTaskStart:self];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.profile executeProfile:^(id parseData, id sourceData, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"profile：%@ is error: %@", strongSelf.profile, error.domain);
        }
        for (ResultServiceBlock serviceBlock in strongSelf.didServiceBlockList) {
            serviceBlock(parseData, sourceData, error);
        }
        [strongSelf endTask];
    }];
}
    
- (void)endTask {
    _taskState = TaskState_End;
    
    if (self.taskDelegate && [self.taskDelegate respondsToSelector:@selector(peripheralTaskEnd:)]) {
        [self.taskDelegate peripheralTaskEnd:self];
    }
}
    
- (void)stopTask {
    
    for (ResultServiceBlock serviceBlock in self.didServiceBlockList) {
        serviceBlock(nil, nil, [NSError errorWithDomain:@"Bluetooth scan over time" code:BeanErrors_Cancel userInfo:nil]);
    }
    [self.profile cancelProfile];
}

@end
