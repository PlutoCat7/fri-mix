//
//  AGPSManager.m
//  GB_Football
//
//  Created by 王时温 on 2016/11/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "AGPSManager.h"
#import "SNLocationManager.h"
#import "SystemRequest.h"

@interface AGPSManager ()

@property (nonatomic, strong) NSTimer *step2Timer;   //监听切换足球模式是否成功， 检测GPS是否启动
@property (nonatomic, assign, getter=isDoingAGPS) BOOL doingAGPS;

@end

@implementation AGPSManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[AGPSManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = iBeaconStatus_Unknow;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindiBeaconSuccess) name:Notification_ConnectSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBindiBeaconSuccess) name:Notification_CancelConenctSuccess object:nil];
    }
    return self;
}

- (void)reset {
    
    self.progressStatus = AGPSProgressStatus_Unknow;
    self.status = iBeaconStatus_Normal;
    [self.step2Timer invalidate];
}

#pragma mark - Public

- (void)enterFootballModel:(void(^)(NSError *error))block {
    
    if (self.status == iBeaconStatus_Run_Entering ||
        self.status == iBeaconStatus_Run) {
        BLOCK_EXEC(block, [NSError errorWithDomain:LS(@"run.model.run_tips") code:0 userInfo:nil]);
        return;
    }
    if (self.status == iBeaconStatus_Searching ||
        self.status == iBeaconStatus_Sport) {  //正处于足球模式
        if (self.progressStatus == AGPSProgressStatus_DownAGPS ||
            self.progressStatus == AGPSProgressStatus_WriteAGPS) { //正在写入
            //触发kvo
            self.progressStatus = self.progressStatus;
            BLOCK_EXEC(block, nil);
        }else {  //重新写入星历
            [self downloadAGPSFile];
            BLOCK_EXEC(block, nil);
        }
        return;
    }
    
    GBLog(@"开始切换足球模式");
    @weakify(self)
    [[GBBluetoothManager sharedGBBluetoothManager] switchModel:BlueSwitchModel_Sport complete:^(NSError *error) {
        
        @strongify(self)
        if (!error) { //切换足球模式
            GBLog(@"成功切换足球模式");
            self.status = iBeaconStatus_Searching;
            [self downloadAGPSFile];
        }else {
            error = makeError(error.code, error.code==SwitchModelCode_Charging?LS(@"agprs.toast.charge.enter"):error.domain);
        }
        BLOCK_EXEC(block, error);
    }];
}

- (void)enterRunModel:(void(^)(NSError *error))block {

    if (self.status == iBeaconStatus_Searching ||
        self.status == iBeaconStatus_Sport) {
        BLOCK_EXEC(block, [NSError errorWithDomain:LS(@"run.model.football_tips") code:0 userInfo:nil]);
        return;
    }
    if (self.status == iBeaconStatus_Run_Entering ||
        self.status == iBeaconStatus_Run) {  //正处于跑步模式
        if (self.progressStatus == AGPSProgressStatus_DownAGPS ||
            self.progressStatus == AGPSProgressStatus_WriteAGPS) { //正在写入
            //触发kvo
            self.progressStatus = self.progressStatus;
            BLOCK_EXEC(block, nil);
        }else {  //重新写入星历
            [self downloadAGPSFile];
            BLOCK_EXEC(block, nil);
        }
        return;
    }
    
    GBLog(@"开始切换跑步模式");
    @weakify(self)
    [[GBBluetoothManager sharedGBBluetoothManager] switchModel:BlueSwitchModel_Run complete:^(NSError *error) {
        
        @strongify(self)
        if (!error) { //切换足球模式
            GBLog(@"成功切换跑步模式");
            self.status = iBeaconStatus_Run_Entering;
            [self downloadAGPSFile];
        }else {
            error = makeError(error.code, error.code==SwitchModelCode_Charging?LS(@"run.model.charge.enter"):error.domain);
        }
        BLOCK_EXEC(block, error);
    }];
}

//取消加速搜星
- (void)cancelAGPS:(void(^)(NSError *error))block {
    
    if (self.progressStatus == AGPSProgressStatus_WriteAGPS) {
        [[GBBluetoothManager sharedGBBluetoothManager] cancelSearchStar];
    }
    [self leaveAGPS:block];
}

//退出足球模式
- (void)leaveAGPS:(void(^)(NSError *error))block {
    
    [[GBBluetoothManager sharedGBBluetoothManager] switchModel:BlueSwitchModel_Normal complete:^(NSError *error) {
        if (!error) {
            [self reset];
        }else {
            NSString *errMsg = (self.status == iBeaconStatus_Run||self.status==iBeaconStatus_Run_Entering)?LS(@"run.model.charge.quit"):LS(@"agprs.toast.charge.quit");
            error = makeError(error.code, error.code==SwitchModelCode_Charging?errMsg:error.domain);
        }
        block(error);
    }];
    
}

#pragma mark - NSNotification

- (void)bindiBeaconSuccess {
    
    [self.yah_KVOController observe:[GBBluetoothManager sharedGBBluetoothManager].iBeaconObj keyPath:@"status" block:^(id observer, id object, NSDictionary *change) {
        
        iBeaconStatus status = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.status;
        if (status == iBeaconStatus_Sport ||
            status == iBeaconStatus_Run) {
            self.progressStatus = AGPSProgressStatus_Success;
        }else if((status == iBeaconStatus_Searching ||status == iBeaconStatus_Run_Entering) &&
                 self.progressStatus == AGPSProgressStatus_Unknow) { //连接成功时发现正处于搜星状态，自动写入星历
            if (status == iBeaconStatus_Searching) {
                [self enterFootballModel:^(NSError *error) {
                    if (error) {//失败处理
                        self.progressStatus = AGPSProgressStatus_Searching;
                    }
                }];
            }else if (status == iBeaconStatus_Run_Entering) {
                [self enterRunModel:^(NSError *error) {
                    if (error) {//失败处理
                        self.progressStatus = AGPSProgressStatus_Searching;
                    }
                }];
            }
        }else if ((self.status == iBeaconStatus_Searching || self.status == iBeaconStatus_Run_Entering) &&
                  status == iBeaconStatus_Normal &&
                  (self.progressStatus == AGPSProgressStatus_DownAGPS ||
                  self.progressStatus == AGPSProgressStatus_WriteAGPS ||
                  self.progressStatus == AGPSProgressStatus_Searching)){  //针对一代手环，被手环强制切回日常模式
                      
            self.progressStatus = AGPSProgressStatus_Failure;
        }else if (status == iBeaconStatus_Normal) {
            if (self.progressStatus == AGPSProgressStatus_Success) {
                self.progressStatus = AGPSProgressStatus_Unknow;
            }
        }
        self.status = status;
    }];
}

- (void)cancelBindiBeaconSuccess {
    
    if (_progressStatus == AGPSProgressStatus_Searching ||
        _progressStatus == AGPSProgressStatus_DownAGPS ||
        _progressStatus == AGPSProgressStatus_WriteAGPS) {
        self.progressStatus = AGPSProgressStatus_Failure;
    }else {
        self.progressStatus = AGPSProgressStatus_Unknow;
    }
    
    self.status = iBeaconStatus_Unknow;
}

#pragma mark - Private 

- (void)downloadAGPSFile {
    
    self.progressStatus = AGPSProgressStatus_DownAGPS;
    GBLog(@"开始定位");
    //获取经纬度，下载星历文件
    SNLocationManager *snLocationManager = [SNLocationManager shareLocationManager];
    snLocationManager.isReGeocode = NO;
    [snLocationManager startUpdatingLocationWithComplete:^(CLLocation *location, CLPlacemark *placemark,NSError *error) {
        
        //定位失败， 不用下载星历， 手环继续搜星
        if (error) {
            self.progressStatus = AGPSProgressStatus_Searching;
            return;
        }
        GBLog(@"当前经纬度：%@", location);
        GBLog(@"结束定位");
        GBLog(@"开始下载星历");
        if (!self.isDoingAGPS) {
            GBLog(@"AGPS已退出");
            return;
        }
        __block CGFloat beginTime = CFAbsoluteTimeGetCurrent();
        [SystemRequest doAGPSFile:location.coordinate.longitude lat:location.coordinate.latitude alt:location.altitude pacc:location.horizontalAccuracy handler:^(id result, NSError *error) {
            
            GBLog(@"结束下载星历");
            NSURL *filePath = result;
            GBLog(@"星历文件下载%@", [NSString stringWithFormat:@"持续时间:%f", CFAbsoluteTimeGetCurrent()-beginTime]);
            if (!self.isDoingAGPS) {
                GBLog(@"AGPS已退出");
                return;
            }
            if (error || [NSString stringIsNullOrEmpty:filePath.absoluteString]) {
                //星历下载失败， 手环继续搜星
                self.progressStatus = AGPSProgressStatus_Searching;
                return ;
            }else {
                //步骤1成功
                self.progressStatus = AGPSProgressStatus_WriteAGPS;
                if (self.status == iBeaconStatus_Searching ||
                    self.status == iBeaconStatus_Run_Entering) {
                    self.progressStatus = AGPSProgressStatus_WriteAGPS;
                    [self writeAGPSFile:filePath];
                }else {  //切换中， 等待手环GPS模块启动
                    self.step2Timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
                        if (self.status == iBeaconStatus_Searching ||
                            self.status == iBeaconStatus_Run_Entering) {
                            [self writeAGPSFile:filePath];
                            [timer invalidate];
                        }else if (self.status == iBeaconStatus_Sport ||
                                  self.status == iBeaconStatus_Run) {
                            self.progressStatus = AGPSProgressStatus_Success;
                            [timer invalidate];
                        }
                    } repeats:YES];
                }
            }
        }];
    }];
}

- (void)writeAGPSFile:(NSURL *)filePath {
    
    @weakify(self)
    GBLog(@"开始写入星历");
    [[GBBluetoothManager sharedGBBluetoothManager] searchStar:filePath complete:^(NSError *error) {
        GBLog(@"结束写入星历");
        @strongify(self)
        if (!self.isDoingAGPS) {
            GBLog(@"AGPS已退出");
            return;
        }
        if (error) {
            //星历写入失败， 手环继续搜星
            self.progressStatus = AGPSProgressStatus_Searching;
            return ;
        }else {
            //步骤二成功, 等待搜星成功
            self.progressStatus = AGPSProgressStatus_Searching;
        }
    } progressBlock:nil];
}

#pragma mark - Setter and Getter

- (void)setProgressStatus:(AGPSProgressStatus)progressStatus {
    
    _progressStatus = progressStatus;
    if (progressStatus == AGPSProgressStatus_DownAGPS ||
        progressStatus == AGPSProgressStatus_WriteAGPS ||
        progressStatus == AGPSProgressStatus_Searching) {
        self.doingAGPS = YES;
    }else {
        self.doingAGPS = NO;
    }
}

@end
