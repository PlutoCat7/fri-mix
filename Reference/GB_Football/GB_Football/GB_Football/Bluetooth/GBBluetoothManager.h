//
//  GBBluetoothManager.h
//  GB_Football
//
//  Created by wsw on 16/8/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iBeaconInfo.h"
#import "BleGlobal.h"

typedef void (^BluetoothScanBeaconHandler)(iBeaconInfo *foundBeacons, BOOL isStop, NSError *error);
typedef void (^BluetoothConnectHandler)(NSError *error);

typedef NS_ENUM(NSUInteger, iBeaconConnectState) {
    iBeaconConnectState_None,
    iBeaconConnectState_UnConnect,
    iBeaconConnectState_Connecting,
    iBeaconConnectState_Connected,
};

@interface GBBluetoothManager : NSObject

/**
 手机蓝牙是否打开
 */
@property (nonatomic, assign, getter=isOpenBluetooth) BOOL openBluetooth;
@property (nonatomic, copy) NSString *iBeaconMac;
@property (nonatomic, strong, readonly) CBCentralManager *manager;

//要连接的设备信息
@property (nonatomic, strong) iBeaconInfo *iBeaconObj;
@property (nonatomic, assign) iBeaconConnectState ibeaconConnectState;

// 单例模式
+ (GBBluetoothManager *)sharedGBBluetoothManager;

//初始化配置信息， 使用前一定要调用该方法
- (void)initConfig;

- (void)resetGBBluetoothManager;

//里皮版升级中
- (void)enterLipiUpdate;

//里皮升级结束
- (void)overLipiUpdate;

//扫描附近蓝牙设备
- (void)startScanningWithBeaconHandler:(BluetoothScanBeaconHandler)beaconHandle;

//停止搜索
- (void)stopScanning;

//连接蓝牙, 需先设置iBeaconMac的值
- (void)connectBeacon:(BluetoothConnectHandler)connecthandle;

//连接蓝牙且有UI显示
- (void)connectBeaconWithUI:(BluetoothConnectHandler)connecthandle;

//断开连接
- (void)disconnectBeacon;

//设备是否已连接蓝牙
- (BOOL)isConnectedBean;

#pragma mark -  事件处理
//电量、设备版本
- (void)readBatteryVersion:(void(^)(NSError *error))handler;

//电量
- (void)readBattery:(void(^)(NSError *error))handler;

//读硬件版本
- (void)readDeviceVer:(void(^)(NSString *version, NSError *error))handler;

// 读取多天普通模式的基本数据记录
- (void)readMutableCommonModelData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(void(^)(id data, NSError *error))handler;
- (void)cancelMutableCommonModelData;

// 读取多天运动模式下步数数据记录
- (void)readMutableSportStepData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(void(^)(id data, NSError *error))handler;
- (void)cancelMutableSportStepData;

// 读取某日运动模式的基本数据记录
- (void)readSportModelData:(NSInteger)month day:(NSInteger)day serviceBlock:(void(^)(id data, id originalData, NSError *error))serviceBlock  progressBlock:(void (^)(NSProgress *progress))progressBlock;
- (void)cancelSportModelData;

// 固件升级
- (void)updateFireware:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(NSProgress *progress))progressBlock;

// 星历写入
- (void)searchStar:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(CGFloat progress))progressBlock;
- (void)cancelSearchStar;

/**
 检测手环状态
 
 @param complete 回调block
 */
- (void)checkModelWithComplete:(void(^)(BlueSwitchModel model))complete;
/**
 切换手环模式
 
 @param switchModel 将要切换的模式
 @param complete 回调block
 */
- (void)switchModel:(BlueSwitchModel)switchModel complete:(void(^)(NSError *error))complete;

/**
 检测手环搜星状态
 
 @param complete 回调block   0：搜星中   1：搜星成功    2：日常模式，无GPS   3:蓝牙错误
 */
- (void)checkGPSWithComplete:(void(^)(NSInteger code))complete;

/**
 寻找手环， 搜索到手环会双闪

 */
- (void)searchWristWithComplete:(void(^)(NSError *error))complete;

/**
 停止寻找手环

 */
- (void)stopSearchWristWithComplete:(void(^)(NSError *error))complete;

// 重启手环
- (void)restartDevieWithComplete:(void(^)(NSError *error))complete;

// 关闭手环
- (void)closeDeviceWithComplete:(void(^)(NSError *error))complete;

//读取跑步数据
- (void)readRunModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock;
- (void)cancelRunModelData;

//读取跑步开始时间
- (void)readRunTime:(ReadServiceBlock)serviceBlock level:(GBBluetoothTask_PRIORITY_Level)level;

//清除跑步数据
- (void)cleanRunData:(ReadServiceBlock)serviceBlock;

@end
