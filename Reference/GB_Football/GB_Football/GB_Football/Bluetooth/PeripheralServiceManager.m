//
//  PeripheralServiceManager.m
//  GB_Football
//
//  Created by wsw on 16/8/11.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PeripheralServiceManager.h"

#import "BatteryVersionProfile.h"
#import "BatteryProfile.h"
#import "AdjustDateProfile.h"
#import "UpdateProfile.h"
#import "DailyMutableProfile.h"
#import "SportProfile.h"
#import "AGPSProfile.h"
#import "CheckProfile.h"
#import "CheckModelProfile.h"
#import "SwitchModelProfile.h"
#import "CheckGPSProfile.h"
#import "SearchProfile.h"
#import "ProfileManager.h"
#import "ResetProfile.h"
#import "CloseProfile.h"
#import "DeviceVerProfile.h"
#import "DailySportMutableProfile.h"
#import "RunProfile.h"
#import "RunTimeProfile.h"
#import "RunCleanProfile.h"

#import "PeripheralTask.h"

@interface PeripheralServiceManager ()

@property (nonatomic, strong) CheckProfile *checkProfile;
@property (nonatomic, strong) BatteryVersionProfile *batteryVersionProfile;
@property (nonatomic, strong) BatteryProfile *batteryProfile;
@property (nonatomic, strong) AdjustDateProfile *adjustDateProfile;
@property (nonatomic, strong) UpdateProfile *updateProfile;
@property (nonatomic, strong) DailyMutableProfile *dailyProfile;
@property (nonatomic, strong) DailySportMutableProfile *dailySportProfile;
@property (nonatomic, strong) SportProfile *sportProfile;
@property (nonatomic, strong) AGPSProfile *AGPSProfile;
@property (nonatomic, strong) CheckModelProfile *checkModelProfile;
@property (nonatomic, strong) SwitchModelProfile *switchModelProfile;
@property (nonatomic, strong) CheckGPSProfile *checkGPSProfile;
@property (nonatomic, strong) SearchProfile *searchProfile;
@property (nonatomic, strong) DeviceVerProfile *deviceVersionProfile;
@property (nonatomic, strong) ResetProfile *restartProfile;
@property (nonatomic, strong) CloseProfile *closeProfile;
@property (nonatomic, strong) RunProfile *runProfile;
@property (nonatomic, strong) RunTimeProfile *runTimeProfile;
@property (nonatomic, strong) RunCleanProfile *runCleanProfile;
@property (nonatomic, strong) ProfileManager *profileManager;

@property (nonatomic, assign) BOOL isPeripheralSyncData;
@property (nonatomic, strong) NSMutableArray<PeripheralTask *> *taskList;
@property (nonatomic, strong) PeripheralTask *currentTask;

@end

@implementation PeripheralServiceManager

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskList = [NSMutableArray arrayWithCapacity:1];
        _profileManager = [[ProfileManager alloc] init];
        self.checkProfile = [CheckProfile new];
        self.batteryVersionProfile = [BatteryVersionProfile new];
        self.batteryProfile = [BatteryProfile new];
        self.adjustDateProfile = [AdjustDateProfile new];
        self.updateProfile = [UpdateProfile new];
        self.dailyProfile = [DailyMutableProfile new];
        self.sportProfile = [SportProfile new];
        self.AGPSProfile = [AGPSProfile new];
        self.checkModelProfile = [CheckModelProfile new];
        self.switchModelProfile = [SwitchModelProfile new];
        self.searchProfile = [SearchProfile new];
        self.checkGPSProfile = [CheckGPSProfile new];
        self.deviceVersionProfile = [DeviceVerProfile new];
        self.restartProfile = [ResetProfile new];
        self.closeProfile = [CloseProfile new];
        self.dailySportProfile = [DailySportMutableProfile new];
        self.runProfile = [RunProfile new];
        self.runTimeProfile = [RunTimeProfile new];
        self.runCleanProfile = [RunCleanProfile new];
        [self.profileManager addProfileWithArray:@[self.checkProfile, self.batteryVersionProfile, self.batteryProfile, self.adjustDateProfile, self.updateProfile, self.dailyProfile, self.sportProfile, self.AGPSProfile, self.checkModelProfile, self.switchModelProfile, self.checkGPSProfile, self.searchProfile, self.deviceVersionProfile, self.restartProfile, self.closeProfile, self.dailySportProfile, self.runProfile, self.runTimeProfile, self.runCleanProfile]];
    }
    return self;
}

#pragma mark - Public

- (void)cleanPeripheralTask {
    
    [self.currentTask stopTask];
    for (PeripheralTask *task in self.taskList) {
        [task stopTask];
    }
    [self.taskList removeAllObjects];
    self.isPeripheralSyncData = NO;
    
    [self.profileManager cleanTask];
}

- (void)readBatteryVersion:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.batteryVersionProfile readBatteryVersion:^(id data, NSError *error) {
            NSArray *resultArray = data;
            if (error || resultArray.count != 2) {
                BLOCK_EXEC(serviceBlock, nil, [NSError errorWithDomain:LS(@"bluetooth.read.fail") code:GattErrors_PaserFail userInfo:nil]);
                [self completeCurrentTask];
            }else {
                BLOCK_EXEC(serviceBlock, resultArray, nil);
                [self completeCurrentTask];
            }
        }];
    };
    [self addTaskWithProfile:self.batteryVersionProfile block:block];
}

- (void)readBattery:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
   void(^block)() = ^{
        @strongify(self)
        [self.batteryProfile readBattery:^(id data, NSError *error) {
            if (error) {
                BLOCK_EXEC(serviceBlock, nil, [NSError errorWithDomain:LS(@"bluetooth.read.fail") code:GattErrors_PaserFail userInfo:nil]);
                [self completeCurrentTask];
            }else {
                BLOCK_EXEC(serviceBlock, data, nil);
                [self completeCurrentTask];
            }
        }];
    };
    [self addTaskWithProfile:self.batteryProfile block:block];
}

- (void)readDeviceVersion:(ReadMultiServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.deviceVersionProfile readDeviceVersion:^(id data, NSError *error) {
            if (error) {
                BLOCK_EXEC(serviceBlock, nil, @(self.profileManager.ibeaconVersion), [NSError errorWithDomain:LS(@"bluetooth.read.fail") code:error.code userInfo:nil]);
                [self completeCurrentTask];
            }else {
                BLOCK_EXEC(serviceBlock, data, @(self.profileManager.ibeaconVersion), nil);
                [self completeCurrentTask];
            }
        }];
    };
    [self addTaskWithProfile:self.deviceVersionProfile block:block];
}

- (void)adjustDate:(WriteServiceBlock)serviceBlock {

    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.adjustDateProfile adjustDate:[[NSDate date] dateComponentsWithGMT8] serviceBlock:^(NSError *error) {
            BLOCK_EXEC(serviceBlock, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.adjustDateProfile block:block];
}

- (void)readMutableCommonModelData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.dailyProfile sendMutableDailyProfile:date serviceBlock:^(id data, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, error);
            [self completeCurrentTask];
        }];
    };
    
    PeripheralTask *task = [self addTaskWithProfile:self.dailyProfile block:block];
    task.taskLevel = level;
}

- (void)cancelMutableCommonModelData {
    
    [self cancelTaskWithProfile:self.dailyProfile];
}

- (void)readMutableSportStepData:(NSArray *)date level:(GBBluetoothTask_PRIORITY_Level)level serviceBlock:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.dailySportProfile sendMutableDailyProfile:date serviceBlock:^(id data, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, error);
            [self completeCurrentTask];
        }];
    };
    
    PeripheralTask *task = [self addTaskWithProfile:self.dailySportProfile block:block];
    task.taskLevel = level;
}

- (void)cancelMutableSportStepData {
    
    [self cancelTaskWithProfile:self.dailySportProfile];
}

- (void)readSportModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.sportProfile sendSportProfile:month day:day progressBlock:progressBlock serviceBlock:^(id data, id sourceData, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, sourceData, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.sportProfile block:block];
}

- (void)cancelSportModelData {
    
    [self cancelTaskWithProfile:self.sportProfile];
}

- (void)updateFireware:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock {
    
    if (self.currentTask.profile == self.updateProfile) {
        return;
    }
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.updateProfile sendUpdateProfile:filePath serviceBlock:^(NSError *error) {
            BLOCK_EXEC(serviceBlock, error);
            [self completeCurrentTask];
        } progressBlock:progressBlock];
    };
    [self addTaskWithProfile:self.updateProfile block:block];
}

- (void)searchStartProfile:(NSURL *)filePath serviceBlock:(WriteServiceBlock)serviceBlock progressBlock:(ReadProgressBlock)progressBlock {
    
    if (self.currentTask.profile == self.AGPSProfile) {
        return;
    }
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.AGPSProfile doAGPSProfile:filePath serviceBlock:^(NSError *error) {
            BLOCK_EXEC(serviceBlock, error);
            [self completeCurrentTask];
        } progressBlock:progressBlock];
    };
    [self addTaskWithProfile:self.AGPSProfile block:block];
}

- (void)cancelSearchStar {
    
    [self cancelTaskWithProfile:self.AGPSProfile];
}

- (void)checkModelWithServiceBlock:(ReadServiceBlock)serviceBlock {

    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.checkModelProfile checkModelWithServiceBlock:^(id data, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.checkModelProfile block:block];
}

- (void)switchModelWithIndx:(NSInteger)index serviceBlock:(WriteServiceBlock)serviceBlock {

    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.switchModelProfile switchModelWithIndx:index serviceBlock:^(NSError *error) {
            BLOCK_EXEC(serviceBlock, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.switchModelProfile block:block];
}

- (void)checkGPSWithServiceBlock:(ReadServiceBlock)serviceBlock {
    
    if (self.isPeripheralSyncData) {  //正在做其他的蓝牙任务
        return;
    }
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.checkGPSProfile checkGPSWithServiceBlock:^(id data, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.checkGPSProfile block:block];
}

- (void)forceCheckGPSWithServiceBlock:(ReadServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.checkGPSProfile checkGPSWithServiceBlock:^(id data, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.checkGPSProfile block:block];
}

- (void)searchWrist:(ReadServiceBlock)serviceBlock isStart:(BOOL)isStart {
    
    @weakify(self)
    void(^block)() = ^{
        
        @strongify(self)
        [self.searchProfile searchWrist:^(id data, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, error);
            [self completeCurrentTask];
        } isStart:isStart];
    };
    [self addTaskWithProfile:self.searchProfile block:block];
}

- (void)restartWrist:(WriteServiceBlock)serviceBlock
{
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.restartProfile resetWithserviceBlock:^(NSError *error) {
            BLOCK_EXEC(serviceBlock, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.restartProfile block:block];
}

- (void)closeWrist:(WriteServiceBlock)serviceBlock {
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.closeProfile closeWithserviceBlock:^(NSError *error) {
            BLOCK_EXEC(serviceBlock, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.closeProfile block:block];
}

- (void)readRunModelData:(NSInteger)month day:(NSInteger)day progressBlock:(ReadProgressBlock)progressBlock serviceBlock:(ReadMultiServiceBlock)serviceBlock {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.runProfile readRunDataWithMonth:month day:day progressBlock:progressBlock serviceBlock:^(id data, id sourceData, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, sourceData, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.runProfile block:block];
}

- (void)cancelRunModelData {
    
    [self cancelTaskWithProfile:self.runProfile];
}

- (void)readRunTime:(ReadServiceBlock)serviceBlock level:(GBBluetoothTask_PRIORITY_Level)level {
    
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.runTimeProfile readRunTime:^(id data, NSError *error) {
            if (error) {
                BLOCK_EXEC(serviceBlock, nil, [NSError errorWithDomain:LS(@"bluetooth.read.fail") code:GattErrors_PaserFail userInfo:nil]);
                [self completeCurrentTask];
            }else {
                BLOCK_EXEC(serviceBlock, data, nil);
                [self completeCurrentTask];
            }
        }];
    };
    PeripheralTask *task = [self addTaskWithProfile:self.runTimeProfile block:block];
    task.taskLevel = level;
}

- (void)cleanRunData:(ReadServiceBlock)serviceBlock
{
    @weakify(self)
    void(^block)() = ^{
        @strongify(self)
        [self.runCleanProfile cleanData:^(id data, NSError *error) {
            BLOCK_EXEC(serviceBlock, data, error);
            [self completeCurrentTask];
        }];
    };
    [self addTaskWithProfile:self.runCleanProfile block:block];
}

- (NSString *)getErrorUUIDs {
    
    return [self.profileManager getErrorUUIDs];
}

#pragma mark - Private

//添加蓝牙任务
- (PeripheralTask *)addTaskWithProfile:(__kindof PacketProfile *)profile block:(void(^)())block {
    
    PeripheralTask *task = [[PeripheralTask alloc] initWithProfile:profile doTask:block];
    [self.taskList addObject:task];
    [self doPeripheralSyncData];
    
    return task;
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
    PeripheralTask *willTask = [self.taskList firstObject];
    if (!willTask) {
        return;
    }
    NSInteger willIndex = 0;
    for (NSInteger i=1; i<self.taskList.count; i++) {
        PeripheralTask *tmp = self.taskList[i];
        if (tmp.taskLevel>willTask.taskLevel) {
            willTask = tmp;
            willIndex = i;
        }
    }
    self.currentTask =willTask;
    self.isPeripheralSyncData = YES;
    [self.taskList removeObjectAtIndex:willIndex];
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

- (void)setPeripheral:(CBPeripheral *)peripheral {
    
    _peripheral = peripheral;
    [self cleanPeripheralTask];  //clean旧的蓝牙任务
    
    self.profileManager.peripheral = peripheral;
}

@end
