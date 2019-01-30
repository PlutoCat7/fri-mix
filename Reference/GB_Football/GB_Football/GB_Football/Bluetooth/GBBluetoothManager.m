//
//  GBBluetoothManager.m
//  GB_Football
//
//  Created by wsw on 16/8/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBluetoothManager.h"
#import  <CoreBluetooth/CoreBluetooth.h>
#import "PeripheralServiceManager.h"
#import "GBCircleHub.h"
#import "BluUtility.h"
#import "GBRingToast.h"

#import "BlueReadMacManager.h"

static const NSTimeInterval kConnectOverTimeInterval = 10;
static const NSTimeInterval kScanOverTimeInterval = 30;

@interface GBBluetoothManager () <
CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, assign) GBBluetoothManagerState managerState;

@property (nonatomic, strong) PeripheralServiceManager *peripheralServiceManager;
@property (nonatomic, copy) BluetoothScanBeaconHandler beaconHandle;     //扫描设备block
@property (nonatomic, strong) NSMutableArray *didConnectHandleList;    //设备连接

@property (nonatomic, strong) NSTimer *connectOverTimer;
@property (nonatomic, strong) NSTimer *scanOverTimer;
@property (nonatomic, strong) NSTimer *checkiBeaconStatusTimer;
@property (nonatomic, assign) BOOL needReConnect;    //在断开连接时，是否需要重连

@end

@implementation GBBluetoothManager

+ (GBBluetoothManager *)sharedGBBluetoothManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[GBBluetoothManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initConfig {
    
    if (!_manager) {
        //        CBCentralManagerOptionShowPowerAlertKey
        //        布尔值，表示的是在central manager初始化时，如果当前蓝牙没打开，是否弹出alert框。
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey, @"zStrapRestoreIdentifier",CBCentralManagerOptionRestoreIdentifierKey,nil];
        
        _manager = [[CBCentralManager alloc] initWithDelegate:self
                                                        queue:nil // 需要次线程？dispatch_queue_create("com.GB_Football", DISPATCH_QUEUE_SERIAL)
                                                      options:options];
        _managerState = GBBluetoothManagerState_Initing;
        _didConnectHandleList = [NSMutableArray arrayWithCapacity:1];
    }
}

#pragma mark - Public

- (void)resetGBBluetoothManager {
    
    [self disconnectBeacon];
    self.ibeaconConnectState = iBeaconConnectState_None;
    self.iBeaconMac = @"";
    self.iBeaconObj = nil;
    [self connectComplete:nil];
    [self.peripheralServiceManager cleanPeripheralTask];
    [self.connectOverTimer invalidate];
    [self.scanOverTimer invalidate];
    self.needReConnect = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)enterLipiUpdate {
    
    self.needReConnect = NO;
    self.ibeaconConnectState = iBeaconConnectState_UnConnect;
    self.iBeaconObj = nil;
    [self.peripheralServiceManager cleanPeripheralTask];
    [self cancelCheckiBeaconStatusRepeat];
}

- (void)overLipiUpdate {
    
    self.manager.delegate = self;
}

- (void)startScanningWithBeaconHandler:(BluetoothScanBeaconHandler)beaconHandle {
    
    [self startScanningWithBeaconHandler:beaconHandle timeInterval:kScanOverTimeInterval];
}

- (void)startScanningWithBeaconHandler:(BluetoothScanBeaconHandler)beaconHandle timeInterval:(NSTimeInterval)timeInterval {
    
    if (!self.isOpenBluetooth) {
        BLOCK_EXEC_SetNil(beaconHandle, nil, YES, [[NSError alloc] initWithDomain:LS(@"bluetooth.tip.turn.on") code:BeanErrors_BluetoothNotOn userInfo:nil]);
        return;
    }
    
    void(^scanBlock)() = ^{
        
        [self.scanOverTimer invalidate];
        self.scanOverTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(scanOverTime) userInfo:nil repeats:NO];
        self.beaconHandle = beaconHandle;
        self.manager.delegate = self;
        [self.manager scanForPeripheralsWithServices:nil options:nil];

    };
    
    if (self.ibeaconConnectState == iBeaconConnectState_UnConnect ||
        self.ibeaconConnectState == iBeaconConnectState_None) {
        //获取已被当前手机连接的手环
        NSArray<CBPeripheral *> *tmpList = [self.manager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:GLOBAL_PACKET_SERVICE_UUID]]];
        if (tmpList.count>0) {
            [[BlueReadMacManager sharedManager] readMacWithPeripheralList:tmpList manager:self.manager handler:^(NSArray<NSString *> *macList) {
                
                if (tmpList.count == macList.count) {
                    for (NSInteger i=0; i<macList.count; i++) {
                        NSString *mac = macList[i];
                        if (![NSString stringIsNullOrEmpty:mac]) {
                            iBeaconInfo *info = [[iBeaconInfo alloc] initWithPeripheral:tmpList[i] mac:mac];
                            
                            BLOCK_EXEC(beaconHandle, info, NO, nil);
                        }
                    }
                }
                //继续扫描
                scanBlock();
            }];
            return;
        }
    }
    //
    scanBlock();
}

- (void)stopScanning {
    
    [self.manager stopScan];
    [self.scanOverTimer invalidate];
}

- (void)connectBeacon:(BluetoothConnectHandler)connecthandle {
    
    if (!self.isOpenBluetooth) {
        self.ibeaconConnectState = iBeaconConnectState_UnConnect;
        BLOCK_EXEC(connecthandle, [[NSError alloc] initWithDomain:LS(@"bluetooth.tip.turn.on") code:BeanErrors_BluetoothNotOn userInfo:nil]);
        return;
    }
    if ([NSString stringIsNullOrEmpty:self.iBeaconMac]) {
        self.ibeaconConnectState = iBeaconConnectState_UnConnect;
        BLOCK_EXEC(connecthandle, [[NSError alloc] initWithDomain:LS(@"bluetooth.illegal.device") code:BeanErrors_InvalidArgument userInfo:nil]);
        return;
    }
    if (self.iBeaconObj.peripheral.state == CBPeripheralStateConnected) {
        self.ibeaconConnectState = iBeaconConnectState_Connected;
        BLOCK_EXEC(connecthandle, nil);
        return;
    }
    
    [self.didConnectHandleList addObject:connecthandle];
    
    void(^connectBlock)() = ^{
        [self.manager connectPeripheral:self.iBeaconObj.peripheral options:nil];
        
        [self.connectOverTimer invalidate];
        self.connectOverTimer = [NSTimer scheduledTimerWithTimeInterval:kConnectOverTimeInterval target:self selector:@selector(connectOverTime) userInfo:nil repeats:NO];
    };
    void(^scanBlock)()= ^{
        //扫描外设
        [self startScanningWithBeaconHandler:^(iBeaconInfo *foundBeacons, BOOL isStop, NSError *error){
            if (error) {
                self.ibeaconConnectState = iBeaconConnectState_UnConnect;
                for (BluetoothConnectHandler didConnectHandle in self.didConnectHandleList) {
                    BLOCK_EXEC(didConnectHandle, error);
                }
                [self.didConnectHandleList removeAllObjects];
            }else {
                if ([[foundBeacons.address lowercaseString] isEqualToString:[self.iBeaconMac lowercaseString]]) {
                    
                    [self stopScanning];
                    self.iBeaconObj = foundBeacons;
                    
                    connectBlock();
                }
            }
        } timeInterval:kConnectOverTimeInterval];
    };
    
    if (self.iBeaconObj) { //重新连接
        connectBlock();
    }else {  //重新扫描
        
        //第一种：根据identifiers获取外设
        NSString *identifiers = [BluUtility getUUIDStringWithKey:self.iBeaconMac];
        if (identifiers) {
            NSArray<CBPeripheral *> *localPeripheral = [self.manager retrievePeripheralsWithIdentifiers:@[[[NSUUID UUID] initWithUUIDString:identifiers]]];
            if (localPeripheral.count>0) {
                
                self.iBeaconObj = [[iBeaconInfo alloc] initWithPeripheral:localPeripheral.firstObject mac:self.iBeaconMac];
                
                connectBlock();
                return;
            }
        }
        
        //第二种：获取已连接的外设
        NSArray<CBPeripheral *> *tmpList = [self.manager retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:GLOBAL_PACKET_SERVICE_UUID]]];
        if (tmpList.count>0) {
            [[BlueReadMacManager sharedManager] readMacWithPeripheralList:tmpList manager:self.manager handler:^(NSArray<NSString *> *macList) {
                
                self.manager.delegate = self;
                
                NSInteger index = -1;
                for (NSString *findMac in macList) {
                    if ([findMac isEqualToString:self.iBeaconMac]) {
                        index = [macList indexOfObject:findMac];
                        break;
                    }
                }
                if (index != -1 && index<tmpList.count) {
                    self.iBeaconObj = [[iBeaconInfo alloc] initWithPeripheral:tmpList[index] mac:self.iBeaconMac];
                    
                    connectBlock();
                }else {
                    scanBlock();
                }
            }];
            return;
        }
        
        //第三种：扫描
        scanBlock();
    }
}

- (void)connectBeaconWithUI:(BluetoothConnectHandler)connecthandle {
    
    if (self.ibeaconConnectState == iBeaconConnectState_Connecting) {
        BLOCK_EXEC(connecthandle, [[NSError alloc] initWithDomain:LS(@"正在连接中...") code:BeanErrors_NeedConnect userInfo:nil]);
        return;
    }
    
    [GBRingToast showWithTip:LS(@"menu.toast.connecting")];
    self.ibeaconConnectState = iBeaconConnectState_Connecting;
    
    [self performBlock:^{
        [self connectBeacon:^(NSError *error) {
            [GBRingToast hide];
            if (error) {
                [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
            }
            BLOCK_EXEC(connecthandle, error);
        }];
    } delay:(self.managerState == GBBluetoothManagerState_Initing)?1.0f:0];
}

- (void)disconnectBeacon {
    
    [self stopScanning];
    self.needReConnect = NO;
    self.ibeaconConnectState = iBeaconConnectState_UnConnect;
    if (self.iBeaconObj.peripheral) {
        [self.manager cancelPeripheralConnection:self.iBeaconObj.peripheral];
    }
    
    [self.peripheralServiceManager cleanPeripheralTask];
    [GBRingToast hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CancelConenctSuccess object:nil];
}

- (BOOL)isConnectedBean {
    
    return (self.iBeaconObj && self.iBeaconObj.peripheral && self.ibeaconConnectState == iBeaconConnectState_Connected);
}

#pragma mark  事件处理

- (void)readConnectInfo:(void (^)(NSError *))handler {
    
    [self.peripheralServiceManager readBatteryVersion:^(id data, NSError *error) {
        if (!error) {
            
            NSArray *resultArray = data;
            void(^block)() = ^(){
                self.iBeaconObj.battery = [resultArray[0] integerValue];
                self.iBeaconObj.firewareVersion = resultArray[1];
                
#warning 读取硬件版本号,如果失败不做处理，一代手环固件2.39-2.52返回无效指令，都会出错，其他2.39返回的是传入值加上0x80
                [self.peripheralServiceManager readDeviceVersion:^(id data, id sourceData, NSError *error) {
                    NSError *backError = nil;
                    // 如果是无效指令也是走一代逻辑
                    if (!error || error.code == GattErrors_InvalidCommond) {
                        self.iBeaconObj.deviceVersion = data;
                    } else {
                        // 如果错误，按错误逻辑处理
                        backError = error;
                    }
                    self.iBeaconObj.t_goal_Version = [sourceData integerValue];
                    
                    //第一次读取手环状态
                    [self.peripheralServiceManager forceCheckGPSWithServiceBlock:^(id data, NSError *error) {
                        if (!error) {
                            [self.iBeaconObj setStatus:[data integerValue]];
                        }
                    }];
                    
                    // 获取硬件版本失败不做处理
                    BLOCK_EXEC(handler, backError);
                }];
            };
            
            if ([resultArray[0] integerValue] == 0) { //重启第一次读取电量为0
                [self readConnectInfo:handler];
            }else {
                BLOCK_EXEC(block, error);
            }
            
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Bluetooth_ReadConnectInfoTimeOut object:[self.peripheralServiceManager getErrorUUIDs]];
            
            BLOCK_EXEC(handler, error);
        }
    }];
    
}

- (void)readBatteryVersion:(void(^)(NSError *error))handler {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, error);
        }else {
            [self.peripheralServiceManager readBatteryVersion:^(id data, NSError *error) {
                if (!error) {
                    NSArray *resultArray = data;
                    self.iBeaconObj.battery = [resultArray[0] integerValue];
                    self.iBeaconObj.firewareVersion = resultArray[1];
                }
                BLOCK_EXEC(handler, error);
            }];
        }
    }];
}

- (void)readBattery:(void(^)(NSError *error))handler {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, error);
        }else {
            [self.peripheralServiceManager readBattery:^(id data, NSError *error) {
                if (!error) {
                    NSArray *list = data;
                    if (list.count == 2) {
                        self.iBeaconObj.battery = [list.firstObject integerValue];
                        self.iBeaconObj.chargeType = [list.lastObject integerValue]==0?iBeaconCharge_Common:iBeaconCharge_Charging;
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ReadBatterySuccess object:nil];
                }
                BLOCK_EXEC(handler, error);
            }];
        }
    }];
}

- (void)readDeviceVer:(void(^)(NSString *version, NSError *error))handler {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [self.peripheralServiceManager readDeviceVersion:^(id data, id sourceData, NSError *error) {
                if (!error) {
                    self.iBeaconObj.deviceVersion = data;
                }
                self.iBeaconObj.t_goal_Version = [sourceData integerValue];
                BLOCK_EXEC(handler, data, error);
            }];
        }
    }];
}

- (void)readMutableCommonModelData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(void(^)(id data, NSError *error))handler {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [self.peripheralServiceManager readMutableCommonModelData:date level:level serviceBlock:^(id data, NSError *error) {
                if (data) {
                    BLOCK_EXEC(handler, data, nil);
                }else {
                    BLOCK_EXEC(handler, nil, error);
                }
            }];
        }
        
    }];
}

- (void)cancelMutableCommonModelData {
    
    [self.peripheralServiceManager cancelMutableCommonModelData];
}

- (void)readMutableSportStepData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(void(^)(id data, NSError *error))handler {
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [self.peripheralServiceManager readMutableSportStepData:date level:level serviceBlock:^(id data, NSError *error) {
                if (data) {
                    BLOCK_EXEC(handler, data, nil);
                }else {
                    BLOCK_EXEC(handler, nil, error);
                }
            }];
        }
        
    }];
}

- (void)cancelMutableSportStepData {
    [self.peripheralServiceManager cancelMutableSportStepData];
}

- (void)readSportModelData:(NSInteger)month day:(NSInteger)day serviceBlock:(void(^)(id data, id originalData, NSError *error))serviceBlock  progressBlock:(void (^)(NSProgress *progress))progressBlock {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(serviceBlock, nil, nil, error);
        }else {
            [self.peripheralServiceManager readSportModelData:month day:day progressBlock:^(NSInteger total, NSInteger index) {
                
                NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
                progress.completedUnitCount = index;
                BLOCK_EXEC(progressBlock, progress);
            } serviceBlock:serviceBlock];
        }
    }];
}

- (void)cancelSportModelData {
    
    [self.peripheralServiceManager cancelSportModelData];
}

// 固件升级
- (void)updateFireware:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(NSProgress *progress))progressBlock {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, error);
        }else {
            [self.peripheralServiceManager updateFireware:filePath serviceBlock:complete progressBlock:^(NSInteger total, NSInteger index) {
                NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
                progress.completedUnitCount = index;
                BLOCK_EXEC(progressBlock, progress);
            }];
        }
    }];
    
}

- (void)searchStar:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(CGFloat progress))progressBlock {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, error);
        }else {
            [self.peripheralServiceManager searchStartProfile:filePath serviceBlock:complete progressBlock:^(NSInteger total, NSInteger index) {
                CGFloat progress = (index*1.0)/total;
                BLOCK_EXEC(progressBlock, progress);
            }];
        }
    }];
}

- (void)cancelSearchStar {
    
    [self.peripheralServiceManager cancelSearchStar];
}

- (void)checkModelWithComplete:(void(^)(BlueSwitchModel model))complete {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, BlueSwitchModel_Unknow);
        }else {
            [self.peripheralServiceManager checkModelWithServiceBlock:^(id data, NSError *error) {
                if (error) {
                    BLOCK_EXEC(complete, BlueSwitchModel_Unknow);
                }else {
                    BLOCK_EXEC(complete, [data integerValue]);
                }
            }];
        }
    }];
}

- (void)switchModel:(BlueSwitchModel)switchModel complete:(void(^)(NSError *error))complete {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, error);
        }else {
            [self.peripheralServiceManager switchModelWithIndx:switchModel serviceBlock:^(NSError *error) {
                BLOCK_EXEC(complete, error);
                //立即查询手环状态
                [self checkGPSWithComplete:^(NSInteger code) {
                    [self.iBeaconObj setStatus:code];
                }];
            }];
        }
    }];
}

- (void)checkGPSWithComplete:(void(^)(NSInteger code))complete {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, iBeaconStatus_Unknow);
        }else {
            [self.peripheralServiceManager checkGPSWithServiceBlock:^(id data, NSError *error) {
                if (error) {
                    BLOCK_EXEC(complete, iBeaconStatus_Unknow);
                }else {
                    BLOCK_EXEC(complete, [data integerValue]);
                }
            }];
        }
    }];
}

- (void)searchWristWithComplete:(void(^)(NSError *error))complete {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, error);
        }else {
            [self.peripheralServiceManager searchWrist:^(id data, NSError *error) {
                BLOCK_EXEC(complete, error);
            } isStart:YES];
        }
    }];
}

- (void)stopSearchWristWithComplete:(void(^)(NSError *error))complete {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, error);
        }else {
            [self.peripheralServiceManager searchWrist:^(id data, NSError *error) {
                BLOCK_EXEC(complete, error);
            } isStart:NO];
        }
    }];
}


- (void)restartDevieWithComplete:(void(^)(NSError *error))complete{
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, error);
        }else {
            [self.peripheralServiceManager restartWrist:^(NSError *error) {
                BLOCK_EXEC(complete, error);
            }];
        }
    }];
}

// 关闭手环
- (void)closeDeviceWithComplete:(void(^)(NSError *error))complete {
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(complete, error);
        }else {
            [self.peripheralServiceManager closeWrist:^(NSError *error) {
                BLOCK_EXEC(complete, error);
            }];
        }
    }];
}

- (void)readRunModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock {

    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(serviceBlock, nil, nil, error);
        }else {
            [self.peripheralServiceManager readRunModelData:month day:day progressBlock:^(NSInteger total, NSInteger index) {
                
                BLOCK_EXEC(progressBlock, total, index);
            } serviceBlock:serviceBlock];
        }
    }];
}

- (void)cancelRunModelData{
    
    [self.peripheralServiceManager cancelRunModelData];
}

//读取跑步开始时间
- (void)readRunTime:(ReadServiceBlock)serviceBlock level:(GBBluetoothTask_PRIORITY_Level)level{
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(serviceBlock, nil, error);
        }else {
            [self.peripheralServiceManager readRunTime:^(id data, NSError *error) {
                BLOCK_EXEC(serviceBlock, data, error);
            } level:level];
        }
    }];
}

//清除跑步数据
- (void)cleanRunData:(ReadServiceBlock)serviceBlock {
    
    [self checkBeaconState:^(NSError *error) {
        if (error) {
            BLOCK_EXEC(serviceBlock, nil, error);
        }else {
            [self.peripheralServiceManager cleanRunData:^(id data, NSError *error) {
                BLOCK_EXEC(serviceBlock, data, error);
            }];
        }
    }];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    GBLog(@"centralManagerDidUpdateState");
    self.managerState = GBBluetoothManagerState_Complete;
    self.openBluetooth = central.state == CBCentralManagerStatePoweredOn ?: NO;
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            GBLog(@"Powered Off");
            if (self.iBeaconObj) {
                [self disconnectBeacon];
                [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"bluetooth.tip.turn.on")];
            }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            GBLog(@"Powered On");
            if (![NSString stringIsNullOrEmpty:self.iBeaconMac]) { //自动连接手环
                [self connectBeaconWithUI:nil];
            }
        }
            break;
        case CBCentralManagerStateResetting:
            GBLog(@"Resetting");
            self.iBeaconObj = nil;    //清除搜索到的蓝牙设备
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

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    GBLog(@"didDiscoverPeripheral");
    iBeaconInfo *beaconObj = [[iBeaconInfo alloc] initWithPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    if ([beaconObj isValid]) {
        GBLog(@"RSSI: %@", RSSI);
        BLOCK_EXEC(self.beaconHandle, beaconObj, NO, nil);
    }
}

//central提供信息，dict包含了应用程序关闭是系统保存的central的信息，用dic去恢复central
//app状态的保存或者恢复，这是第一个被调用的方法当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法同步app状态通过蓝牙系统
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict
{
    GBLog(@"willRestoreState");
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [self.connectOverTimer invalidate];
    GBLog(@"手环真实连接成功");
    self.needReConnect = YES;
    [self connectComplete:self.iBeaconObj.peripheral];
    //调整手环日期
    [self.peripheralServiceManager adjustDate:nil];
    
    //每次连接成功读取电量、设备版本、日期信息
    [self readConnectInfo:^(NSError *error) {
        
        GBLog(@"手环连接成功");
        self.ibeaconConnectState = iBeaconConnectState_Connected;
        
        for (BluetoothConnectHandler didConnectHandle in self.didConnectHandleList) {
            BLOCK_EXEC(didConnectHandle, nil);
        }
        [self.didConnectHandleList removeAllObjects];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ConnectSuccess object:nil];
        
    }];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    self.needReConnect = NO;
    for (BluetoothConnectHandler didConnectHandle in self.didConnectHandleList) {
        BLOCK_EXEC(didConnectHandle, [[NSError alloc] initWithDomain:LS(@"bluetooth.connect.fail") code:BeanErrors_DeviceNotEligible userInfo:nil]);
    }
    [self.didConnectHandleList removeAllObjects];
    self.ibeaconConnectState = iBeaconConnectState_UnConnect;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    //在搜星成功时， 十秒左右手环会自动断开连接，故添加重连机制
    if (self.needReConnect) {
        GBLog(@"手环重连");
        self.needReConnect = NO;
        [self.peripheralServiceManager cleanPeripheralTask];
        [self connectComplete:nil];
        [self connectBeacon:^(NSError *error) {
            if (error) {
                [self disconnectBeacon];
            }
        }];
    }else {
        [self disconnectBeacon];
    }
}

#pragma mark - NSTimerEvent

- (void)connectOverTime
{
    for (BluetoothConnectHandler didConnectHandle in self.didConnectHandleList) {
        BLOCK_EXEC(didConnectHandle, [[NSError alloc] initWithDomain:LS(@"device.tip.overtime") code:BeanErrors_DeviceNotEligible userInfo:nil]);
    }
    [self.didConnectHandleList removeAllObjects];
    [self disconnectBeacon];
}

- (void)scanOverTime {
    
    [self stopScanning];
    BLOCK_EXEC_SetNil(self.beaconHandle, nil, YES, [[NSError alloc] initWithDomain:LS(@"device.tip.overtime") code:BeanErrors_ScanTimeOut userInfo:nil]);
}

#pragma mark - Private

- (void)checkBeaconState:(void(^)(NSError *error))block {
    
    if (!self.isOpenBluetooth) {
        BLOCK_EXEC(block, [[NSError alloc] initWithDomain:LS(@"bluetooth.tip.turn.on") code:BeanErrors_BluetoothNotOn userInfo:nil]);
        return;
    }
    if ([NSString stringIsNullOrEmpty:self.iBeaconMac]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedBindiBeacon object:nil];
        BLOCK_EXEC(block, [[NSError alloc] initWithDomain:LS(@"bluetooth.bind.device") code:BeanErrors_NeedConnect userInfo:nil]);
        return;
    }
    if (self.ibeaconConnectState == iBeaconConnectState_Connecting) {
        BLOCK_EXEC(block, [[NSError alloc] initWithDomain:LS(@"正在连接中...") code:BeanErrors_NeedConnect userInfo:nil]);
        return;
    }
    
    if (![self isConnectedBean]) { //先连接手环
        self.ibeaconConnectState = iBeaconConnectState_Connecting;
        [self connectBeacon:^(NSError *error) {
            
            BLOCK_EXEC(block, error);
        }];
        return;
    }
    BLOCK_EXEC(block, nil);
}

- (void)connectComplete:(CBPeripheral *)peripheral {
    
    if (peripheral) {
        self.peripheralServiceManager.peripheral = peripheral;
        [self checkiBeaconStatusRepeat];
        
        [BluUtility setUUIDString:peripheral.identifier.UUIDString withKey:self.iBeaconMac];
    }else {
        self.peripheralServiceManager.peripheral = nil;
        [self cancelCheckiBeaconStatusRepeat];
    }
}

/**
 时时查询手环状态
 */
- (void)checkiBeaconStatusRepeat {
    
    //时时查询手环状态
    [self.checkiBeaconStatusTimer invalidate];
    static CGFloat totalTime = 0;
    CGFloat repeatTime = 2.0f;
    self.checkiBeaconStatusTimer = [NSTimer scheduledTimerWithTimeInterval:repeatTime block:^(NSTimer * _Nonnull timer) {
        
        if (![self isConnectedBean]) {
            totalTime = 0;
            return;
        }
        [self checkGPSWithComplete:^(NSInteger code) {
            [self.iBeaconObj setStatus:code];
        }];
        totalTime += repeatTime;
        if (totalTime == repeatTime*4) {//每4s读取一次电量
            totalTime = 0;
            [self readBattery:nil];
        }
        //检查固件和硬件版本号是否正确获取
        if(self.iBeaconObj.firewareVersion.length == 0) {
            [self readBatteryVersion:nil];
        }
        if (self.iBeaconObj.deviceVersion.length == 0) {
            [self readDeviceVer:nil];
        }
    } repeats:YES];
    [self.checkiBeaconStatusTimer fire];
}

/**
 取消时时查询手环状态
 */
- (void)cancelCheckiBeaconStatusRepeat {
    
    [self.checkiBeaconStatusTimer invalidate];
}

#pragma mark - Getter and Setter

- (PeripheralServiceManager *)peripheralServiceManager {
    
    if (!_peripheralServiceManager) {
        _peripheralServiceManager = [[PeripheralServiceManager alloc] init];
    }
    return _peripheralServiceManager;
}

- (void)setIbeaconConnectState:(iBeaconConnectState)ibeaconConnectState {
    
    _ibeaconConnectState = ibeaconConnectState;
}

@end
