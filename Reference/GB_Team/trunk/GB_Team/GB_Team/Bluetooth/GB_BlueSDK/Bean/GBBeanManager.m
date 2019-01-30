//
//  GBBeanManager.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/15.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBBeanManager.h"
#import "GBBleConstants.h"
#import "GBBleEnums.h"
#import "GBBleUtility.h"
#import "GBBluetoothCenterManager.h"

#import  <CoreBluetooth/CoreBluetooth.h>

@interface GBBeanManager() <GBBluetoothCenterManagerDelegate>

@property (nonatomic, assign, readwrite) GBConnectState connectState;
@property (nonatomic, strong) GBBluetoothCenterManager *bluetoothCenterManager;
//要连接的设备信息
@property (nonatomic, strong) GBBeacon *iBeaconObj;
@property (nonatomic, copy) NSString *iBeaconMac;

@property (nonatomic, copy) BleScanBeaconHandler bleScanBeaconHandler;     //扫描设备block
@property (nonatomic, copy) BleConnectHandler bleConnectHandler;           //连接设备block
@property (nonatomic, copy) BleDisconnectHandler bleDisconnectHandler;     //断开连接block

@property (nonatomic, strong) NSTimer *connectOverTimer;
@property (nonatomic, assign) BOOL needReConnect;    //在断开连接时，是否需要重连

@end

@implementation GBBeanManager

- (void)dealloc
{
    [_bluetoothCenterManager removeDelegate:self];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _bluetoothCenterManager = [GBBluetoothCenterManager sharedCenterManager];
        [_bluetoothCenterManager addDelegate:self];
    }
    return self;
}

#pragma mark - Public

- (void)connectBeaconWithMac:(NSString *)mac connectHandle:(BleConnectHandler)connectHandle {
    
    self.iBeaconMac = mac;
    self.iBeaconObj = [self.bluetoothCenterManager beaconWithMac:mac];
    
    if (!self.bluetoothCenterManager.isOpenBluetooth) {
        self.connectState = GBConnectState_UnConnect;
        BLE_BLOCK_EXEC(connectHandle, nil, [[NSError alloc] initWithDomain:@"Bluetooth powered off." code:BeanErrors_BluetoothNotOn userInfo:nil]);
        return;
    }
    if (![GBBleUtility stringIsMacAddress:mac]) {
        self.connectState = GBConnectState_UnConnect;
        BLE_BLOCK_EXEC(connectHandle, nil, [[NSError alloc] initWithDomain:@"illegal error:mac format error" code:BeanErrors_InvalidArgument userInfo:nil]);
        return;
    }
    if (self.iBeaconObj.peripheral.state == CBPeripheralStateConnected) {
        self.connectState = GBConnectState_Connected;
        BLE_BLOCK_EXEC(connectHandle, self.iBeaconObj, nil);
        return;
    }
    
    // 设置连接状态
    self.connectState = GBConnectState_Connecting;
    self.bleConnectHandler = connectHandle;
    if (self.iBeaconObj != nil && [self.iBeaconMac isEqualToString:mac]) {//重新连接
        [self connectBeacon];
    } else {
        //重新扫描,如果之前在扫描的情况需要先停止扫描
        //[self scanOverTime];
        
        self.iBeaconObj = nil;
        __weak typeof(self) weakSelf  = self;
        [self startScanningWithBeaconHandler:^(GBBeacon *foundBeacons, BOOL isStop, NSError *error){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (error) {
                strongSelf.connectState = GBConnectState_UnConnect;
                BLE_BLOCK_EXEC_SetNil(strongSelf.bleConnectHandler, nil, error);
            } else {
                if ([[foundBeacons.address lowercaseString] isEqualToString:[mac lowercaseString]]) {
                    strongSelf.iBeaconObj = foundBeacons;
                    [strongSelf connectBeacon];
                }
            }
        }];
    }
}

- (void)reconnectBeacon:(BleConnectHandler)connectHandle {

    [self connectBeaconWithMac:self.iBeaconMac connectHandle:connectHandle];
}

- (void)disconnectBeacon:(BleDisconnectHandler)disconnectHandle {
    
    if (self.connectState == GBConnectState_UnConnect ||
        self.connectState == GBConnectState_None) {
        [self disconnectBeaconDateClean];
        BLE_BLOCK_EXEC(disconnectHandle, nil);
        return;
    }
    
    __weak typeof(self) weakSelf  = self;
    self.bleDisconnectHandler = ^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf disconnectBeaconDateClean];
        
        BLE_BLOCK_EXEC(disconnectHandle, error);
    };
    self.needReConnect = NO;
    [self.bluetoothCenterManager disConnectWithBeacon:self.iBeaconObj];
}

- (void)disconnectAndClearBeacon:(BleDisconnectHandler)disconnectHandle {
    
    if (self.connectState == GBConnectState_UnConnect ||
        self.connectState == GBConnectState_None) {
        [self disconnectBeaconDateReset];
        
        BLE_BLOCK_EXEC(disconnectHandle, nil);
        return;
    }
    
    __weak typeof(self) weakSelf  = self;
    self.bleDisconnectHandler = ^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf disconnectBeaconDateReset];
        
        BLE_BLOCK_EXEC(disconnectHandle, error);
    };
    self.needReConnect = NO;
    [self.bluetoothCenterManager disConnectWithBeacon:self.iBeaconObj];
}

- (BOOL)isConnectedBean {
    
    return (self.iBeaconObj && self.iBeaconObj.peripheral && self.connectState == GBConnectState_Connected);
}

// 只有在蓝牙指令操作的时候调用
- (void)checkBeaconStateForOpt:(void(^)(NSError *error))block {
    
    if (![self isConnectedBean]) { //先连接手环
        [self reconnectBeacon:^(GBBeacon *beacon, NSError *error) {
            BLE_BLOCK_EXEC(block, error);
        }];
        return;
    }
    BLE_BLOCK_EXEC(block, nil);
}

#pragma mark - Private

- (void)startScanningWithBeaconHandler:(BleScanBeaconHandler)bleScanBeaconHandler {
    
    self.bleScanBeaconHandler = bleScanBeaconHandler;
    [self.bluetoothCenterManager startScanWithTimeInterval:kConnectOverTimeInterval];
}

- (void)connectBeacon {
    
    [self.bluetoothCenterManager connectWithBeacon:self.iBeaconObj];
    
    [self.connectOverTimer invalidate];
    self.connectOverTimer = [NSTimer scheduledTimerWithTimeInterval:kConnectOverTimeInterval target:self selector:@selector(connectOverTime) userInfo:nil repeats:NO];
}

- (void)connectOverTime {
    
    BLE_BLOCK_EXEC_SetNil(self.bleConnectHandler, nil, [[NSError alloc] initWithDomain:@"Find not bluetooth device." code:BeanErrors_DeviceNotEligible userInfo:nil]);
}

// 还原到没有连接的状态
- (void)disconnectBeaconDateClean {
    
    self.needReConnect = NO;
    self.connectState = GBConnectState_UnConnect;
    [self.connectOverTimer invalidate];
    
    if (self.beanManagerDelegate && [self.beanManagerDelegate respondsToSelector:@selector(beanDisconnectComplete:)]) {
        [self.beanManagerDelegate beanDisconnectComplete:self.iBeaconObj];
    }
}

// 数据全部重置
- (void)disconnectBeaconDateReset {
    
    [self disconnectBeaconDateClean];
    self.iBeaconMac = @"";
    self.iBeaconObj = nil;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBManagerState)state {
    
    switch (state) {
        case CBCentralManagerStatePoweredOff:
            if (self.iBeaconObj) {
                [self disconnectBeaconDateClean];
            }
            break;
        case CBCentralManagerStatePoweredOn:
            break;
        case CBCentralManagerStateResetting:
            GBBleLog(@"Resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            GBBleLog(@"Unauthorized");
            break;
        case CBCentralManagerStateUnsupported:
            GBBleLog(@"Unsupported");
            break;
        case CBCentralManagerStateUnknown:
            break;
        default:
            GBBleLog(@"Unknown");
            break;
    }
}

- (void)didDiscoverBeacon:(GBBeacon *)beacon {
    
    BLE_BLOCK_EXEC(self.bleScanBeaconHandler, beacon, NO, nil);
}

- (void)didConnectBeacon:(GBBeacon *)beacon {
    
    [self.connectOverTimer invalidate];
    // 只要连接成功，如果自动断开就要做重连
    self.needReConnect = YES;
    self.connectState = GBConnectState_Connected;
    
    if (self.beanManagerDelegate && [self.beanManagerDelegate respondsToSelector:@selector(beanConnectComplete:)]) {
        [self.beanManagerDelegate beanConnectComplete:self.iBeaconObj];
    }
    
    BLE_BLOCK_EXEC(self.bleConnectHandler, self.iBeaconObj, nil);
}

- (void)didFailToConnectBeacon:(GBBeacon *)beacon error:(NSError *)error {
    
    [self.connectOverTimer invalidate];
    self.needReConnect = NO;
    self.connectState = GBConnectState_UnConnect;
    
    BLE_BLOCK_EXEC_SetNil(self.bleConnectHandler, nil, [[NSError alloc] initWithDomain:@"Connect bluetooth device fail." code:BeanErrors_DeviceNotEligible userInfo:nil]);
}

- (void)didDisConnectBeacon:(GBBeacon *)beacon error:(NSError *)error {
    
    if (self.needReConnect) {
        GBBleLog(@"reconnect peripheral");
        self.needReConnect = NO;
        [self reconnectBeacon:^(GBBeacon *beacon, NSError *error) {
            if (error) {
                [self disconnectBeaconDateClean];
            }
        }];
    } else {
        BLE_BLOCK_EXEC(self.bleDisconnectHandler, nil);
    }
}

- (void)didFinishScan {
    
    if (!self.iBeaconObj) { //未找到外设
        BLE_BLOCK_EXEC(self.bleScanBeaconHandler, nil, YES, [[NSError alloc] initWithDomain:@"Bluetooth scan over time" code:BeanErrors_ScanTimeOut userInfo:nil]);
    }
}

@end
