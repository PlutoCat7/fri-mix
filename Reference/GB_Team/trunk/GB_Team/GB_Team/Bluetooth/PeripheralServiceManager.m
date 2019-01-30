//
//  PeripheralServiceManager.m
//  GB_Football
//
//  Created by wsw on 16/8/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PeripheralServiceManager.h"

#import "BatteryVersionDateProfile.h"
#import "AdjustDateProfile.h"
#import "UpdateProfile.h"
#import "SportProfile.h"
#import "SearchProfile.h"
#import "CheckProfile.h"
#import "VersionProfile.h"
#import "SwitchModelProfile.h"
#import "AGPSProfile.h"
#import "CheckGPSProfile.h"
#import "BatteryProfile.h"
#import "ProfileManager.h"
#import "ResetProfile.h"
#import "DeviceVerProfile.h"

#import "GB_Team-Swift.h"

@interface PeripheralTask : NSObject

@property (nonatomic, strong) PacketProfile *profile;
@property (nonatomic, copy) void(^doTask)();

@end

@implementation PeripheralTask

- (instancetype)initWithProfile:(PacketProfile *)profile doTask:(void(^)())doTask {
    
    if(self=[super init]){
        _profile = profile;
        _doTask = doTask;
    }
    return self;
}

- (void)startTask {
    
    [self.profile startTask];
    BLOCK_EXEC(self.doTask);
}

- (void)endTask {
    
    [self.profile stopTask];
}

- (void)stopTask {
    
    [self.profile stopTask];
    self.doTask = nil;
}

@end

@interface PeripheralServiceManager ()<
DFUServiceDelegate,
DFUProgressDelegate,
DFUPeripheralSelectorDelegate>

@property (nonatomic, strong) BatteryVersionDateProfile *batteryVersionDateProfile;
@property (nonatomic, strong) AdjustDateProfile *adjustDateProfile;
@property (nonatomic, strong) UpdateProfile *updateProfile;
@property (nonatomic, strong) SportProfile *sportProfile;
@property (nonatomic, strong) SearchProfile *searchProfile;
@property (nonatomic, strong) CheckProfile *checkProfile;
@property (nonatomic, strong) VersionProfile *versionProfile;
@property (nonatomic, strong) SwitchModelProfile *switchModelProfile;
@property (nonatomic, strong) AGPSProfile *AGPSProfile;
@property (nonatomic, strong) CheckGPSProfile *checkGPSProfile;
@property (nonatomic, strong) BatteryProfile *batteryProfile;
@property (nonatomic, strong) DeviceVerProfile *deviceVersionProfile;
@property (nonatomic, strong) ResetProfile *restartProfile;
@property (nonatomic, strong) ProfileManager *profileManager;

@property (nonatomic, assign) BOOL isPeripheralSyncData;
@property (nonatomic, strong) NSMutableArray<PeripheralTask *> *taskList;
@property (nonatomic, strong) PeripheralTask *currentTask;

//dfu升级
@property (nonatomic, strong) DFUServiceController *dfuServiceController;
@property (nonatomic, copy) ReadProgressBlock dfuProgressBlock;
@property (nonatomic, copy) WriteServiceBlock dfuCompleteBlock;

@end

@implementation PeripheralServiceManager

- (void)dealloc
{
    [self cleanPeripheralTask];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskList = [NSMutableArray arrayWithCapacity:1];
        _profileManager = [[ProfileManager alloc] init];
        self.checkProfile = [CheckProfile new];
        self.batteryVersionDateProfile = [BatteryVersionDateProfile new];
        self.adjustDateProfile = [AdjustDateProfile new];
        self.updateProfile = [UpdateProfile new];
        self.sportProfile = [SportProfile new];
        self.searchProfile = [SearchProfile new];
        self.switchModelProfile = [SwitchModelProfile new];
        self.versionProfile = [VersionProfile new];
        self.checkGPSProfile = [CheckGPSProfile new];
        self.AGPSProfile = [AGPSProfile new];
        self.batteryProfile = [BatteryProfile new];
        self.deviceVersionProfile = [DeviceVerProfile new];
        self.restartProfile = [ResetProfile new];
        
        [self.profileManager addProfileWithArray:@[self.checkProfile, self.batteryVersionDateProfile, self.adjustDateProfile, self.updateProfile, self.sportProfile, self.searchProfile, self.versionProfile, self.switchModelProfile, self.AGPSProfile, self.checkGPSProfile, self.batteryProfile, self.deviceVersionProfile, self.restartProfile]];
    }
    return self;
}

#pragma mark - Public

- (NSInteger)doingTaskCount {
    
    return self.taskList.count;
}

- (void)cleanPeripheralTask {
    
    [self.currentTask stopTask];
    for (PeripheralTask *task in self.taskList) {
        [task stopTask];
    }
    [self.taskList removeAllObjects];
    self.isPeripheralSyncData = NO;
    
    [self.profileManager cleanTask];
    
    //清除dfu升级
    [self cleanDFUUPdate];
}

- (void)readBatteryVersionDate:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.batteryVersionDateProfile doTask:^{
        
        @strongify(self)
        [self.batteryVersionDateProfile readBatteryVersionDate:^(id data, NSError *error) {
            NSArray *resultArray = data;
            if (error || resultArray.count != 3) {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, nil, [NSError errorWithDomain:@"读取失败" code:GattErrors_PaserFail userInfo:nil]);
            }else {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, resultArray, nil);
            }
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)readBattery:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.batteryProfile doTask:^{
        @strongify(self)
        [self.batteryProfile readBattery:^(id data, NSError *error) {
            if (error) {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, nil, [NSError errorWithDomain:LS(@"bluetooth.read.fail") code:GattErrors_PaserFail userInfo:nil]);
            }else {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, data, nil);
            }
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)readDeviceVersion:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.deviceVersionProfile readDeviceVersion:^(id data, NSError *error) {
            if (error) {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, nil, [NSError errorWithDomain:LS(@"bluetooth.read.fail") code:GattErrors_PaserFail userInfo:nil]);
            }else {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, data, nil);
            }
        }];
    };
    [self addTaskWithProfile:self.deviceVersionProfile block:block];
}

- (void)readVersion:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.versionProfile doTask:^{
        
        @strongify(self)
        [self.versionProfile readVersion:^(id data, NSError *error) {
            if (error) {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, nil, [NSError errorWithDomain:@"读取失败" code:GattErrors_PaserFail userInfo:nil]);
            }else {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, data, nil);
            }
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)adjustDate:(WriteServiceBlock)serviceBlock {

    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.adjustDateProfile doTask:^{
        
        @strongify(self)
        [self.adjustDateProfile adjustDate:[NSDate date] serviceBlock:^(NSError *error) {
            [self completeCurrentTask];
            BLOCK_EXEC(serviceBlock, error);
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)searchWrist:(ReadServiceBlock)serviceBlock {

    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.searchProfile doTask:^{
        
        @strongify(self)
        [self.searchProfile searchWrist:^(id data, NSError *error) {
            [self completeCurrentTask];
            BLOCK_EXEC(serviceBlock, data, error);
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)readSportModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock {
    
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.sportProfile doTask:^{
        
        @strongify(self)
        [self.sportProfile sendSportProfile:month day:day progressBlock:progressBlock serviceBlock:^(id data, id sourceData, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, sourceData, error);
            [self completeCurrentTask];
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)cancelSportModelData {
    
    NSMutableArray *deleteTask = [NSMutableArray arrayWithCapacity:1];
    for (PeripheralTask *task in self.taskList) {
        if (task.profile == self.sportProfile) {
            [task stopTask];
            [deleteTask addObject:task];
        }
    }
    [self.taskList removeObjectsInArray:deleteTask];
    
    if (self.currentTask.profile == self.sportProfile) {
        [self.currentTask stopTask];
        [self completeCurrentTask];
    }
}

- (void)updateFireware:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock isNeedDfu:(BOOL)isNeedDfu manager:(CBCentralManager *)manager {
    
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.updateProfile doTask:^{
        
        @strongify(self)
        if (isNeedDfu) {
            if (![[filePath pathExtension] isEqualToString:@"zip"]) {
                BLOCK_EXEC(serviceBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
                return;
            }
            DFUFirmware *selectedFirmware = [[DFUFirmware alloc] initWithUrlToZipFile:filePath];
            if (!selectedFirmware) {
                BLOCK_EXEC(serviceBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
                return;
            }
            self.dfuProgressBlock = progressBlock;
            self.dfuCompleteBlock = serviceBlock;
            DFUServiceInitiator *initiator = [[[DFUServiceInitiator alloc] initWithCentralManager:manager target:self.iBeacon.peripheral] withFirmware:selectedFirmware];
            initiator.delegate = self;
            initiator.progressDelegate = self;
            initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = YES;
            initiator.peripheralSelector = self;
            self.dfuServiceController = [initiator start];
        }else {
            if (![[filePath pathExtension] isEqualToString:@"img"]) {
                BLOCK_EXEC(serviceBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
                return;
            }
            [self.updateProfile sendUpdateProfile:filePath serviceBlock:^(NSError *error) {
                [self completeCurrentTask];
                BLOCK_EXEC(serviceBlock, error);
            } progressBlock:progressBlock];
        }
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)switchModelWithIndx:(NSInteger)index serviceBlock:(WriteServiceBlock)serviceBlock {
    
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.switchModelProfile doTask:^{
        @strongify(self)
        [self.switchModelProfile switchModelWithIndx:index serviceBlock:^(NSError *error) {
            [self completeCurrentTask];
            BLOCK_EXEC(serviceBlock, error);
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)searchStartProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock {
    
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.AGPSProfile doTask:^{
        @strongify(self)
        [self.AGPSProfile doAGPSProfile:filePath serviceBlock:^(NSError *error) {
            [self completeCurrentTask];
            BLOCK_EXEC(serviceBlock, error);
        } progressBlock:progressBlock];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)cancelSearchStar {
    
    NSMutableArray *deleteTask = [NSMutableArray arrayWithCapacity:1];
    for (PeripheralTask *task in self.taskList) {
        if (task.profile == self.AGPSProfile) {
            [task stopTask];
            [deleteTask addObject:task];
        }
    }
    [self.taskList removeObjectsInArray:deleteTask];
    
    if (self.currentTask.profile == self.AGPSProfile) {
        [self.currentTask stopTask];
        [self completeCurrentTask];
    }
}

- (void)checkGPSWithServiceBlock:(ReadServiceBlock)serviceBlock {
    
    if (self.isPeripheralSyncData) {  //正在做其他的蓝牙任务
        BLOCK_EXEC(serviceBlock, @(4), nil);
        return;
    }
    @weakify(self)
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:self.checkGPSProfile doTask:^{
        @strongify(self)
        [self.checkGPSProfile checkGPSWithServiceBlock:^(id data, NSError *error) {
            [self completeCurrentTask];
            BLOCK_EXEC(serviceBlock, data, error);
        }];
    }];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

- (void)restartWrist:(WriteServiceBlock)serviceBlock {

    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.restartProfile resetWithserviceBlock:^(NSError *error) {
            [self completeCurrentTask];
            BLOCK_EXEC(serviceBlock, error);
        }];
    };
    [self addTaskWithProfile:self.restartProfile block:block];
}

#pragma mark - Private

//添加蓝牙任务
- (void)addTaskWithProfile:(__kindof PacketProfile *)profile block:(void(^)())block {
    
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:profile doTask:block];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
}

//取消蓝牙任务
- (void)cancelTaskWithProfile:(__kindof PacketProfile *)profile {
    
    NSMutableArray *tmpList = [self.taskList mutableCopy];
    for (PeripheralTask *task in tmpList) {
        if (task.profile == profile) {
            [task stopTask];
            [self.taskList removeObject:task];
        }
    }
    
    if (self.currentTask.profile == profile) {
        [self.currentTask stopTask];
        [self completeCurrentTask];
    }
}

- (void)doPeripheralSyncData {
    
    if (self.isPeripheralSyncData) {
        return;
    }
    self.currentTask = [self.taskList firstObject];
    if (!self.currentTask) {
        return;
    }
    self.isPeripheralSyncData = YES;
    [self.taskList removeObjectAtIndex:0];
    [self.currentTask startTask];
}

- (void)completeCurrentTask {
    
    [self.currentTask endTask];
    self.currentTask = nil;
    self.isPeripheralSyncData = NO;
    
    //下一个任务
    [self doPeripheralSyncData];
}

#pragma mark - Getter and Setter

- (void)setIBeacon:(iBeaconInfo *)iBeacon {
    
    _iBeacon = iBeacon;
    [self cleanPeripheralTask];
    self.profileManager.peripheral = iBeacon.peripheral;
}

#pragma mark - DFU  Delegate

- (void)cleanDFUUPdate {
    
    //清除dfu升级
    if (self.dfuServiceController) {
        [self.dfuServiceController abort];
        self.dfuCompleteBlock = nil;
        self.dfuProgressBlock = nil;
    }
}

- (void)dfuStateDidChangeTo:(enum DFUState)state {
    
    switch (state) {
        case DFUStateCompleted:
            BLOCK_EXEC(self.dfuCompleteBlock, nil);
            [self cleanDFUUPdate];
            break;
        case DFUStateUploading:
            break;
            
        default:
            break;
    }
}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message {
    
    //if (//error) {
        GBLog(@"dfu update fail:%td", error);
        BLOCK_EXEC(self.dfuCompleteBlock, [NSError errorWithDomain:LS(@"bluetooth.write.fail") code:GattErrors_PaserFail userInfo:nil]);
    [self cleanDFUUPdate];
    //}
}

- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond {
    
    BLOCK_EXEC(self.dfuProgressBlock, progress*1.0/100);
    GBLog(@"平均固件写入速度:%lf bit", avgSpeedBytesPerSecond);
}

//切换到dfu模式， 扫描设备时的回调
- (BOOL)select:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    return YES;
}

- (NSArray<CBUUID *> * _Nullable)filterByHint:(CBUUID * _Nonnull)dfuServiceUUID {
    
    return @[[CBUUID UUIDWithString:@"FE59"]];
}

@end
