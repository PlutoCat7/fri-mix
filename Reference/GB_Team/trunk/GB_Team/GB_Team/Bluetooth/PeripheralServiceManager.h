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

@property (nonatomic, strong) iBeaconInfo *iBeacon;
@property (nonatomic, assign) NSInteger doingTaskCount;  // 正在进行的任务数

- (void)cleanPeripheralTask;

// 电量读取、版本号获取和时间
- (void)readBatteryVersionDate:(ReadServiceBlock)serviceBlock;

//读取电量
- (void)readBattery:(ReadServiceBlock)serviceBlock;

//读取硬件版本号
- (void)readDeviceVersion:(ReadServiceBlock)serviceBlock;

// 读取手环版本
- (void)readVersion:(ReadServiceBlock)serviceBlock;

// 矫正手环时间
- (void)adjustDate:(WriteServiceBlock)serviceBlock;

//巡检手环， 搜索到手环会双闪
- (void)searchWrist:(ReadServiceBlock)serviceBlock;

// 读取某日运动模式的基本数据记录
- (void)readSportModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock;
- (void)cancelSportModelData;

// 固件升级
- (void)updateFireware:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock isNeedDfu:(BOOL)isNeedDfu manager:(CBCentralManager *)manager;

/**
 切换手环模式
 
 @param index 0：普通模式  1：运动模式
 @param serviceBlock 回调block
 */
- (void)switchModelWithIndx:(NSInteger)index serviceBlock:(WriteServiceBlock)serviceBlock;

// 星历写入
- (void)searchStartProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock;
- (void)cancelSearchStar;

/**
 搜星是否成功判断
 
 @param serviceBlock 回调block  0：搜星中   1：搜星成功    2：日常模式，无GPS   3:蓝牙错误
 */
- (void)checkGPSWithServiceBlock:(ReadServiceBlock)serviceBlock;

// 重启手环
- (void)restartWrist:(WriteServiceBlock)serviceBlock;

@end
