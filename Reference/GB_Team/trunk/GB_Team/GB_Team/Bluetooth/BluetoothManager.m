//
//  BluetoothManager.m
//  GB_Football
//
//  Created by wsw on 16/8/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BluetoothManager.h"
#import  <CoreBluetooth/CoreBluetooth.h>
#import "PeripheralServiceManager.h"

#import "BleGlobal.h"

static const NSTimeInterval kConnectOverTimeInterval = 10;
static const NSTimeInterval kScanOverTimeInterval = 30;
static const NSInteger kMaxConnectiBeaconCout = 3;
static const NSInteger kMaxUpdateConnectiBeaconCout = 1;

@interface BluetoothTask : NSObject

@property (nonatomic, strong) iBeaconInfo *iBeacon;
@property (nonatomic, copy) void(^doTask)();

@end

@implementation BluetoothTask

- (instancetype)initWithiBeacon:(iBeaconInfo *)iBeacon doTask:(void(^)())doTask {
    
    if(self=[super init]){
        _iBeacon = iBeacon;
        _doTask = doTask;
    }
    return self;
}

@end

typedef void(^doBluetoothBlock) (PeripheralServiceManager *peripheralServiceManager, NSError *error);

@interface BluetoothManager () <
CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;

//设备事件处理
@property (nonatomic, strong) NSMutableArray<PeripheralServiceManager *> *peripheralServiceManagerList;
//扫描到的设备列表
@property (nonatomic, strong) NSMutableArray<iBeaconInfo *> *iBeaconObjList;
//需要连接的手环mac
@property (nonatomic, strong) NSMutableArray<NSString *> *iBeaconMacList;
//任务列表
@property (nonatomic, strong) NSMutableArray<BluetoothTask *> *taskList;
//设备扫描
@property (nonatomic, strong) NSMutableDictionary<NSString *, BluetoothScanBeaconHandler> *scanHandleDic;
//设备连接
@property (nonatomic, strong) NSMutableDictionary *didConnectHandleDic;
//连接超时
@property (nonatomic, strong) NSMutableDictionary *connectTimeOutDic;
//同一个手环的多任务
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<doBluetoothBlock> *> *taskDictionary;
//进行中的任务
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *doingTaskDictionary;

@property (nonatomic, strong) NSTimer *scanOverTimer;

@property (nonatomic, assign) BOOL isScanning;
@property (nonatomic, assign) NSInteger maxTaskCount; //最多运行任务个数

@end

@implementation BluetoothManager

+ (BluetoothManager *)sharedBluetoothManager
{
    static dispatch_once_t once;
    static BluetoothManager *instance;
    dispatch_once(&once, ^{
        instance = [[BluetoothManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //        CBCentralManagerOptionShowPowerAlertKey
        //        布尔值，表示的是在central manager初始化时，如果当前蓝牙没打开，是否弹出alert框。
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey, @"zStrapRestoreIdentifier",CBCentralManagerOptionRestoreIdentifierKey,nil];
        
        _manager = [[CBCentralManager alloc] initWithDelegate:self
                                                        queue:nil // 需要次线程？dispatch_queue_create("com.GB_Football", DISPATCH_QUEUE_SERIAL)
                                                      options:options];
        
        _peripheralServiceManagerList = [NSMutableArray arrayWithCapacity:1];
        _iBeaconObjList = [NSMutableArray arrayWithCapacity:1];
        _iBeaconMacList = [NSMutableArray arrayWithCapacity:1];
        _scanHandleDic = [NSMutableDictionary dictionaryWithCapacity:1];
        _didConnectHandleDic = [NSMutableDictionary dictionaryWithCapacity:1];
        _connectTimeOutDic = [NSMutableDictionary dictionaryWithCapacity:1];
        _taskList = [NSMutableArray arrayWithCapacity:1];
        _taskDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        _doingTaskDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        _maxTaskCount = kMaxConnectiBeaconCout;
    }
    return self;
}

#pragma mark - Public

- (void)resetBluetoothManager {
    
    [self.taskList removeAllObjects];
    NSArray *tmpSearviceList = [self.peripheralServiceManagerList copy];
    for (PeripheralServiceManager *serviceManager in tmpSearviceList) {
        [serviceManager cleanPeripheralTask];
        [self.manager cancelPeripheralConnection:serviceManager.iBeacon.peripheral];
    }
    [self.peripheralServiceManagerList removeAllObjects];
    [self.iBeaconObjList removeAllObjects];
    [self.iBeaconMacList removeAllObjects];
    [self.scanHandleDic removeAllObjects];
    [self.didConnectHandleDic removeAllObjects];
    [self.connectTimeOutDic removeAllObjects];
    [self.taskDictionary removeAllObjects];
    [self.doingTaskDictionary removeAllObjects];
    
    [self.manager stopScan];
    [self.scanOverTimer invalidate];
    
    self.isScanning = NO;
}

- (void)disconnectBeacon {
    
    
}

- (void)stopScanning {
    
    [self.manager stopScan];
    [self.scanOverTimer invalidate];
}

#pragma mark  事件处理
- (void)readBatteryVersionDateWithMac:(NSString *)mac handler:(void(^)(NSArray<NSNumber *> *data, NSError *error))handler {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(handler, nil, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        if (error) {
            BLOCK_EXEC(handler, nil, error);
            return;
        }
        
        [peripheralServiceManager readBatteryVersionDate:^(id data, NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            if (!error) {
                NSArray *resultArray = data;
                peripheralServiceManager.iBeacon.battery = [resultArray[0] integerValue];
                peripheralServiceManager.iBeacon.firewareVersion = resultArray[1];
                peripheralServiceManager.iBeacon.firewareDate = resultArray[2];
            }
            BLOCK_EXEC(handler, data, error);
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)readVersionWithMac:(NSString *)mac handler:(void(^)(NSString *version, NSError *error))handler {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(handler, nil, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
            return;
        }
        
        [peripheralServiceManager readVersion:^(id data, NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            BLOCK_EXEC(handler, data, error);
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)readFireVersionAndDeviceVersionWithMac:(NSString *)mac handler:(void(^)(NSString *fireVersion, NSString *deviceVersion, iBeaconVersion deviceVersionType, NSError *error))handler {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(handler, nil, nil, iBeaconVersion_None, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        
        if (error) {
            BLOCK_EXEC(handler, nil, nil, iBeaconVersion_None, error);
            return;
        }
        
        [peripheralServiceManager readVersion:^(id data, NSError *error) {
            
            if (error) {
                [self completeBluetoothTask:peripheralServiceManager];
                BLOCK_EXEC(handler, nil, nil, iBeaconVersion_None, error);
            }else {
                NSString *fireVersion = data;
                [peripheralServiceManager readDeviceVersion:^(id data, NSError *error) {
                    [self completeBluetoothTask:peripheralServiceManager];
                    iBeaconVersion version = iBeaconVersion_None;
                    if ([data floatValue]+0.01>=2) {
                        version = iBeaconVersion_T_Goal_S;
                    }else {
                        version = iBeaconVersion_T_Goal;
                    }
                    BLOCK_EXEC(handler, fireVersion, data, version, error);
                }];
            }
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)readBatteryWithMac:(NSString *)mac handler:(void(^)(NSInteger battery, NSError *error))handler {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(handler, 0, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        if (error) {
            BLOCK_EXEC(handler, 0, error);
            return;
        }
        
        [peripheralServiceManager readBattery:^(id data, NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            BLOCK_EXEC(handler, [data integerValue], error);
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)readDeviceVerWithMac:(NSString *)mac handler:(void(^)(NSString *version, iBeaconVersion versionType, NSError *error))handler {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(handler, 0, iBeaconVersion_None, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        if (error) {
            BLOCK_EXEC(handler, 0, iBeaconVersion_None, error);
            return;
        }
        
        [peripheralServiceManager readDeviceVersion:^(id data, NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            iBeaconVersion version = iBeaconVersion_None;
            if ([data floatValue]+0.01>=2) {
                version = iBeaconVersion_T_Goal_S;
            }else {
                version = iBeaconVersion_T_Goal;
            }
            BLOCK_EXEC(handler, data, version, error);
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)searchWristWithMac:(NSString *)mac handler:(void(^)(NSError *error))handler {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(handler, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        if (error) {
            BLOCK_EXEC(handler, error);
            return;
        }
        
        [peripheralServiceManager searchWrist:^(id data, NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            BLOCK_EXEC(handler, error);
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)readSportModelDataWithMac:(NSString *)mac month:(NSInteger)month day:(NSInteger)day serviceBlock:(void(^)(id data, id originalData, NSError *error))serviceBlock progressBlock:(void (^)(CGFloat progress))progressBlock {

    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        
        if (error) {
            BLOCK_EXEC(serviceBlock, nil, nil, error);
            return;
        }
        
        //先切到日常模式
        [peripheralServiceManager switchModelWithIndx:0 serviceBlock:^(NSError *error) {
            
            [peripheralServiceManager readSportModelData:month day:day progressBlock:^(CGFloat progress) {
                
                BLOCK_EXEC(progressBlock, progress);
            } serviceBlock:^(id data, id sourceData, NSError *error) {
                [self completeBluetoothTask:peripheralServiceManager];
                BLOCK_EXEC(serviceBlock, data, sourceData, error);
            }];
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)cancelSportModelData {

    for (PeripheralServiceManager *peripheralServiceManager in self.peripheralServiceManagerList) {
        [peripheralServiceManager cancelSportModelData];
        [self.manager cancelPeripheralConnection:peripheralServiceManager.iBeacon.peripheral];
        [self.doingTaskDictionary removeObjectForKey:peripheralServiceManager.iBeacon.address];
    }
}

// 固件升级
- (void)enterUpdateMode {
    
    [self resetBluetoothManager];
    self.maxTaskCount = kMaxUpdateConnectiBeaconCout;
}

- (void)overUpdateMode {
    
    [self resetBluetoothManager];
    self.maxTaskCount = kMaxConnectiBeaconCout;
}

- (void)updateFirewareWithMac:(NSString *)mac deviceVersionType:(iBeaconVersion)deviceVersionType filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(CGFloat progress))progressBlock; {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(complete, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        
        if (error) {
            BLOCK_EXEC(complete, error);
            return;
        }
        [peripheralServiceManager updateFireware:filePath serviceBlock:^(NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            BLOCK_EXEC(complete, error);
        } progressBlock:^(CGFloat progress) {
            
            BLOCK_EXEC(progressBlock, progress);
        } isNeedDfu:(deviceVersionType==iBeaconVersion_T_Goal_S) manager:self.manager];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)cancelUpdateFireware {
    
//    for (PeripheralServiceManager *peripheralServiceManager in self.peripheralServiceManagerList) {
//        [peripheralServiceManager cleanPeripheralTask];
//    }
//    [self.peripheralServiceManagerList removeAllObjects];
    
    for (PeripheralServiceManager *peripheralServiceManager in self.peripheralServiceManagerList) {
        [self.manager cancelPeripheralConnection:peripheralServiceManager.iBeacon.peripheral];
        [self.doingTaskDictionary removeObjectForKey:peripheralServiceManager.iBeacon.address];
    }
}

- (void)switchModelWithMac:(NSString *)mac index:(NSInteger)index complete:(void(^)(NSError *error))complete {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(complete, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        if (error) {
            BLOCK_EXEC(complete, error);
            return;
        }
        [peripheralServiceManager switchModelWithIndx:index serviceBlock:^(NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            BLOCK_EXEC(complete, error);
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)searchStarWithMac:(NSString *)mac filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(CGFloat progress))progressBlock {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error) {
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(complete, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        
        if (error) {
            BLOCK_EXEC(complete, error);
            return;
        }
        
        //先切换到足球模式
        [peripheralServiceManager switchModelWithIndx:1 serviceBlock:^(NSError *error) {
            
            if (error) {
                [self completeBluetoothTask:peripheralServiceManager];
                
                BLOCK_EXEC(complete, [[NSError alloc] initWithDomain:@"加速失败" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
                return;
            }else {
                //切换中， 等待手环GPS模块启动
                [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
                    [peripheralServiceManager checkGPSWithServiceBlock:^(id data, NSError *error) {
                        if (error) {
                            [self completeBluetoothTask:peripheralServiceManager];
                            
                            BLOCK_EXEC(complete, [[NSError alloc] initWithDomain:@"加速失败" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
                            [timer invalidate];
                            return;
                        }else {
                            if ([data integerValue] == 0 || [data integerValue] == 1) { //GPS模块启动成功
                                [timer invalidate];
                                //星历写入
                                [peripheralServiceManager searchStartProfile:filePath serviceBlock:^(NSError *error) {
                                    
                                    [self completeBluetoothTask:peripheralServiceManager];
                                    BLOCK_EXEC(complete, error);
                                }progressBlock:^(CGFloat progress) {
                                    BLOCK_EXEC(progressBlock, progress);
                                }];
                            }
                        }
                    }];
                } repeats:YES];
            }
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)cancelAllSearchStar {
    
    NSArray *tmpSearviceList = [self.peripheralServiceManagerList copy];
    for (PeripheralServiceManager *peripheralServiceManager in tmpSearviceList) {
        [peripheralServiceManager cancelSearchStar];
        [self.manager cancelPeripheralConnection:peripheralServiceManager.iBeacon.peripheral];
        [self.doingTaskDictionary removeObjectForKey:peripheralServiceManager.iBeacon.address];
    }
}

- (void)cancelSearchStarWithMac:(NSString *)mac {
    
    NSArray *tmpSearviceList = [self.peripheralServiceManagerList copy];
    for (PeripheralServiceManager *peripheralServiceManager in tmpSearviceList) {
        if ([peripheralServiceManager.iBeacon.address isEqualToString:mac]) {
            [peripheralServiceManager cancelSearchStar];
            if (peripheralServiceManager.iBeacon.peripheral.state == CBPeripheralStateConnected) {
                [self.manager cancelPeripheralConnection:peripheralServiceManager.iBeacon.peripheral];
            }
            break;
        }
    }
    [self.taskDictionary removeObjectForKey:mac];
    [self.doingTaskDictionary removeObjectForKey:mac];
}

- (void)checkGPSWithMac:(NSString *)mac complete:(void(^)(NSInteger code))complete {
    
    NSMutableArray *taskList = [NSMutableArray arrayWithArray:[self.taskDictionary objectForKey:mac]];
    if (taskList.count>0) {//有正在进行中的任务不处理
        return;
    }
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(complete, 3);
            return;
        }
        if (error) {
            BLOCK_EXEC(complete, 3);
            return;
        }
        [peripheralServiceManager checkGPSWithServiceBlock:^(id data, NSError *error) {
            
            [self completeBluetoothTask:peripheralServiceManager];
            if (error) {
                BLOCK_EXEC(complete, 3);
            }else {
                BLOCK_EXEC(complete, [data integerValue]);
            }
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

- (void)restartDevieWithMac:(NSString *)mac complete:(void(^)(NSError *error))handler {
    
    doBluetoothBlock block = ^(PeripheralServiceManager *peripheralServiceManager, NSError *error){
        
        if (!peripheralServiceManager) {
            BLOCK_EXEC(handler, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
            return;
        }
        if (error) {
            BLOCK_EXEC(handler, error);
            return;
        }
        [peripheralServiceManager restartWrist:^(NSError *error) {
            [self completeBluetoothTask:peripheralServiceManager];
            BLOCK_EXEC(handler, error);
        }];
    };
    
    [self addTaskWithMac:mac block:block];
}

#pragma mark - Task

- (void)addTaskWithMac:(NSString *)mac block:(doBluetoothBlock)block {
    
    NSMutableArray *taskList = [NSMutableArray arrayWithArray:[self.taskDictionary objectForKey:mac]];
    [taskList addObject:block];
    GBLog(@"mac：%@， 当前任务个数：%td", mac, taskList.count);
    [self.taskDictionary setObject:[taskList copy] forKey:mac];
    if (taskList.count == 1) { //启动任务
        [self.iBeaconMacList addObject:mac];
        [self checkBeaconState:^(PeripheralServiceManager *peripheralServiceManager, NSError *error) {
            if (error) {
                BLOCK_EXEC(block, nil, error);
                [self completeBluetoothTask:peripheralServiceManager];
                NSMutableArray *taskList = [NSMutableArray arrayWithArray:[self.taskDictionary objectForKey:mac]];
                //移除该手环剩下的所有任务
                for (doBluetoothBlock block in taskList) {
                    BLOCK_EXEC(block, nil, nil);
                }
                [self.taskDictionary removeObjectForKey:mac];
            }else {
                BLOCK_EXEC(block, peripheralServiceManager, nil);
            }
        }];
    }else {//等待任务完成
        
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {

    GBLog(@"centralManagerDidUpdateState");
    
    self.openBluetooth = central.state == CBCentralManagerStatePoweredOn ?: NO;
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            GBLog(@"Powered Off");
            break;
        case CBCentralManagerStatePoweredOn:
            GBLog(@"Powered On");
            break;
        case CBCentralManagerStateResetting:
            GBLog(@"Resetting");
            [self.iBeaconObjList removeAllObjects];
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

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    iBeaconInfo *beaconObj = [[iBeaconInfo alloc] initWithPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    if ([beaconObj isValid]) {
        
        GBLog(@"didDiscoverPeripheral:%@", beaconObj.address);
        
        [self.iBeaconObjList addObject:beaconObj];
        
        NSString *findMac = nil;
        for (NSString *needConnectMac in self.iBeaconMacList) {
            if ([needConnectMac isEqualToString:beaconObj.address]) {
                findMac = needConnectMac;
                BluetoothScanBeaconHandler scanHandler = [self.scanHandleDic objectForKey:findMac];
                BLOCK_EXEC(scanHandler, beaconObj, NO, nil);
                [self.scanHandleDic removeObjectForKey:findMac];
                break;
            }
        }
        if (findMac) {
            [self.iBeaconMacList removeObject:findMac];
        }
    }
}

//central提供信息，dict包含了应用程序关闭是系统保存的central的信息，用dic去恢复central
//app状态的保存或者恢复，这是第一个被调用的方法当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法同步app状态通过蓝牙系统
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict {
    
    GBLog(@"willRestoreState");
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    GBLog(@"peripheral:%@ 设备连接成功", peripheral);
    //连接超时取消
    iBeaconConnectObject *object = [self.connectTimeOutDic objectForKey:peripheral];
    [object cancelPerformBlock];
    [self.connectTimeOutDic removeObjectForKey:peripheral];
    
    BluetoothConnectHandler connectHandler = [self.didConnectHandleDic objectForKey:peripheral];
    BLOCK_EXEC(connectHandler, nil);
    [self.didConnectHandleDic removeObjectForKey:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    GBLog(@"peripheral:%@ 设备连接失败", peripheral);
    //连接超时取消
    iBeaconConnectObject *object = [self.connectTimeOutDic objectForKey:peripheral];
    [object cancelPerformBlock];
    [self.connectTimeOutDic removeObjectForKey:peripheral];
    
    NSString *mac = [self iBeaconWithPeripheral:peripheral].address;
    BluetoothConnectHandler connectHandler = [self.didConnectHandleDic objectForKey:peripheral];
    BLOCK_EXEC(connectHandler, [[NSError alloc] initWithDomain:@"设备连接失败" code:BeanErrors_DeviceNotEligible userInfo:@{@"mac":!mac?@"":mac}]);
    [self.didConnectHandleDic removeObjectForKey:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    GBLog(@"peripheral:%@ 设备取消连接", peripheral);
}

#pragma mark - NSTimerEvent

- (void)scanOverTime {
    
    [self stopScanning];
    GBLog(@"扫描超时");
    for (NSString *mac in self.iBeaconMacList) {
        BluetoothScanBeaconHandler scanHandler = [self.scanHandleDic objectForKey:mac];
        BLOCK_EXEC(scanHandler, nil, YES, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ScanTimeOut userInfo:@{@"mac":mac}]);
        [self.scanHandleDic removeObjectForKey:mac];
    }
    [self.iBeaconMacList removeAllObjects];
    
    self.isScanning = NO;
}

#pragma mark - Private

- (void)startScanningWithBeaconHandler:(BluetoothScanBeaconHandler)scanHandle {
    
    [self.scanHandleDic setObject:scanHandle forKey:self.iBeaconMacList.lastObject];
    self.manager.delegate = self;
    //判断是否已经在扫描的外设列表中
    NSMutableArray *findMacList = [NSMutableArray arrayWithCapacity:1];
    for (NSString *needConnectMac in self.iBeaconMacList) {
        for(iBeaconInfo *iBeacon in self.iBeaconObjList) {
            if ([needConnectMac isEqualToString:iBeacon.address]) {
                [findMacList addObject:needConnectMac];
                BluetoothScanBeaconHandler scanHandler = [self.scanHandleDic objectForKey:needConnectMac];
                BLOCK_EXEC(scanHandler, iBeacon, NO, nil);
                [self.scanHandleDic removeObjectForKey:needConnectMac];
                break;
            }
        }
    }
    [self.iBeaconMacList removeObjectsInArray:[findMacList copy]];
    
    if (self.iBeaconMacList.count>0 && !self.isScanning) { //还有未找到的mac，  需要重新扫描
        //移除旧的收手环设备
        [self.iBeaconObjList removeAllObjects];
        self.isScanning = YES;
        
        [self.scanOverTimer invalidate];
        self.scanOverTimer = [NSTimer scheduledTimerWithTimeInterval:kScanOverTimeInterval target:self selector:@selector(scanOverTime) userInfo:nil repeats:NO];
        [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:GLOBAL_PACKET_SERVICE_UUID]] options:nil];
    }
}

- (void)connectBeacon:(iBeaconInfo *)iBeaconInfo connectHandle:(BluetoothConnectHandler)connectHandle {
    
    if (!self.isOpenBluetooth) {
        BLOCK_EXEC(connectHandle, [[NSError alloc] initWithDomain:@"请打开手机蓝牙" code:BeanErrors_BluetoothNotOn userInfo:nil]);
        return;
    }
    
    if (iBeaconInfo.peripheral.state == CBPeripheralStateConnected) {
        BLOCK_EXEC(connectHandle, nil);
        return;
    }
    
    [self.didConnectHandleDic setObject:connectHandle forKey:iBeaconInfo.peripheral];
    [self.manager connectPeripheral:iBeaconInfo.peripheral options:nil];
    
    iBeaconConnectObject *object = [[iBeaconConnectObject alloc] init];
    [object performBlock:^{
        [self.manager cancelPeripheralConnection:iBeaconInfo.peripheral];
        [self.connectTimeOutDic removeObjectForKey:iBeaconInfo.peripheral];
        BLOCK_EXEC(connectHandle, [[NSError alloc] initWithDomain:@"手环连接超时" code:BeanErrors_ConnectTimeOut userInfo:@{@"mac":iBeaconInfo.address}]);
    } delay:kConnectOverTimeInterval];
    [self.connectTimeOutDic setObject:object forKey:iBeaconInfo.peripheral];
}

- (void)checkBeaconState:(void(^)(PeripheralServiceManager *peripheralServiceManager, NSError *error))block {
    
    if (!self.isOpenBluetooth) {
        BLOCK_EXEC(block, nil, [NSError errorWithDomain:@"请打开手机蓝牙" code:BeanErrors_BluetoothNotOn userInfo:nil]);
        return;
    }
    
    [self startScanningWithBeaconHandler:^(iBeaconInfo *foundBeacons, BOOL isStop, NSError *error) {
        
        if (!error) {
            BluetoothTask *task = [[BluetoothTask alloc] initWithiBeacon:foundBeacons doTask:^{
                
                if (!self.isOpenBluetooth) {
                    BLOCK_EXEC(block, nil, [[NSError alloc] initWithDomain:@"请打开手机蓝牙" code:BeanErrors_BluetoothNotOn userInfo:nil]);
                    return;
                }
                [self connectBeacon:foundBeacons connectHandle:^(NSError *error) {
                    
                    PeripheralServiceManager *peripheralServiceManager = [[PeripheralServiceManager alloc] init];
                    peripheralServiceManager.iBeacon = foundBeacons;
                    [self.peripheralServiceManagerList addObject:peripheralServiceManager];
                    //设置手环时间
                    [peripheralServiceManager adjustDate:nil];
                    BLOCK_EXEC(block, peripheralServiceManager, error);
                }];
            }];
            [self.taskList addObject:task];
            [self doBluetoothTask];
        }else {
            BLOCK_EXEC(block, nil, error);
        }
    }];
}

- (void)completeBluetoothTask:(PeripheralServiceManager *)peripheralServiceManager {
    
    if (peripheralServiceManager) {
        NSMutableArray *taskList = [NSMutableArray arrayWithArray:[self.taskDictionary objectForKey:peripheralServiceManager.iBeacon.address]];
        if (taskList.count>0) {
            [taskList removeObjectAtIndex:0];
            [self.taskDictionary setObject:[taskList copy] forKey:peripheralServiceManager.iBeacon.address];
            if (taskList.count>0) {//继续该手环的下一任务
                doBluetoothBlock block = taskList.firstObject;
                block(peripheralServiceManager, nil);
                return;
            }
        }
        
        [self.doingTaskDictionary removeObjectForKey:peripheralServiceManager.iBeacon.address];
        [self.manager cancelPeripheralConnection:peripheralServiceManager.iBeacon.peripheral];
        [self.peripheralServiceManagerList removeObject:peripheralServiceManager];
    }
    
    //下一个任务
    [self doBluetoothTask];
}

- (void)doBluetoothTask {
    
    if (self.doingTaskDictionary.allKeys.count == self.maxTaskCount) {  //任务已满
        return;
    }
    
    BluetoothTask *task = [self.taskList firstObject];
    if (!task) {
        return;
    }
    [self.doingTaskDictionary setObject:@"" forKey:task.iBeacon.address];
    [self.taskList removeObject:task];
    BLOCK_EXEC(task.doTask);
}

- (iBeaconInfo *)iBeaconWithPeripheral:(CBPeripheral *)peripheral {
    
    iBeaconInfo *result = nil;
    for (iBeaconInfo *iBeacon in self.iBeaconObjList) {
        if (iBeacon.peripheral == peripheral) {
            result = iBeacon;
            break;
        }
    }
    
    return result;
}

- (PeripheralServiceManager *)peripheralServiceManagerWithPeripheral:(CBPeripheral *)peripheral {
    
    PeripheralServiceManager *result = nil;
    for (PeripheralServiceManager *service in self.peripheralServiceManagerList) {
        if (service.iBeacon.peripheral == peripheral) {
            result = service;
            break;
        }
    }
    
    return result;
}

#pragma mark - Getter and Setter

@end
