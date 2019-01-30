//
//  GBBeanManager.h
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GBBeacon.h"

typedef void (^BleScanBeaconHandler)(GBBeacon *foundBeacons, BOOL isStop, NSError *error);
typedef void (^BleConnectHandler)(GBBeacon *beacon, NSError *error);
typedef void (^BleDisconnectHandler)(NSError *error);

typedef NS_ENUM(NSUInteger, GBConnectState) {
    GBConnectState_None,
    GBConnectState_UnConnect,
    GBConnectState_Connecting,
    GBConnectState_Connected,
};

@protocol GBBeanManagerDelegate <NSObject>

- (void)beanConnectComplete:(GBBeacon *)beacon;
- (void)beanDisconnectComplete:(GBBeacon *)beacon;

@end

@interface GBBeanManager : NSObject

//连接状态
@property (nonatomic, assign, readonly) GBConnectState connectState;
//连接代理，主要是处理自动连接和自动断开的情况
@property (nonatomic, weak) id<GBBeanManagerDelegate> beanManagerDelegate;

//连接蓝牙, 需先设置iBeaconMac的值
- (void)connectBeaconWithMac:(NSString *)mac connectHandle:(BleConnectHandler)connectHandle;
//重连蓝牙，在其他意外情况断开(不是使用)的时候可以通过这个帮忙连接
- (void)reconnectBeacon:(BleConnectHandler)connectHandle;

//断开连接，但不清除beacon
- (void)disconnectBeacon:(BleDisconnectHandler)disconnectHandle;
//断开连接，并把所有的数据清除
- (void)disconnectAndClearBeacon:(BleDisconnectHandler)disconnectHandle;

//设备是否已连接蓝牙
- (BOOL)isConnectedBean;

//检测蓝牙状态，只有在蓝牙指令操作的时候调用
- (void)checkBeaconStateForOpt:(void(^)(NSError *error))block;

@end
