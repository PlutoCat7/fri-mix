//
//  GBBluetoothCenterManager.m
//  GB_BlueSDK
//
//  Created by 王时温 on 2017/3/30.
//  Copyright © 2017年 GoBrother. All rights reserved.
//

#import "GBBluetoothCenterManager.h"
#import "GBBleConstants.h"

static const NSInteger kDefaultScanTimeInterval = 30;

@interface GBBluetoothCenterManager () <
CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, assign, readwrite) BOOL openBluetooth;

@property (nonatomic, strong) NSMutableArray *delegateList;

@property (nonatomic, strong) NSMutableArray<GBBeacon *> *foundBeaconList;

@end

@implementation GBBluetoothCenterManager

+ (instancetype)sharedCenterManager {
    
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[GBBluetoothCenterManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey, @"zStrapRestoreIdentifier",CBCentralManagerOptionRestoreIdentifierKey,nil];
        
        static CBCentralManager *sManager;
        if (sManager == nil) {
            sManager = [[CBCentralManager alloc] initWithDelegate:self
                                                            queue:nil // 需要次线程？dispatch_queue_create("com.gxd.sdk", DISPATCH_QUEUE_SERIAL)
                                                          options:options];
        }
        _manager = sManager;
        _delegateList = (__bridge_transfer NSMutableArray *)CFArrayCreateMutable(nil, 0, nil);
        _foundBeaconList = [NSMutableArray arrayWithCapacity:1];
#warning 蓝牙启动需要时间  默认为YES
        self.openBluetooth = YES;
    }
    return self;
}

- (void)initConfig {
    
    
}

#pragma mark - Public

- (void)addDelegate:(id<GBBluetoothCenterManagerDelegate>)delegate {
    
    if ([self.delegateList containsObject:delegate]) {
        return;
    }
    [self.delegateList addObject:delegate];
}

- (void)removeDelegate:(id<GBBluetoothCenterManagerDelegate>)delegate {
    
    if (![self.delegateList containsObject:delegate]) {
        return;
    }
    [self.delegateList removeObject:delegate];
}

- (GBBeacon *)beaconWithMac:(NSString *)mac {
    
    if (!mac || mac.length==0) {
        return nil;
    }
    GBBeacon *findBeacon = nil;
    for(GBBeacon *beacon in self.foundBeaconList) {
        if ([beacon.address isEqualToString:mac]) {
            findBeacon = beacon;
            break;
        }
    }
    return findBeacon;
}

- (void)startScanWithTimeInterval:(NSTimeInterval)timeInterval {
    
    // 正在搜索
    if (self.manager.isScanning) {
        return;
    }
    if (timeInterval == 0) {
        timeInterval = kDefaultScanTimeInterval;
    }
    //设置超时时间
    [self performSelector:@selector(stopScan) withObject:nil afterDelay:timeInterval];
    [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:GLOBAL_PACKET_SERVICE_UUID]] options:nil];
}

- (void)stopScan {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.manager stopScan];
    for (id<GBBluetoothCenterManagerDelegate> delegate in self.delegateList) {
        if ([delegate respondsToSelector:@selector(didFinishScan)]) {
            [delegate didFinishScan];
        }
    }
}

- (void)connectWithBeacon:(GBBeacon *)beacon {
    
    CBPeripheral *peripheral = beacon.peripheral;
    if (peripheral) {
        [self.manager connectPeripheral:peripheral options:nil];
    }
}

- (void)disConnectWithBeacon:(GBBeacon *)beacon {
    
    CBPeripheral *peripheral = beacon.peripheral;
    if (peripheral) {
        [self.manager cancelPeripheralConnection:peripheral];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    GBBleLog(@"centralManagerDidUpdateState");
    
    self.openBluetooth = central.state == CBCentralManagerStatePoweredOn ? YES : NO;
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            GBBleLog(@"Powered Off");
            [self stopScan];
            break;
        case CBCentralManagerStatePoweredOn:
            GBBleLog(@"Powered On");
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
    for (id<GBBluetoothCenterManagerDelegate> delegate in self.delegateList) {
        if ([delegate respondsToSelector:@selector(centralManagerDidUpdateState:)]) {
            [delegate centralManagerDidUpdateState:central.state];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    GBBleLog(@"didDiscoverPeripheral");
    
    GBBeacon *beaconObj = [[GBBeacon alloc] initWithPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    if ([beaconObj isValid]) {
        [self.foundBeaconList addObject:beaconObj];
        
        for (id<GBBluetoothCenterManagerDelegate> delegate in self.delegateList) {
            if ([delegate respondsToSelector:@selector(didDiscoverBeacon:)]) {
                [delegate didDiscoverBeacon:beaconObj];
            }
        }
    }
}

//central提供信息，dict包含了应用程序关闭是系统保存的central的信息，用dic去恢复central
//app状态的保存或者恢复，这是第一个被调用的方法当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法同步app状态通过蓝牙系统
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict {
    
    GBBleLog(@"willRestoreState");
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    GBBleLog(@"didConnectPeripheral");
    
    GBBeacon *beacon = [self beaconWithPeripheral:peripheral];
    if (beacon) {
        for (id<GBBluetoothCenterManagerDelegate> delegate in self.delegateList) {
            if ([delegate respondsToSelector:@selector(didConnectBeacon:)]) {
                [delegate didConnectBeacon:beacon];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    GBBleLog(@"didFailToConnectPeripheral");
    
    GBBeacon *beacon = [self beaconWithPeripheral:peripheral];
    if (beacon) {
        for (id<GBBluetoothCenterManagerDelegate> delegate in self.delegateList) {
            if ([delegate respondsToSelector:@selector(didFailToConnectBeacon:error:)]) {
                [delegate didFailToConnectBeacon:beacon error:error];
            }
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    GBBleLog(@"didDisconnectPeripheral");
    
    GBBeacon *beacon = [self beaconWithPeripheral:peripheral];
    if (beacon) {
        for (id<GBBluetoothCenterManagerDelegate> delegate in self.delegateList) {
            if ([delegate respondsToSelector:@selector(didDisConnectBeacon:error:)]) {
                [delegate didDisConnectBeacon:beacon error:error];
            }
        }
    }
}

#pragma mark - Private

- (GBBeacon *)beaconWithPeripheral:(CBPeripheral *)peripheral {
    
    GBBeacon *findBeacon = nil;
    for(GBBeacon *beacon in self.foundBeaconList) {
        if (beacon.peripheral == peripheral) {
            findBeacon = beacon;
            break;
        }
    }
    return findBeacon;
}

@end

