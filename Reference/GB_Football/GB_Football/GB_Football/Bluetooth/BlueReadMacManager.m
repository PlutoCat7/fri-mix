//
//  BlueReadMacManager.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "BlueReadMacManager.h"
#import "Profile/BleGlobal.h"

#import "DeviceMacProfile.h"
#import "ProfileManager.h"

@interface BlueReadMacManager ()<
CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) NSArray<CBPeripheral *> *peripheralList;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) CBPeripheral *currentPeripheral;

@property (nonatomic, copy) void(^readMacHandler)(NSArray<NSString *> *macList);

@property (nonatomic, strong) NSTimer *connectOverTimer;
@property (nonatomic, strong) NSMutableArray<NSString *> *macList;

@property (nonatomic, strong) ProfileManager *profileManager;
@property (nonatomic, strong) DeviceMacProfile *macProfile;

@end

@implementation BlueReadMacManager

+ (BlueReadMacManager *)sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[BlueReadMacManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _macProfile = [[DeviceMacProfile alloc] init];
        _profileManager = [[ProfileManager alloc] init];
        [_profileManager addProfile:_macProfile];
    }
    return self;
}

- (void)readMacWithPeripheralList:(NSArray<CBPeripheral *> *)peripheralList manager:(CBCentralManager *)manager handler:(void(^)(NSArray<NSString *> *macList))handler {
    
    self.index = 0;
    self.peripheralList = peripheralList;
    self.readMacHandler = handler;
    self.manager = manager;
    manager.delegate = self;
    
    self.macList = [NSMutableArray arrayWithCapacity:1];
    [self startReadMac];
}

#pragma mark - Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    GBLog(@"centralManagerDidUpdateState");
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            GBLog(@"Powered Off");
            _index = self.peripheralList.count; //读取完成
            [self readMacFinsh:@""];
            break;
        case CBCentralManagerStatePoweredOn:
        {
            
        }
            break;
        case CBCentralManagerStateResetting:
            GBLog(@"Resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            GBLog(@"Unauthorized");
            break;
        case CBCentralManagerStateUnsupported:
            GBLog(@"Unsupported");
            break;
        case CBCentralManagerStateUnknown:
        default:
            GBLog(@"Unknown");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [self.connectOverTimer invalidate];
    
    self.profileManager.peripheral = self.currentPeripheral;
    [self.macProfile startTask];
    [self.macProfile readDeviceMac:^(id data, NSError *error) {
        
        [self readMacFinsh:data];
    }];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    [self connectOverTime];
}

#pragma mark - Private

- (void)startReadMac {
    
    if (_index>=self.peripheralList.count) {
        return;
    }
    
    self.currentPeripheral = self.peripheralList[_index];
    _index++;
    
    [self.manager connectPeripheral:self.currentPeripheral options:nil];
    
    [self.connectOverTimer invalidate];
    self.connectOverTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(connectOverTime) userInfo:nil repeats:NO];
}

- (void)connectOverTime
{
    [self readMacFinsh:@""];
}

- (void)readMacFinsh:(NSString *)mac {
    
    [self.connectOverTimer invalidate];
    
    self.currentPeripheral.delegate = nil;
    [self.manager cancelPeripheralConnection:self.currentPeripheral];
    
    [self.macList addObject:mac];
    if (_index>=self.peripheralList.count) {
        [self performBlock:^{
            BLOCK_EXEC(self.readMacHandler, [self.macList copy]);
        } delay:0.5f];
        return;
    }
    
    [self startReadMac];
}

@end
