//
//  AGPSManager.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBBluetoothManager.h"

typedef enum : NSUInteger {
    AGPSProgressStatus_Unknow,
    AGPSProgressStatus_DownAGPS,   //下载星历
    AGPSProgressStatus_WriteAGPS,  //写入星历
    AGPSProgressStatus_Searching,  //搜星中
    AGPSProgressStatus_Success,    //搜星成功
    AGPSProgressStatus_Failure,    //失败
} AGPSProgressStatus;

@interface AGPSManager : NSObject

/**
 手环状态
 */
@property (nonatomic, assign) iBeaconStatus status;

/**
 加速搜星进度状态
 */
@property (nonatomic, assign) AGPSProgressStatus progressStatus;

+ (instancetype)shareInstance;

- (void)reset;

- (void)enterFootballModel:(void(^)(NSError *error))block;

- (void)enterRunModel:(void(^)(NSError *error))block;

//取消加速搜星
- (void)cancelAGPS:(void(^)(NSError *error))block;

//退出足球模式
- (void)leaveAGPS:(void(^)(NSError *error))block;

@end
