//
//  SystemRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SystemRequest.h"
#import "NetworkManager.h"
#import "GBBluetoothManager.h"


@implementation SystemRequest

+ (void)checkAppVersion:(RequestCompleteHandler)handler {
    
    NSString *bundlerId = [Utility appBundleIdentifier];
    NSString *versionCode = [@([Utility appVersionCode]) stringValue];
    //versionCode = @"5";
    NSDictionary *parameters = @{@"pkg":bundlerId,
                                 @"vcode":versionCode};
    
    [self POST:@"apk_up_grade_controller/doupgrade" parameters:parameters responseClass:[ApkUpdateResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            ApkUpdateResponseInfo *info = (ApkUpdateResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 检查 固件更新
+ (void)checkFirewareUpgrade:(RequestCompleteHandler)handler {
    
    NSString *vname = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.firewareVersion;
    NSString *version = [GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.deviceVersion;
    //vname = @"0.1";
    NSDictionary *parameters = @{@"vname":vname?vname:@"",
                                 @"version":version?version:@""};
    
    [self POST:@"fireware_up_grade_controller/doupgrade" parameters:parameters responseClass:[FirewareUpdateResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            FirewareUpdateResponeInfo *info = (FirewareUpdateResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 下载固件
+ (void)downloadFirewareFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress {
    
    [self downloadFile:fileUrl handler:^(id result, NSError *error) {
        if (error ) {
            error = makeError(ActionType_ShowError, LS(@"firmware.label.failed"));
        }
        if (handler) {
            handler(result, error);
        }
    } progress:progress];
}

const NSInteger maxretryDownloadAGPSCount = 5;
+ (void)doAGPSFile:(CGFloat)lon lat:(CGFloat)lat alt:(CGFloat)alt pacc:(CGFloat)pacc handler:(RequestCompleteHandler)handler {
    
#warning 暂时默认99999
    pacc = 99999.000000;
    NSString *url = nil;
    if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal_S) {
        url = [NSString stringWithFormat:@"https://online-live2.services.u-blox.com/GetOnlineData.ashx?token=auJrZm6U6k-kVDDk_7Y9_w;gnss=gps;datatype=eph;lat=%f;lon=%f;alt=%f;pacc=%f;filteronpos", lat, lon, alt, pacc];
    }else if ([GBBluetoothManager sharedGBBluetoothManager].iBeaconObj.t_goal_Version == iBeaconVersion_T_Goal){
        url = [NSString stringWithFormat:@"https://online-live2.services.u-blox.com/GetOnlineData.ashx?token=auJrZm6U6k-kVDDk_7Y9_w;gnss=gps;datatype=eph;lat=%f;lon=%f;alt=%f;pacc=%f;filteronpos;format=aid", lat, lon, alt, pacc];
    }
    NSString *keepBackUrl = [url stringByReplacingOccurrencesOfString:@"live2" withString:@"live1"];
    __block NSInteger retryDownloadAGPSCount = 0;
    __block NSURLSessionDownloadTask *downloadTask = nil;
    __block RequestCompleteHandler complete = [handler copy];
    NSTimer *taskTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f block:^(NSTimer *timer) { //5秒内未下载成功， 重新请求
        retryDownloadAGPSCount++;
        if (retryDownloadAGPSCount >= maxretryDownloadAGPSCount) {
            [timer invalidate];
        }else {
            GBLog(@"重新下载星历");
            [downloadTask cancel];
        }
        GBLog(@"星历重启下载次数：%td", retryDownloadAGPSCount);
        downloadTask = [self downloadAGPSFile:url handler:^(id result, NSError *error) {
            [timer invalidate];
            if (error) {
                [self downloadAGPSFile:keepBackUrl handler:complete progress:nil];
            }else {
                BLOCK_EXEC(complete, result, nil);
                complete = nil;
            }
        } progress:nil];
        
    } repeats:YES];
    [taskTimer fire];
    
}

+ (NSURLSessionDownloadTask *)downloadAGPSFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress {
    
    return [self downloadFile:fileUrl handler:^(id result, NSError *error) {
        if (handler) {
            handler(result, error);
        }
    } progress:progress];
}

// 设备绑定和解绑接口
+ (void)bindWristband:(NSString *)wristbandMark handler:(RequestCompleteHandler)handler {
    
    wristbandMark = !wristbandMark?@"0":wristbandMark;
    NSDictionary *parameters = @{@"number":wristbandMark};
    
    [self POST:@"user_bind_wrist_band_controller/dobindwristband" parameters:parameters responseClass:[BindWristbandResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BindWristbandResponseInfo *info = (BindWristbandResponseInfo *)result;
            info.data.number = wristbandMark;
            [RawCacheManager sharedRawCacheManager].userInfo.wristbandInfo = info.data;
            BLOCK_EXEC(handler, info.data.mac, nil);
        }
    }];
}

+ (void)resetWristbandName:(NSString *)newName handler:(RequestCompleteHandler)handler {
    
    newName = [NSString stringIsNullOrEmpty:newName]?@"":newName;
    NSDictionary *parameters = @{@"hand_name":newName};
    
    [self POST:@"equipment_manage_controller/douphandequipname" parameters:parameters responseClass:[BindWristbandResponseInfo class] handler:^(id result, NSError *error) {

        BLOCK_EXEC(handler, nil, error);
    }];
}

// 云配置
+ (void)getCloudConfig:(RequestCompleteHandler)handler {
    [self POST:@"config_manage_controller/getClientConfigList" parameters:nil responseClass:[AppConfigResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            AppConfigResponseInfo *info = (AppConfigResponseInfo *)result;
            [RawCacheManager sharedRawCacheManager].appConfigInfo = info.data;
            
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)wristbandListFilter:(NSArray *)macList handler:(RequestCompleteHandler)handler {
    
    if (!macList || macList.count==0) {
        return;
    }
    
    NSMutableString *macs = [NSMutableString string];
    for (NSString *mac in macList){
        if ([NSString stringIsNullOrEmpty:macs]) {
            [macs appendString:mac];
        } else {
            [macs appendFormat:@",%@", mac];
        }
    }
    NSDictionary *parameters = @{@"macs":[macs copy]};
    [self POST:@"equipment_filter_controller/dofilter" parameters:parameters responseClass:[WristbandFilterResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            WristbandFilterResponseInfo *info = (WristbandFilterResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getSplashInfoWithHandler:(RequestCompleteHandler)handler {
    
    [self POST:@"splash_info_controller/dogetinfo" parameters:nil responseClass:[SplashResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            SplashResponseInfo *info = (SplashResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)sendFeedbackWithType:(FeedbackType)type message:(NSString *)message handler:(RequestCompleteHandler)handler {
    
    message = [NSString stringIsNullOrEmpty:message]?@"":message;
    NSDictionary *parameters = @{@"type":@(type),
                                 @"message":message};
    
    [self POST:@"feedback_manage_controller/doaddfeedback" parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}


#pragma mark - Private 

+ (NSURLSessionDownloadTask *)downloadFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress {
    
    handler = [handler copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    NSURLSessionDownloadTask *downloadTask = [[NetworkManager downloadManager] downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
        BLOCK_EXEC(progress, (CGFloat)downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    }destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (handler) {
            handler(filePath, error);
        }
    }];
    
    [downloadTask resume];
    return downloadTask;
}

@end
