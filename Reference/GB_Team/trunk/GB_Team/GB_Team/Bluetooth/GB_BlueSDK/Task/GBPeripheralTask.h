//
//  GBPeripheralTask.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/16.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PacketProfile.h"
#import "GBBleConstants.h"

typedef enum {
    TaskState_Wait = 0,
    TaskState_Doing = 1,
    TaskState_End
} TaskState;

@class GBPeripheralTask;
@protocol GBPeripheralTaskDelegate <NSObject>

- (void)peripheralTaskStart:(GBPeripheralTask *)peripheralTask;
- (void)peripheralTaskEnd:(GBPeripheralTask *)peripheralTask;

@end

@interface GBPeripheralTask : NSObject

@property (nonatomic, copy, readonly) NSMutableArray *didServiceBlockList;
@property (nonatomic, assign, readonly) TaskState taskState;
@property (nonatomic, strong, readonly) __kindof PacketProfile *profile;

@property (nonatomic, weak) id<GBPeripheralTaskDelegate> taskDelegate;

- (instancetype)initWithProfile:(PacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock;
// 添加对任务的监听block
- (void)addListenPeripheralTask:(ResultServiceBlock)serviceBlock;
// 强制接管任务的block
- (void)forceTakeoverPeripheralTask:(ResultServiceBlock)serviceBlock;

- (void)startTask;
- (void)stopTask;

// 判断任务是否相等
- (BOOL)isEqualTask:(id)object;

@end
