//
//  GBMultiBleManager.m
//  GB_BlueSDK
//
//  Created by gxd on 16/12/16.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "GBMultiBleManager.h"
#import "GBBluetoothCenterManager.h"

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


@interface GBSingleBleManager(Extend)

- (instancetype)initWithMac:(NSString *)mac;

- (void)addTaskWithProfileNotSchedule:(__kindof PacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock;
- (void)addTaskWithProgressProfileNotSchedule:(__kindof ProgressPacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock progressBlock:(ResultProgressBlock)progressBlock;

- (NSArray *)findEqualTaskWithProfileClass:(Class)class;

- (void)scheduleNextTask;

@end

@interface GBMultiBleManager() <GBSingleManagerDelegate, GBDeviceActiveDelegate>

@property (nonatomic, strong) NSMutableArray<GBSingleBleManager *> *runningTaskList;
@property (nonatomic, strong) NSMutableArray<GBSingleBleManager *> *waitTaskList;
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation GBMultiBleManager

// 单例模式
+ (GBMultiBleManager *)sharedMultiBleManager {
    static dispatch_once_t once;
    static GBMultiBleManager *instance;
    dispatch_once(&once, ^{
        instance = [[GBMultiBleManager alloc] init];
    });
    return instance;
}

- (void)startWithDefault {
    // 这里做环境变量的配置，现在没有用
}

- (instancetype)init {
    if (self = [super init]) {
        _runningTaskList = [NSMutableArray arrayWithCapacity:1];
        _waitTaskList = [NSMutableArray arrayWithCapacity:1];
        _maxCount = 3;
        
        [[GBBluetoothCenterManager sharedCenterManager] initConfig];
    }
    
    return self;
}

- (void)resetMultiBleManager {
    
    for (GBSingleBleManager *singleBleManager in self.runningTaskList) {
        [singleBleManager disconnectAndClearBeacon:nil];
    }
    [self.runningTaskList removeAllObjects];
    [self.waitTaskList removeAllObjects];
}

#pragma mark - Public 处理业务
//电量
- (void)readBatteryWithMac:(NSString *)mac handler:(void(^)(NSInteger battery, NSError *error))handler {
    
    BatteryProfile *batteryProfile = [[BatteryProfile alloc] init];
    [self addTaskToSingleManager:mac profile:batteryProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        if (error) {
            BLE_BLOCK_EXEC(handler, 0, error);
        } else {
            BLE_BLOCK_EXEC(handler, [parseData integerValue], error);
        }
    }];
}

//读日期
- (void)readDate:(NSString *)mac handler:(void(^)(NSDate *date, NSError *error))handler {
    
    FirewareDateProfile *dateProfile = [[FirewareDateProfile alloc] init];
    [self addTaskToSingleManager:mac profile:dateProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, parseData, error);
    }];
}

//读固件版本
- (void)readFirmwareVer:(NSString *)mac handler:(void(^)(NSString *version, NSError *error))handler {

    FirewareVerProfile *firewareVerProfile = [[FirewareVerProfile alloc] init];
    [self addTaskToSingleManager:mac profile:firewareVerProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, parseData, error);
        
    }];
}

//读硬件版本
- (void)readDeviceVer:(NSString *)mac handler:(void(^)(NSString *version, NSError *error))handler {

    DeviceVerProfile *deviceVerProfile = [[DeviceVerProfile alloc] init];
    [self addTaskToSingleManager:mac profile:deviceVerProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, parseData, error);
        
    }];
}

//检查模式
- (void)checkModel:(NSString *)mac handler:(void(^)(BleModel model, NSError *error))handler {
    
    CheckModelProfile *checkModelProfile = [[CheckModelProfile alloc] init];
    [self addTaskToSingleManager:mac profile:checkModelProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, (BleModel)[parseData integerValue], error);
    }];
}

//切换模式
- (void)switchModel:(NSString *)mac model:(BleModel)model handler:(void(^)(NSError *error))handler {
    
    SwitchModelProfile *switchModelProfile = [[SwitchModelProfile alloc] initWithModel:model];
    [self addTaskToSingleManager:mac profile:switchModelProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, error);
    }];
}

//检查gps状态
- (void)checkGpsState:(NSString *)mac handler:(void(^)(BleGpsState state, NSError *error))handler {
    
    CheckGPSProfile *checkGPSProfile = [[CheckGPSProfile alloc] init];
    [self addTaskToSingleManager:mac profile:checkGPSProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, (BleGpsState)[parseData integerValue], error);
    }];
}

//找手环
- (void)findDevice:(NSString *)mac findState:(BleFindState)findState handler:(void(^)(NSError *error))handler {
    
    FindDeviceProfile *findDeviceProfile = [[FindDeviceProfile alloc] initWithFindState:findState];
    [self addTaskToSingleManager:mac profile:findDeviceProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, error);
    }];
}

// 读取多天普通模式的基本数据记录
- (void)readMutableCommonModelData:(NSString *)mac date:(NSArray<NSDate *> *)dateArray handler:(void(^)(id data, NSError *error))handler {
    
    DailyMutableProfile *dailyProfile = [[DailyMutableProfile alloc] initWithMultiDate:dateArray];
    [self addTaskToSingleManager:mac profile:dailyProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, parseData, error);
    }];
}

- (void)cancelMutableCommonModelData:(NSString *)mac date:(NSArray<NSDate *> *)dateArray {

    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    if (singleBleManager) {
        [singleBleManager cancelReadCommonDataWithDateList:dateArray];
    }
}

// 读取某日运动模式的基本数据记录
- (void)readSportModelData:(NSString *)mac handler:(void(^)(id data, id originalData, NSError *error))handler  progressBlock:(void (^)(CGFloat progress))progressBlock {
    
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    NSArray *tasks = [singleBleManager findEqualTaskWithProfileClass:[SportProfile class]];
    if ([tasks count] > 0) {
        BLE_BLOCK_EXEC(handler, nil, nil, [[NSError alloc] initWithDomain:@"SportProfile has existed" code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    // month,day都为0是读手环里的当前数据
    SportProfile *sportProfile = [[SportProfile alloc] initWithDate:0 day:0];
    [self addProgressTaskToSingleManager:mac profile:sportProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(handler, parseData, sourceData, error);
        
    } progressBlock:^(NSInteger total, NSInteger index) {
        
        BLE_BLOCK_EXEC(progressBlock, (index*1.0)/total);
    }];
}

- (void)cancelSportModelData:(NSString *)mac {
    
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    if (singleBleManager) {
        [singleBleManager cancelReadMatchData];
    }
}

// 固件升级
- (void)updateFireware:(NSString *)mac filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(NSProgress *progress))progressBlock {
    
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    NSArray *tasks = [singleBleManager findEqualTaskWithProfileClass:[UpdateProfile class]];
    if ([tasks count] > 0) {
        BLE_BLOCK_EXEC(complete, [[NSError alloc] initWithDomain:@"UpdateProfile has existed" code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    UpdateProfile *updateProfile = [[UpdateProfile alloc] initWithFilePath:filePath];
    [self addProgressTaskToSingleManager:mac profile:updateProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(complete, error);
        
    } progressBlock:^(NSInteger total, NSInteger index) {
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
        progress.completedUnitCount = index;
        
        BLE_BLOCK_EXEC(progressBlock, progress);
    }];
}

- (void)cancelUpdateFireware:(NSString *)mac {
    
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    if (singleBleManager) {
        [singleBleManager cancelUpdateFireware];
    }
    
}

// 星历写入
- (void)searchStar:(NSString *)mac filePath:(NSURL *)filePath complete:(void(^)(NSError *error))complete progressBlock:(void (^)(NSProgress * progress))progressBlock {
    
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    NSArray *tasks = [singleBleManager findEqualTaskWithProfileClass:[AGPSProfile class]];
    if ([tasks count] > 0) {
        BLE_BLOCK_EXEC(complete, [[NSError alloc] initWithDomain:@"AGPSProfile has existed" code:GattErrors_OperateFail userInfo:nil]);
        return;
    }
    
    AGPSProfile *agpsProfile = [[AGPSProfile alloc] initWithFilePath:filePath];
    [self addProgressTaskToSingleManager:mac profile:agpsProfile serviceBlock:^(id parseData, id sourceData, NSError *error) {
        BLE_BLOCK_EXEC(complete, error);
        
    } progressBlock:^(NSInteger total, NSInteger index) {
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:total];
        progress.completedUnitCount = index;
        
        BLE_BLOCK_EXEC(progressBlock, progress);
    }];
}

- (void)cancelSearchStar:(NSString *)mac {
    
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    if (singleBleManager) {
        [singleBleManager cancelSearchStar];
    }
    
}

#pragma mark - Private 任务处理
- (void)addTaskToSingleManager:(NSString *)mac profile:(PacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock {
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    if (singleBleManager) {
        [singleBleManager addTaskWithProfileNotSchedule:profile serviceBlock:serviceBlock];
        
    } else {
        singleBleManager = [[GBSingleBleManager alloc] initWithMac:mac];
        singleBleManager.delegate = self;
        singleBleManager.singleDelegate = self;
        [singleBleManager addTaskWithProfileNotSchedule:profile serviceBlock:serviceBlock];
        
        [self.waitTaskList addObject:singleBleManager];
        [self scheduleNextSingleBleManager];
    }
}

- (void)addProgressTaskToSingleManager:(NSString *)mac profile:(ProgressPacketProfile *)profile serviceBlock:(ResultServiceBlock)serviceBlock progressBlock:(ResultProgressBlock)progressBlock {
    GBSingleBleManager *singleBleManager = [self findSingleBleManager:mac];
    if (singleBleManager) {
        [singleBleManager addTaskWithProgressProfileNotSchedule:profile serviceBlock:serviceBlock progressBlock:progressBlock];
        
    } else {
        singleBleManager = [[GBSingleBleManager alloc] initWithMac:mac];
        singleBleManager.delegate = self;
        singleBleManager.singleDelegate = self;
        [singleBleManager addTaskWithProgressProfileNotSchedule:profile serviceBlock:serviceBlock progressBlock:progressBlock];
        
        [self.waitTaskList addObject:singleBleManager];
        [self scheduleNextSingleBleManager];
    }
    
}

// 是否能找到singleblemanager
- (GBSingleBleManager *)findSingleBleManager:(NSString *)mac {
    for (GBSingleBleManager *singleBleManager in self.runningTaskList) {
        if ([mac isEqualToString:singleBleManager.macAddr]) {
            return singleBleManager;
        }
    }
    
    for (GBSingleBleManager *singleBleManager in self.waitTaskList) {
        if ([mac isEqualToString:singleBleManager.macAddr]) {
            return singleBleManager;
        }
    }
    
    return nil;
}

// 执行下一个singleblemanager的任务
- (void)scheduleNextSingleBleManager {
    if ([self.runningTaskList count] == self.maxCount || [self.waitTaskList count] == 0) {
        return;
    }
    
    GBSingleBleManager *singleBleManager = self.waitTaskList[0];
    [self.waitTaskList removeObjectAtIndex:0];
    
    __weak typeof(self) weakSelf  = self;
    [singleBleManager connectBeaconWithMac:singleBleManager.macAddr connectHandle:^(GBBeacon *beacon, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!error) {
            [strongSelf.runningTaskList addObject:singleBleManager];
            
            [singleBleManager scheduleNextTask];
            
        } else {
            [strongSelf scheduleNextSingleBleManager];
        }
    }];
}

#pragma mark - GBSingleManagerDelegate
- (void)singleManagerConnected:(NSString *)mac {
    
}

- (void)singleManagerDisconnected:(NSString *)mac {
    for (GBSingleBleManager *singleBleManager in self.runningTaskList) {
        if ([mac isEqualToString:singleBleManager.macAddr]) {
            [self.runningTaskList removeObject:singleBleManager];
            break;
        }
    }
    
    [self scheduleNextSingleBleManager];
}

- (void)singleManagerCompleteQueue:(NSString *)mac {
    // 任务列表执行完成直接退出就可以，是否执行下一个singleblemanager由singleManagerDisconnected决定
    for (GBSingleBleManager *singleBleManager in self.runningTaskList) {
        if ([mac isEqualToString:singleBleManager.macAddr]) {
            [singleBleManager disconnectAndClearBeacon:nil];
            break;
        }
    }
}

@end
