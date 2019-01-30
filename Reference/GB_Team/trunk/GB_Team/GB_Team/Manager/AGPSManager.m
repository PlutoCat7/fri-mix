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

typedef void(^doAGPSBlock) (NSURL *filePath);

@interface AGPSManager ()

@property (nonatomic, strong) NSURL *AGPSFilePath;
@property (nonatomic, strong) NSURL *lipiAGPSFilePath;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) BOOL isDownloadingLiPi;
@property (nonatomic, strong) NSMutableArray *AGPSTaskList;
@property (nonatomic, strong) NSMutableArray *lipiAGPSTaskList;

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
        _AGPSTaskList = [NSMutableArray arrayWithCapacity:1];
        _lipiAGPSTaskList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Public

- (void)startAGPSWithMac:(NSString *)mac complete:(void(^)(NSString *mac, NSError *error))complete {
    
    doAGPSBlock block = ^(NSURL *filePath){
        
        if (!filePath) {
            BLOCK_EXEC(complete, mac, [NSError errorWithDomain:@"加速失败" code:0 userInfo:nil]);
            return;
        }
        
        [[GBMultiBleManager sharedMultiBleManager] searchStar:mac filePath:filePath complete:^(NSError *error) {
            if (error) {
                GBLog(@"写入星历失败");
                //星历写入失败， 手环继续搜星
                BLOCK_EXEC(complete, mac, error);
                return ;
            }else {
                GBLog(@"写入星历成功");
                BLOCK_EXEC(complete, mac, nil);
            }
        } progressBlock:nil];
    };
    
    [[GBMultiBleManager sharedMultiBleManager] readDeviceVer:mac handler:^(NSString *version, NSError *error) {
        
        if (error) {
            //星历写入失败， 手环继续搜星
            BLOCK_EXEC(complete, mac, [NSError errorWithDomain:@"加速失败" code:0 userInfo:nil]);
        }else {
            iBeaconVersion versionType = [LogicManager beaconVersionWithVersionString:version];
            if (versionType == iBeaconVersion_T_Goal) {
                if (self.AGPSFilePath) {
                    block(self.AGPSFilePath);
                }else {
                    [self.AGPSTaskList addObject:block];
                    if (!self.isDownloading) {
                        self.isDownloading = YES;
                        GBLog(@"开始定位");
                        //获取经纬度，下载星历文件
                        SNLocationManager *snLocationManager = [SNLocationManager shareLocationManager];
                        [snLocationManager startUpdatingLocationWithComplete:^(CLLocation *location, CLPlacemark *placemark, NSError *error) {
                            
                            //定位失败， 不用下载星历， 手环继续搜星
                            if (error) {
                                for (doAGPSBlock block in self.AGPSTaskList) {
                                    block(nil);
                                }
                                [self.AGPSTaskList removeAllObjects];
                                self.isDownloading = NO;
                                return;
                            }
                            GBLog(@"当前经纬度：%@", location);
                            GBLog(@"结束定位");
                            GBLog(@"开始下载星历");
                            __block CGFloat beginTime = CFAbsoluteTimeGetCurrent();
                            [SystemRequest doAGPSFile:location.coordinate.longitude lat:location.coordinate.latitude alt:location.altitude pacc:location.horizontalAccuracy version:versionType handler:^(id result, NSError *error) {
                                
                                self.isDownloading = NO;
                                GBLog(@"结束下载星历");
                                NSURL *filePath = result;
                                GBLog(@"星历文件下载%@", [NSString stringWithFormat:@"持续时间:%f", CFAbsoluteTimeGetCurrent()-beginTime]);
                                if (error || [NSString stringIsNullOrEmpty:filePath.absoluteString]) {
                                    for (doAGPSBlock block in self.AGPSTaskList) {
                                        block(nil);
                                    }
                                    [self.AGPSTaskList removeAllObjects];
                                }else {
                                    self.AGPSFilePath = filePath;
                                    for (doAGPSBlock block in self.AGPSTaskList) {
                                        block(filePath);
                                    }
                                    [self.AGPSTaskList removeAllObjects];
                                }
                            }];
                            
                        }];
                    }
                }
            }else if (versionType == iBeaconVersion_T_Goal_S) {
                if (self.lipiAGPSFilePath) {
                    block(self.lipiAGPSFilePath);
                }else {
                    [self.lipiAGPSTaskList addObject:block];
                    if (!self.isDownloadingLiPi) {
                        self.isDownloadingLiPi = YES;
                        GBLog(@"开始定位");
                        //获取经纬度，下载星历文件
                        SNLocationManager *snLocationManager = [SNLocationManager shareLocationManager];
                        [snLocationManager startUpdatingLocationWithComplete:^(CLLocation *location, CLPlacemark *placemark, NSError *error) {
                            
                            //定位失败， 不用下载星历， 手环继续搜星
                            if (error) {
                                for (doAGPSBlock block in self.lipiAGPSTaskList) {
                                    block(nil);
                                }
                                [self.lipiAGPSTaskList removeAllObjects];
                                self.isDownloadingLiPi = NO;
                                return;
                            }
                            GBLog(@"当前经纬度：%@", location);
                            GBLog(@"结束定位");
                            GBLog(@"开始下载星历");
                            __block CGFloat beginTime = CFAbsoluteTimeGetCurrent();
                            [SystemRequest doAGPSFile:location.coordinate.longitude lat:location.coordinate.latitude alt:location.altitude pacc:location.horizontalAccuracy version:versionType handler:^(id result, NSError *error) {
                                
                                self.isDownloadingLiPi = NO;
                                GBLog(@"结束下载星历");
                                NSURL *filePath = result;
                                GBLog(@"星历文件下载%@", [NSString stringWithFormat:@"持续时间:%f", CFAbsoluteTimeGetCurrent()-beginTime]);
                                if (error || [NSString stringIsNullOrEmpty:filePath.absoluteString]) {
                                    for (doAGPSBlock block in self.lipiAGPSTaskList) {
                                        block(nil);
                                    }
                                    [self.lipiAGPSTaskList removeAllObjects];
                                }else {
                                    self.lipiAGPSFilePath = filePath;
                                    for (doAGPSBlock block in self.lipiAGPSTaskList) {
                                        block(filePath);
                                    }
                                    [self.lipiAGPSTaskList removeAllObjects];
                                }
                            }];
                            
                        }];
                    }
                }
            }
        }
    }];
}

- (void)cancelAGPSWithMac:(NSString *)mac {
    
    [[GBMultiBleManager sharedMultiBleManager] cancelSearchStar:mac];
}

- (void)cleanAGPSFile {
    
    [[NSFileManager defaultManager] removeItemAtURL:self.AGPSFilePath error:nil];
    self.AGPSFilePath = nil;
    [self.AGPSTaskList removeAllObjects];
    
    [[NSFileManager defaultManager] removeItemAtURL:self.lipiAGPSFilePath error:nil];
    self.lipiAGPSFilePath = nil;
    [self.lipiAGPSTaskList removeAllObjects];
}

- (void)checkAGPSStateWithMac:(NSString *)mac complete:(void(^)(NSString *mac, BleGpsState state))complete {
    
    [[GBMultiBleManager sharedMultiBleManager] checkGpsState:mac handler:^(BleGpsState state, NSError *error) {
        
        if (!error) {
            BLOCK_EXEC(complete, mac, state);
        }
    }];
}

@end
