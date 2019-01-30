//
//  GBBluetoothCenterManager.h
//  GB_BlueSDK
//
//  Created by 王时温 on 2017/3/30.
//  Copyright © 2017年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "GBBeacon.h"

@protocol GBBluetoothCenterManagerDelegate <NSObject>

@optional
- (void)centralManagerDidUpdateState:(CBManagerState)state;

- (void)didDiscoverBeacon:(GBBeacon *)beacon;

- (void)didConnectBeacon:(GBBeacon *)beacon;

- (void)didFailToConnectBeacon:(GBBeacon *)beacon error:(NSError *)error;

- (void)didDisConnectBeacon:(GBBeacon *)beacon error:(NSError *)error;

- (void)didStartScan;
- (void)didFinishScan;

@end

@interface GBBluetoothCenterManager : NSObject

/**
 手机蓝牙是否打开
 */
@property (nonatomic, assign, getter=isOpenBluetooth, readonly) BOOL openBluetooth;

+ (instancetype)sharedCenterManager;

- (void)initConfig;

- (void)addDelegate:(id<GBBluetoothCenterManagerDelegate>)delegate;

- (void)removeDelegate:(id<GBBluetoothCenterManagerDelegate>)delegate;

- (GBBeacon *)beaconWithMac:(NSString *)mac;

- (void)startScanWithTimeInterval:(NSTimeInterval)timeInterval;

- (void)stopScan;

- (void)connectWithBeacon:(GBBeacon *)beacon;

- (void)disConnectWithBeacon:(GBBeacon *)beacon;

@end
