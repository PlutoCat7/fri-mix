//
//  GBSingleBleManager.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/16.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBSingleBleManager.h"
#import "GBPeripheralTask.h"
#import "GBProgPeripheralTask.h"
#import "PacketProfile.h"
#import "ProgressPacketProfile.h"
#import "GBPeripheralDelegateImpl.h"
#import "GBBluetoothCenterManager.h"

#import "GBBleConstants.h"
#import "GBBleEnums.h"

#import "BatteryProfile.h"
#import "FirewareDateProfile.h"
#import "FirewareVerProfile.h"
#import "DeviceVerProfile.h"
#import "AdjustDateProfile.h"
#import "CheckModelProfile.h"
#import "SwitchModelProfile.h"
#import "CheckGPSProfile.h"
#import "FindDeviceProfile.h"
#import "UpdateProfile.h"
#import "DailyMutableProfile.h"
#import "SportProfile.h"
#import "AGPSProfile.h"
#import "ResetProfile.h"
#import "FixedInfoProfile.h"
#import "VariableInfoProfile.h"

NSString * const GBDeviceDidConnectedNotification = @"GBDeviceDidConnectedNotification";
NSString * const GBDeviceDidDisConnectedNotification = @"GBDeviceDidDisConnectedNotification";

@interface GBSingleBleManager() <
GBPeripheralTaskDelegate,
GBBeanManagerDelegate,
GBDeviceActiveGattDelegate,
GBBluetoothCenterManagerDelegate>

@property (nonatomic, strong) GBBeanManager *beanManager;
@property (nonatomic, strong) GBPeripheralDelegateImpl *peripheralImpl;

@property (nonatomic, strong) NSMutableArray<GBPeripheralTask *> *taskList;
@property (nonatomic, strong) GBPeripheralTask *currentTask;

@property (nonatomic, assign, readwrite) BleGpsState gpsState;
@property (nonatomic, assign, readwrite) GBConnectState connectState;

@property (nonatomic, copy) BleScanBeaconHandler scanBeaconHandler;

//是否是开始新一轮的执行列表
@property (nonatomic, assign) BOOL isStartQueue;
    
@end

@implementation GBSingleBleManager

// 单例模式
+ (GBSingleBleManager *)sharedSingleBleManager {
    static dispatch_once_t once;
    static GBSingleBleManager *instance;
    dispatch_once(&once, ^{
        instance = [[GBSingleBleManager alloc] init];
    });
    return instance;
}

- (void)startWithDefault {
    // 这里做环境变量的配置，现在没有用
}

- (instancetype)init {
    
    return [self initWithMac:nil];
}

- (instancetype)initWithMac:(NSString *)mac {
    
    if (self = [super init]) {
        _beanManager = [[GBBeanManager alloc] init];
        _peripheralImpl = [[GBPeripheralDelegateImpl alloc] init];
        
        _taskList = [NSMutableArray arrayWithCapacity:1];
        
        _beanManager.beanManagerDelegate = self;
        _macAddr = mac;
        
        [self observeBeanManagerState];
        
        [[GBBluetoothCenterManager sharedCenterManager] initConfig];
    }
    return self;
}

- (void)dealloc {
    [self unobserveBeanManagerState];
}

// 开始扫描设备
- (void)startScanningWithBeaconHandler:(BleScanBeaconHandler)scanBeaconHandle {
    [self startScanningWithBeaconHandler:scanBeaconHandle timeInterval:kScanOverTimeInterval];
}

- (void)startScanningWithBeaconHandler:(BleScanBeaconHandler)scanBeaconHandle timeInterval:(NSTimeInterval)timeInterval {
    
    self.scanBeaconHandler = scanBeaconHandle;
    [[GBBluetoothCenterManager sharedCenterManager] addDelegate:self];
    [[GBBluetoothCenterManager sharedCenterManager] startScanWithTimeInterval:timeInterval];
}

//停止搜索
- (void)stopScanning {
    
    [[GBBluetoothCenterManager sharedCenterManager] removeDelegate:self];
    [[GBBluetoothCenterManager sharedCenterManager] stopScan];
    self.scanBeaconHandler = nil;
}

//连接蓝牙, 需先设置iBeaconMac的值
- (void)connectBeaconWithMac:(NSString *)mac connectHandle:(BleConnectHandler)connectHandle {
    
    self.macAddr = mac;
    
    __weak typeof(self) weakSelf  = self;
    [self.beanManager connectBeaconWithMac:mac connectHandle:^(GBBeacon *beacon, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (beacon && !error) {
            //调整手环日期
            [strongSelf adjustDate:[NSDate date] handler:nil];
        } else {
            [strongSelf cleanAllTask];
        }
        
        BLE_BLOCK_EXEC(connectHandle, beacon, error);
    }];
    
}

//重连蓝牙，在其他意外情况断开(不是使用)的时候可以通过这个帮忙连接
- (void)reconnectBeacon:(BleConnectHandler)connectHandle {
    
    __weak typeof(self) weakSelf  = self;
    [self.beanManager reconnectBeacon:^(GBBeacon *beacon, NSError *error) {
        if (error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf cleanAllTask];
        }
        BLE_BLOCK_EXEC(connectHandle, beacon, error);
    }];
}

//断开连接，但不清除beacon
- (void)disconnectBeacon:(BleDisconnectHandler)disconnectHandle {
    [self.beanManager disconnectBeacon:disconnectHandle];
}

//断开连接，并把所有的数据清除
- (void)disconnectAndClearBeacon:(BleDisconnectHandler)disconnectHandle {
    
    __weak typeof(self) weakSelf = self;
    [self.beanManager disconnectAndClearBeacon:^(NSError *error) {
        if (!error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.macAddr = nil;
        }
        BLE_BLOCK_EXEC(disconnectHandle, error)
    }];
}

#pragma mark - Public 处理业务
//读电量
- (void)readBatteryWithCompletionHandler:(void(^)(NSInteger battery, NSError *error))completionHandler {
    
    BatteryProfile *batteryProfile = [[BatteryProfile alloc] init];
    [self checkAndAddTaskWithProfile:batteryProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        if (error) {
            BLE_BLOCK_EXEC(completionHandler, 0, error);
        } else {
            BLE_BLOCK_EXEC(completionHandler, [parseData integerValue], error);
        }
    }];
}

//读日期
- (void)readDateWithCompletionHandler:(void(^)(NSDate *date, NSError *error))completionHandler {
    
    FirewareDateProfile *dateProfile = [[FirewareDateProfile alloc] init];
    [self checkAndAddTaskWithProfile:dateProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, parseData, error);
    }];
}

//读固件版本
- (void)readFirmwareVersionWithCompletionHandler:(void(^)(NSString *version, NSError *error))completionHandler {
    
    FirewareVerProfile *firewareVerProfile = [[FirewareVerProfile alloc] init];
    [self checkAndAddTaskWithProfile:firewareVerProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, parseData, error);
    }];
}

//读硬件版本
- (void)readDeviceVersionWithCompletionHandler:(void(^)(NSString *version, NSError *error))completionHandler {

    DeviceVerProfile *deviceVerProfile = [[DeviceVerProfile alloc] init];
    [self checkAndAddTaskWithProfile:deviceVerProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, parseData, error);
    }];
}

//矫正手环时间
- (void)adjustDate:(NSDate *)date handler:(void(^)(NSError *error))handler {
    
    AdjustDateProfile *adjustDateProfile = [[AdjustDateProfile alloc] initWithDate:date];
    [self checkAndAddTaskWithProfile:adjustDateProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, error);
    }];
}

- (void)readFixedInfoWithCompletionHandler:(void(^)(NSArray *result, NSError *error))completionHandler {

    FixedInfoProfile *profile = [[FixedInfoProfile alloc] init];
    [self checkAndAddTaskWithProfile:profile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, parseData, error);
    }];
}

//读取手环可变信息
- (void)readVariableInfoWithCompletionHandler:(void(^)(NSArray *result, NSError *error))completionHandler {

    VariableInfoProfile *profile = [[VariableInfoProfile alloc] init];
    [self checkAndAddTaskWithProfile:profile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, parseData, error);
    }];
}

//检查模式
- (void)checkModelWithCompletionHandler:(void(^)(BleModel model, NSError *error))completionHandler {
    
    CheckModelProfile *checkModelProfile = [[CheckModelProfile alloc] init];
    [self checkAndAddTaskWithProfile:checkModelProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, (BleModel)[parseData integerValue], error);
    }];
}

//切换模式
- (void)switchModelWithModel:(BleModel)model completionHandler:(void(^)(NSError *error))completionHandler {
    
    SwitchModelProfile *switchModelProfile = [[SwitchModelProfile alloc] initWithModel:model];
    [self checkAndAddTaskWithProfile:switchModelProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, error);
    }];
}

//检查gps状态
- (void)checkGpsStateWithCompletionHandler:(void(^)(BleGpsState state, NSError *error))completionHandler {
    
    CheckGPSProfile *checkGPSProfile = [[CheckGPSProfile alloc] init];
    __weak typeof(self) weakSelf  = self;
    [self checkAndAddTaskWithProfile:checkGPSProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.gpsState = (BleGpsState)[parseData integerValue];
        BLE_BLOCK_EXEC(completionHandler, strongSelf.gpsState, error);
    }];
}

//找手环
- (void)findDeviceWithState:(BleFindState)findState completionHandler:(void(^)(NSError *error))completionHandler {
    
    FindDeviceProfile *findDeviceProfile = [[FindDeviceProfile alloc] initWithFindState:findState];
    [self checkAndAddTaskWithProfile:findDeviceProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, error);
    }];
}

// 读取多天普通模式的基本数据记录
- (void)readCommonDataWithDateList:(NSArray<NSDate *> *)dateList completionHandler:(void(^)(id data, NSError *error))completionHandler {
    
    DailyMutableProfile *dailyProfile = [[DailyMutableProfile alloc] initWithMultiDate:dateList];
    [self checkAndAddTaskWithProfile:dailyProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, parseData, error);
    }];
}

- (void)cancelReadCommonDataWithDateList:(NSArray *)dateList {
    
    DailyMutableProfile *dailyProfile = [[DailyMutableProfile alloc] initWithMultiDate:dateList];
    [self cleanTaskWithProfile:dailyProfile];
    
}

// 读取某日运动模式的基本数据记录
- (void)readMatchDataWithProgressBlock:(void (^)(NSProgress *progress))progressBlock completionHandler:(void(^)(id data, id originalData, NSError *error))completionHandler {
    
    NSArray *tasks = [self findEqualTaskWithProfileClass:[SportProfile class]];
    if ([tasks count] > 0) {
        BLE_BLOCK_EXEC(completionHandler, nil, nil, [[NSError alloc] initWithDomain:@"SportProfile has existed" code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    // month,day都为0是读手环里的当前数据
    SportProfile *sportProfile = [[SportProfile alloc] initWithDate:0 day:0];
    [self checkAndAddTaskWithProgressProfile:sportProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, parseData, sourceData, error);
        
    } progressBlock:^(NSInteger total, NSInteger index) {
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
        progress.completedUnitCount = index;
        
        BLE_BLOCK_EXEC(progressBlock, progress);
    }];
    
}

- (void)cancelReadMatchData {
    [self cleanTaskWithProfileClass:[SportProfile class]];
}

// 固件升级
- (void)updateFirewareWithFilePath:(NSURL *)filePath progressBlock:(void (^)(NSProgress *progress))progressBlock completionHandler:(void(^)(NSError *error))completionHandler {
    
    NSArray *tasks = [self findEqualTaskWithProfileClass:[UpdateProfile class]];
    if ([tasks count] > 0) {
        BLE_BLOCK_EXEC(completionHandler, [[NSError alloc] initWithDomain:@"UpdateProfile has existed" code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    UpdateProfile *updateProfile = [[UpdateProfile alloc] initWithFilePath:filePath];
    [self checkAndAddTaskWithProgressProfile:updateProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, error);
        
    } progressBlock:^(NSInteger total, NSInteger index) {
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
        progress.completedUnitCount = index;
        
        BLE_BLOCK_EXEC(progressBlock, progress);
    }];
}

- (void)cancelUpdateFireware {
    [self cleanTaskWithProfileClass:[UpdateProfile class]];
}

// 星历写入
- (void)searchStarWithFilePath:(NSURL *)filePath progressBlock:(void (^)(NSProgress * progress))progressBlock completionHandler:(void(^)(NSError *error))completionHandler {
    
    NSArray *tasks = [self findEqualTaskWithProfileClass:[AGPSProfile class]];
    if ([tasks count] > 0) {
        BLE_BLOCK_EXEC(completionHandler, [[NSError alloc] initWithDomain:@"AGPSProfile has existed" code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    AGPSProfile *agpsProfile = [[AGPSProfile alloc] initWithFilePath:filePath];
    [self checkAndAddTaskWithProgressProfile:agpsProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(completionHandler, error);
        
    } progressBlock:^(NSInteger total, NSInteger index) {
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
        progress.completedUnitCount = index;
        
        BLE_BLOCK_EXEC(progressBlock, progress);
    }];
    
}

- (void)cancelSearchStar {
    
    [self cleanTaskWithProfileClass:[AGPSProfile class]];
}

- (void)restartDevieWithCompletionHandler:(void(^)(NSError *error))completionHandler {

    ResetProfile *profile = [[ResetProfile alloc] init];
    [self checkAndAddTaskWithProfile:profile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        
        BLE_BLOCK_EXEC(completionHandler, error);
    }];
}

#pragma mark - Private 内部处理

- (void)observeBeanManagerState {
    [self.beanManager addObserver:self forKeyPath:@"connectState" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)unobserveBeanManagerState {
    [self.beanManager removeObserver:self forKeyPath:@"connectState"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"connectState"]) {
        // 之前为已连接状态改为连接中状态不处理，这时处理断开重连中
        if (self.connectState == GBConnectState_Connected && self.beanManager.connectState == GBConnectState_Connecting) {
            return;
        }
        // 状态相同不做处理
        if (self.connectState == self.beanManager.connectState) {
            return;
        }
        self.connectState = self.beanManager.connectState;
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Private 任务处理
- (void)checkAndAddTaskWithProfile:(__kindof PacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock {
    
    __weak typeof(self) weakSelf  = self;
    [self.beanManager checkBeaconStateForOpt:^(NSError *error) {
        if (error) {
            BLE_BLOCK_EXEC(serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"bluetooth not connected." code:GattErrors_NotConnected userInfo:nil]);
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addTaskWithProfile:profile serviceBlock:serviceBlock];
        
    }];
    
}

- (void)checkAndAddTaskWithProgressProfile:(__kindof ProgressPacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock progressBlock:(ResultProgressBlock)progressBlock {
    
    __weak typeof(self) weakSelf  = self;
    [self.beanManager checkBeaconStateForOpt:^(NSError *error) {
        if (error) {
            BLE_BLOCK_EXEC(serviceBlock, nil, nil, [[NSError alloc] initWithDomain:@"bluetooth not connected." code:GattErrors_NotConnected userInfo:nil]);
            return;
        }
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf addTaskWithProgressProfile:profile serviceBlock:serviceBlock progressBlock:progressBlock];
        
    }];
    
}

// 添加任务
- (void)addTaskWithProfile:(__kindof PacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock {
    GBPeripheralTask *task = [[GBPeripheralTask alloc] initWithProfile:profile serviceBlock:serviceBlock];
    GBPeripheralTask *sameTask = [self findEqualTask:task];
    // 如果任务已经存在，添加block的监听
    if (sameTask) {
        [sameTask addListenPeripheralTask:serviceBlock];
        return;
    }
    
    task.taskDelegate = self;
    [self.taskList addObject:task];
    [self scheduleNextTask];
}

- (void)addTaskWithProgressProfile:(__kindof ProgressPacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock progressBlock:(ResultProgressBlock)progressBlock {
    GBProgPeripheralTask *task = [[GBProgPeripheralTask alloc] initWithProgressProfile:profile serviceBlock:serviceBlock progress:progressBlock];
    GBProgPeripheralTask *sameTask = (GBProgPeripheralTask *)[self findEqualTask:task];
    // 如果任务已经存在，添加block的监听
    if (sameTask) {
        [sameTask addListenPeripheralTask:serviceBlock];
        [sameTask addListenProgressPeripheralTask:progressBlock];
        return;
    }
    
    task.taskDelegate = self;
    [self.taskList addObject:task];
    [self scheduleNextTask];
}

- (void)addTaskWithProfileNotSchedule:(__kindof PacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock {
    GBPeripheralTask *task = [[GBPeripheralTask alloc] initWithProfile:profile serviceBlock:serviceBlock];
    GBPeripheralTask *sameTask = [self findEqualTask:task];
    // 如果任务已经存在，添加block的监听
    if (sameTask) {
        [sameTask addListenPeripheralTask:serviceBlock];
        return;
    }
    
    task.taskDelegate = self;
    [self.taskList addObject:task];
}

- (void)addTaskWithProgressProfileNotSchedule:(__kindof ProgressPacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock progressBlock:(ResultProgressBlock)progressBlock {
    GBProgPeripheralTask *task = [[GBProgPeripheralTask alloc] initWithProgressProfile:profile serviceBlock:serviceBlock progress:progressBlock];
    GBProgPeripheralTask *sameTask = (GBProgPeripheralTask *)[self findEqualTask:task];
    // 如果任务已经存在，添加block的监听
    if (sameTask) {
        [sameTask addListenPeripheralTask:serviceBlock];
        [sameTask addListenProgressPeripheralTask:progressBlock];
        return;
    }
    
    task.taskDelegate = self;
    [self.taskList addObject:task];
}

// 清除任务
- (void)cleanAllTask {
    // 每个任务都要掉用stoptask，执行block
    for (GBPeripheralTask *peripheralTask in self.taskList) {
        [peripheralTask stopTask];
    }
    
    [self.taskList removeAllObjects];
    [self.currentTask stopTask];
}

- (void)cleanTaskWithProfile:(PacketProfile *)packetProfile {
    for (NSInteger index = self.taskList.count-1; index >=0; index--) {
        GBPeripheralTask *task = self.taskList[index];
        if ([task.profile isEqualProfile:packetProfile]) {
            [task stopTask];
            
            [self.taskList removeObject:task];
        }
    }
    
    if ([self.currentTask.profile isEqualProfile:packetProfile]) {
        [self.currentTask stopTask];
    }
}

- (void)cleanTaskWithProfileClass:(Class)class {
    for (NSInteger index = self.taskList.count-1; index >=0; index--) {
        GBPeripheralTask *task = self.taskList[index];
        if ([[task.profile class] isSubclassOfClass:class]) {
            [task stopTask];
            
            [self.taskList removeObject:task];
        }
    }
    
    if ([[self.currentTask.profile class] isSubclassOfClass:class]) {
        [self.currentTask stopTask];
    }
}

// 任务是否已经存在
- (BOOL)isTaskExist:(__kindof GBPeripheralTask *)peripheralTask {
    for (GBPeripheralTask *task in self.taskList) {
        if ([task isEqualTask:peripheralTask]) {
            return YES;
        }
    }
    
    if ([peripheralTask isEqualTask:self.currentTask]) {
        return YES;
    }
    
    return NO;
}

// 查找任务
- (GBPeripheralTask *)findEqualTask:(__kindof GBPeripheralTask *)peripheralTask {
    for (GBPeripheralTask *task in self.taskList) {
        if ([task isEqualTask:peripheralTask]) {
            return task;
        }
    }
    
    if ([peripheralTask isEqualTask:self.currentTask]) {
        return self.currentTask;
    }
    
    return nil;
}

// 通过类别查找任务列表
- (NSArray *)findEqualTaskWithProfileClass:(Class)class {
    NSMutableArray *array = [NSMutableArray new];
    for (GBPeripheralTask *task in self.taskList) {
        if ([[task.profile class] isSubclassOfClass:class]) {
            [array addObject:task];
        }
    }
    
    if ([[self.currentTask.profile class] isSubclassOfClass:class]) {
        [array addObject:self.currentTask];
    }
    
    return array;
}
    
// 执行下一个任务
- (void)scheduleNextTask {
    if (self.currentTask != nil && self.currentTask.taskState != TaskState_End) {
        return;
    }
    
    self.currentTask = [self.taskList firstObject];
    if (!self.currentTask) {
        return;
    }
    
    // 设置接收peripheral代理的profile
    [self.peripheralImpl setTakeoverProfile:self.currentTask.profile];
    
    [self.taskList removeObjectAtIndex:0];
    [self.currentTask startTask];
}

#pragma mark - GBBeanManagerDelegate
- (void)beanConnectComplete:(GBBeacon *)beacon {
    self.peripheralImpl.peripheral = beacon.peripheral;
    self.peripheralImpl.delegate = self;
    
    //不能用self.mac,可能connectBeaconWithMac还没有赋值
    if (self.singleDelegate && [self.singleDelegate respondsToSelector:@selector(singleManagerConnected:)]) {
        [self.singleDelegate singleManagerConnected:beacon.address];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GBDeviceDidConnectedNotification object:beacon];
}

- (void)beanDisconnectComplete:(GBBeacon *)beacon {
    [self cleanAllTask];
    self.peripheralImpl.peripheral = nil;
    self.peripheralImpl.delegate = nil;
    
    //不能用self.mac,可能已经被disconnectAndClearBeacon置nil
    if (self.singleDelegate && [self.singleDelegate respondsToSelector:@selector(singleManagerDisconnected:)]) {
        [self.singleDelegate singleManagerDisconnected:beacon.address];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GBDeviceDidConnectedNotification object:beacon];
}

#pragma mark - GBPeripheralTaskDelegate
- (void)peripheralTaskStart:(GBPeripheralTask *)peripheralTask {
    GBBleLog(@"peripheralTaskStart");
    
    if (!self.isStartQueue) {
        self.isStartQueue = YES;
        
        if (self.singleDelegate && [self.singleDelegate respondsToSelector:@selector(singleManagerExecuteQueue:)]) {
            [self.singleDelegate singleManagerExecuteQueue:self.macAddr];
        }
    }
}

- (void)peripheralTaskEnd:(GBPeripheralTask *)peripheralTask {
    GBBleLog(@"peripheralTaskEnd");
    
    self.currentTask = nil;
    
    // 设置接收peripheral代理的profile
    [self.peripheralImpl setTakeoverProfile:nil];
    
    if (self.isStartQueue && [self.taskList count] == 0) {
        self.isStartQueue = NO;
        
        if (self.singleDelegate && [self.singleDelegate respondsToSelector:@selector(singleManagerCompleteQueue:)]) {
            [self.singleDelegate singleManagerCompleteQueue:self.macAddr];
        }
        
    } else {
        [self scheduleNextTask];
    }
    
}

#pragma mark - GBDeviceActiveGattDelegate
- (void)deviceActiveGatt:(GattPacket *)gattPacket {
    // 敲击设备
    if (gattPacket.head == PACKET_HEAD && gattPacket.type == GATT_CLICK_DEVICE_PACKET) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deviceActiveClick:clickCount:)]) {
            [self.delegate deviceActiveClick:self.macAddr clickCount:[GattPacket parseDeviceClickGatt:gattPacket.data]];
        }
    }
}

#pragma mark - GBBluetoothCenterManagerDelegate

- (void)didDiscoverBeacon:(GBBeacon *)beacon {
    
    BLE_BLOCK_EXEC(self.scanBeaconHandler, beacon, NO, nil);
}

- (void)didFinishScan {
    
    BLE_BLOCK_EXEC(self.scanBeaconHandler, nil, YES, [[NSError alloc] initWithDomain:@"Bluetooth scan over time" code:BeanErrors_ScanTimeOut userInfo:nil]);
    self.scanBeaconHandler = nil;
    [[GBBluetoothCenterManager sharedCenterManager] removeDelegate:self];
}

@end
