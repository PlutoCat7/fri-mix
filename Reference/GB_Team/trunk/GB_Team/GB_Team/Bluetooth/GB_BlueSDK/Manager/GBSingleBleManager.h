//
//  GBSingleBleManager.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/16.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "GBBeanManager.h"
#import "GBBleConstants.h"
#import "GBBleEnums.h"

//设备活动代理
@protocol GBDeviceActiveDelegate <NSObject>

@optional
//现在只支持双击、三击
- (void)deviceActiveClick:(NSString *)mac clickCount:(NSInteger)clickCount;

@end

//设备连接执行代理
@protocol GBSingleManagerDelegate <NSObject>

- (void)singleManagerConnected:(NSString *)mac;
- (void)singleManagerDisconnected:(NSString *)mac;

@optional
- (void)singleManagerExecuteQueue:(NSString *)mac;
- (void)singleManagerCompleteQueue:(NSString *)mac;

@end

@interface GBSingleBleManager : NSObject

//单例模式
+ (GBSingleBleManager *)sharedSingleBleManager;

//连接状态
@property (nonatomic, assign, readonly) GBConnectState connectState;
//搜星状态
@property (nonatomic, assign, readonly) BleGpsState gpsState;

//连接的mac地址
@property (nonatomic, copy) NSString *macAddr;
//设备活动代理
@property (nonatomic, weak) id<GBDeviceActiveDelegate> delegate;
//设备连接执行代理
@property (nonatomic, weak) id<GBSingleManagerDelegate> singleDelegate;

//使用前必须调用，之后可以加配置,现在没有用到
- (void)startWithDefault;

//开始扫描设备  默认30s
- (void)startScanningWithBeaconHandler:(BleScanBeaconHandler)scanBeaconHandle;
- (void)startScanningWithBeaconHandler:(BleScanBeaconHandler)scanBeaconHandle timeInterval:(NSTimeInterval)timeInterval;
//停止搜索
- (void)stopScanning;

//连接蓝牙, 需先设置iBeaconMac的值
- (void)connectBeaconWithMac:(NSString *)mac connectHandle:(BleConnectHandler)connectHandle;
//重连蓝牙，在其他意外情况断开(不是使用)的时候可以通过这个帮忙连接
- (void)reconnectBeacon:(BleConnectHandler)connectHandle;

//断开连接，但不清除beacon
- (void)disconnectBeacon:(BleDisconnectHandler)disconnectHandle;
//断开连接，并把所有的数据清除
- (void)disconnectAndClearBeacon:(BleDisconnectHandler)disconnectHandle;

#pragma mark -  手环基本信息
//读电量
- (void)readBatteryWithCompletionHandler:(void(^)(NSInteger battery, NSError *error))completionHandler;
//读日期
- (void)readDateWithCompletionHandler:(void(^)(NSDate *date, NSError *error))completionHandler;
//读固件版本
- (void)readFirmwareVersionWithCompletionHandler:(void(^)(NSString *version, NSError *error))completionHandler;
//读硬件版本
- (void)readDeviceVersionWithCompletionHandler:(void(^)(NSString *version, NSError *error))completionHandler;

//读取手环固定信息
- (void)readFixedInfoWithCompletionHandler:(void(^)(NSArray *result, NSError *error))completionHandler;

//读取手环可变信息
- (void)readVariableInfoWithCompletionHandler:(void(^)(NSArray *result, NSError *error))completionHandler;

#pragma mark - 手环交互
//检查模式
- (void)checkModelWithCompletionHandler:(void(^)(BleModel model, NSError *error))completionHandler;
//切换模式
- (void)switchModelWithModel:(BleModel)model completionHandler:(void(^)(NSError *error))completionHandler;

//检查gps状态
- (void)checkGpsStateWithCompletionHandler:(void(^)(BleGpsState state, NSError *error))completionHandler;

//找手环
- (void)findDeviceWithState:(BleFindState)findState completionHandler:(void(^)(NSError *error))completionHandler;

// 读取多天普通模式的基本数据记录
- (void)readCommonDataWithDateList:(NSArray<NSDate *> *)dateList completionHandler:(void(^)(id data, NSError *error))completionHandler;
- (void)cancelReadCommonDataWithDateList:(NSArray<NSDate *> *)dateList;

// 读取比赛数据
- (void)readMatchDataWithProgressBlock:(void (^)(NSProgress *progress))progressBlock completionHandler:(void(^)(id data, id originalData, NSError *error))completionHandler;
- (void)cancelReadMatchData;

// 固件升级
- (void)updateFirewareWithFilePath:(NSURL *)filePath progressBlock:(void (^)(NSProgress *progress))progressBlock completionHandler:(void(^)(NSError *error))completionHandler;
- (void)cancelUpdateFireware;

// 星历写入
- (void)searchStarWithFilePath:(NSURL *)filePath progressBlock:(void (^)(NSProgress * progress))progressBlock completionHandler:(void(^)(NSError *error))completionHandler;
- (void)cancelSearchStar;

/**
 重启手环
 */
- (void)restartDevieWithCompletionHandler:(void(^)(NSError *error))completionHandler;

//网络接口api
/**
 创建比赛

 @param locA 球场坐标  json格式 比如:{"lon":112.43597981770833,"lat":34.679385579427084}
 @param locB 球场坐标
 @param locC 球场坐标
 @param locD 球场坐标
 @param matchData 比赛数据 可通过readSportModelData接口读取
 @param height 球员身高
 @param weight 球员体重
 */
- (void)createMatchWithlocA:(NSString *)locA locB:(NSString *)locB locC:(NSString *)locC locD:(NSString *)locD matchData:(NSData *)matchData height:(CGFloat)height weight:(CGFloat)weight completionHandler:(void(^)(NSError *error))completionHandler;

@end

FOUNDATION_EXPORT NSString * const GBDeviceDidConnectedNotification;
FOUNDATION_EXPORT NSString * const GBDeviceDidDisConnectedNotification;
