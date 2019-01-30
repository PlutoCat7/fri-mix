//
//  BluetoothManager.h
//  GB_Football
//
//  Created by wsw on 16/8/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iBeaconInfo.h"

typedef void (^BluetoothScanBeaconHandler)(iBeaconInfo *foundBeacons, BOOL isStop, NSError *error);
typedef void (^BluetoothConnectHandler)(NSError *error);

@interface BluetoothManager : NSObject

@property (nonatomic, assign, getter=isOpenBluetooth) BOOL openBluetooth;

// 单例模式
+ (BluetoothManager *)sharedBluetoothManager;

- (void)startScanningWithBeaconHandler:(BluetoothScanBeaconHandler)scanHandle;

- (void)resetBluetoothManager;

//断开连接
- (void)disconnectBeacon;

#pragma mark -  事件处理
//电量、设备版本、日期获取
- (void)readBatteryVersionDateWithMac:(NSString *)mac handler:(void(^)(NSArray<NSNumber *> *data, NSError *error))handler;

- (void)readVersionWithMac:(NSString *)mac handler:(void(^)(NSString *version, NSError *error))handler;

- (void)readFireVersionAndDeviceVersionWithMac:(NSString *)mac handler:(void(^)(NSString *fireVersion, NSString *deviceVersion, iBeaconVersion deviceVersionType, NSError *error))handler;

//电量
- (void)readBatteryWithMac:(NSString *)mac handler:(void(^)(NSInteger battery, NSError *error))handler;

//读硬件版本
- (void)readDeviceVerWithMac:(NSString *)mac handler:(void(^)(NSString *version, iBeaconVersion versionType, NSError *error))handler;

//巡检手环， 搜索到手环会双闪
- (void)searchWristWithMac:(NSString *)mac handler:(void(^)(NSError *error))handler;

// 读取某日运动模式的基本数据记录
- (void)readSportModelDataWithMac:(NSString *)mac month:(NSInteger)month day:(NSInteger)day serviceBlock:(void(^)(id data, id originalData, NSError *error))serviceBlock progressBlock:(void (^)(CGFloat progress))progressBlock;
- (void)cancelSportModelData;

// 固件升级
- (void)enterUpdateMode;
- (void)overUpdateMode;
- (void)updateFirewareWithMac:(NSString *)mac deviceVersionType:(iBeaconVersion)deviceVersionType filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(CGFloat progress))progressBlock;
- (void)cancelUpdateFireware;

/**
 切换手环模式

 @param mac 手环mac
 @param index 切换类型   0：普通模式  1：运动模式
 @param complete 完成回调
 */
- (void)switchModelWithMac:(NSString *)mac index:(NSInteger)index complete:(void(^)(NSError *error))complete;

// 星历写入
- (void)searchStarWithMac:(NSString *)mac filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(CGFloat progress))progressBlock;
- (void)cancelAllSearchStar;
- (void)cancelSearchStarWithMac:(NSString *)mac;


/**
 检测手环搜星状态
 
 @param complete 回调block   0：搜星中   1：搜星成功    2：日常模式，无GPS   3:蓝牙错误  4:正在做其他任务
 */
- (void)checkGPSWithMac:(NSString *)mac complete:(void(^)(NSInteger code))complete;

// 重启手环
- (void)restartDevieWithMac:(NSString *)mac complete:(void(^)(NSError *error))complete;

@end
