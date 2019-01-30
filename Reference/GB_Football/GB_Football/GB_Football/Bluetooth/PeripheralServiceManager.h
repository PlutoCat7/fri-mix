//
//  PeripheralServiceManager.h
//  GB_Football
//
//  Created by wsw on 16/8/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleGlobal.h"

@interface PeripheralServiceManager : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;

- (void)cleanPeripheralTask;

// 电量读取、版本号获取
- (void)readBatteryVersion:(ReadServiceBlock)serviceBlock;

//读取电量
- (void)readBattery:(ReadServiceBlock)serviceBlock;

//读取硬件版本号
- (void)readDeviceVersion:(ReadMultiServiceBlock)serviceBlock;

// 矫正手环时间
- (void)adjustDate:(WriteServiceBlock)serviceBlock;

// 读取多天普通模式的基本数据记录
- (void)readMutableCommonModelData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(ReadServiceBlock)serviceBlock;
- (void)cancelMutableCommonModelData;

// 读取多天运动模式下步数数据记录
- (void)readMutableSportStepData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(ReadServiceBlock)serviceBlock;
- (void)cancelMutableSportStepData;

// 读取某日运动模式的基本数据记录
- (void)readSportModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock;
- (void)cancelSportModelData;

// 固件升级
- (void)updateFireware:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock;

// 星历写入
- (void)searchStartProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock;
- (void)cancelSearchStar;

/**
 检测手环状态

 @param serviceBlock 回调block
 */
- (void)checkModelWithServiceBlock:(ReadServiceBlock)serviceBlock;
/**
 切换手环模式
 
 @param index 0：普通模式  1：运动模式
 @param serviceBlock 回调block
 */
- (void)switchModelWithIndx:(NSInteger)index serviceBlock:(WriteServiceBlock)serviceBlock;

/**
 搜星是否成功判断

 @param serviceBlock 回调block
 */
- (void)checkGPSWithServiceBlock:(ReadServiceBlock)serviceBlock;

/**
 搜星是否成功判断 (强制)
 
 @param serviceBlock 回调block
 */
- (void)forceCheckGPSWithServiceBlock:(ReadServiceBlock)serviceBlock;


/**
 寻找手环， 搜索到手环会双闪

 @param serviceBlock 回调block
 @param isStart    YES:寻找手环  NO：停止
 */
- (void)searchWrist:(ReadServiceBlock)serviceBlock isStart:(BOOL)isStart;

// 重启手环
- (void)restartWrist:(WriteServiceBlock)serviceBlock;

// 关闭手环
- (void)closeWrist:(WriteServiceBlock)serviceBlock;

//读取跑步数据
- (void)readRunModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock;
- (void)cancelRunModelData;

//读取跑步开始时间
- (void)readRunTime:(ReadServiceBlock)serviceBlock level:(GBBluetoothTask_PRIORITY_Level)level;

//清除跑步数据
- (void)cleanRunData:(ReadServiceBlock)serviceBlock;

/////获取服务的uuid和特征的uuid
- (NSString *)getErrorUUIDs;

@end
