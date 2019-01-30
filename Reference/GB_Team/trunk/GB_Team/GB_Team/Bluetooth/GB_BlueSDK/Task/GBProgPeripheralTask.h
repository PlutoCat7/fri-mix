//
//  GBProgPeripheralTask.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/28.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBPeripheralTask.h"
#import "ProgressPacketProfile.h"

@interface GBProgPeripheralTask : GBPeripheralTask

@property (nonatomic, copy, readonly) NSMutableArray *didProgressBlockList;

- (instancetype)initWithProgressProfile:(ProgressPacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock progress:(ResultProgressBlock)progress;
// 添加对任务的监听block
- (void)addListenProgressPeripheralTask:(ResultProgressBlock)progressBlock;
// 强制接管任务的block
- (void)forceTakeoverProgressPeripheralTask:(ResultProgressBlock)progressBlock;

@end
