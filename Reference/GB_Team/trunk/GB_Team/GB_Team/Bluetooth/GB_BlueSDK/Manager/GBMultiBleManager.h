//
//  GBMultiBleManager.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/16.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBSingleBleManager.h"

@interface GBMultiBleManager : NSObject

//单例模式
+ (GBMultiBleManager *)sharedMultiBleManager;

- (void)resetMultiBleManager;

#pragma mark - Public 处理业务
//读电量
- (void)readBatteryWithMac:(NSString *)mac handler:(void(^)(NSInteger battery, NSError *error))handler;
//读日期
- (void)readDate:(NSString *)mac handler:(void(^)(NSDate *date, NSError *error))handler;
//读固件版本
- (void)readFirmwareVer:(NSString *)mac handler:(void(^)(NSString *version, NSError *error))handler;
//读硬件版本
- (void)readDeviceVer:(NSString *)mac handler:(void(^)(NSString *version, NSError *error))handler;
//检查模式
- (void)checkModel:(NSString *)mac handler:(void(^)(BleModel model, NSError *error))handler;
//切换模式
- (void)switchModel:(NSString *)mac model:(BleModel)model handler:(void(^)(NSError *error))handler;

//检查gps状态
- (void)checkGpsState:(NSString *)mac handler:(void(^)(BleGpsState state, NSError *error))handler;

//找手环
- (void)findDevice:(NSString *)mac findState:(BleFindState)findState handler:(void(^)(NSError *error))handler;

// 读取多天普通模式的基本数据记录
- (void)readMutableCommonModelData:(NSString *)mac date:(NSArray<NSDate *> *)dateArray handler:(void(^)(id data, NSError *error))handler;
- (void)cancelMutableCommonModelData:(NSString *)mac date:(NSArray<NSDate *> *)dateArray;

// 读取某日运动模式的基本数据记录
- (void)readSportModelData:(NSString *)mac handler:(void(^)(id data, id originalData, NSError *error))handler  progressBlock:(void (^)(CGFloat progress))progressBlock;
- (void)cancelSportModelData:(NSString *)mac;

// 固件升级
- (void)updateFireware:(NSString *)mac filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(NSProgress *progress))progressBlock;
- (void)cancelUpdateFireware:(NSString *)mac;

// 星历写入
- (void)searchStar:(NSString *)mac filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(NSProgress * progress))progressBlock;
- (void)cancelSearchStar:(NSString *)mac;

@end
