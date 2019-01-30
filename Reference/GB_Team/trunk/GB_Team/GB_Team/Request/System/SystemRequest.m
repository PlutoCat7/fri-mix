//
//  SystemRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SystemRequest.h"
#import "NetworkManager.h"

@implementation SystemRequest

+ (void)checkAppVersion:(RequestCompleteHandler)handler {
    
    NSString *bundlerId = [Utility appBundleIdentifier];
    NSString *versionCode = [@([Utility appVersionCode]) stringValue];
    NSDictionary *parameters = @{@"pkg":bundlerId,
                                 @"vcode":versionCode};
    
    [self POST:@"apk/upgrade" parameters:parameters responseClass:[ApkUpdateResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            ApkUpdateResponseInfo *info = (ApkUpdateResponseInfo *)result;
            BLOCK_EXEC(handler, info.data.apkUrl, nil);
        }
    }];
}

// 检查 固件更新
+ (void)checkFirewareUpgrade:(NSString *)version deviceVersion:(NSString *)deviceVersion handler:(RequestCompleteHandler)handler {
    
    NSString *vname = version;
    NSDictionary *parameters = @{@"vname":vname?vname:@"",
                                 @"version":deviceVersion?deviceVersion:@""};
    
    [self POST:@"fireware/upgrade" parameters:parameters responseClass:[FirewareUpdateResponeInfo class] handler:^(id result, NSError *error) {
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
    
    handler = [handler copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    NSURLSessionDownloadTask *downloadTask = [[NetworkManager downloadManager] downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
    
        BLOCK_EXEC(progress, (CGFloat)downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    }destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error && handler) {
            handler(nil, makeError(ActionType_ShowError, LS(@"固件下载失败，请检查网络连接")));
            
        } else if (handler) {
            handler(filePath, nil);
        }
    }];
    
    [downloadTask resume];
}

// 设备绑定和解绑接口
+ (void)bindWristband:(NSString *)wristbandMark handler:(RequestCompleteHandler)handler {
    
    wristbandMark = !wristbandMark?@"":wristbandMark;
    NSDictionary *parameters = @{@"number":wristbandMark};
    
    [self POST:@"wristband/bind" parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)unbindWristband:(NSArray<NSString *> *)bindWristband_ids handler:(RequestCompleteHandler)handler {
    
    NSString *wristbandStr = @"";
    for (NSString *str in bindWristband_ids) {
        if ([wristbandStr isEqualToString:@""]) {
            wristbandStr = [NSString stringWithFormat:@"%@", str];
        } else {
            wristbandStr = [NSString stringWithFormat:@"%@,%@", wristbandStr, str];
        }
    }
    NSDictionary *parameters = @{@"order_ids":wristbandStr};
    
    [self POST:@"wristband/delbinds" parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getBindWristbandListWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"wristband/getlist";
    
    [self POST:urlString parameters:nil responseClass:[BindWristbandListResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BindWristbandListResponeInfo *info = (BindWristbandListResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

static NSInteger retryDownloadAGPSCount = 0;
const NSInteger maxretryDownloadAGPSCount = 5;
+ (void)doAGPSFile:(CGFloat)lon lat:(CGFloat)lat alt:(CGFloat)alt pacc:(CGFloat)pacc version:(iBeaconVersion)version handler:(RequestCompleteHandler)handler {
    
#warning 暂时默认99999
    pacc = 99999.000000;
    NSString *url = nil;
    if (version == iBeaconVersion_T_Goal_S) {
        url = [NSString stringWithFormat:@"https://online-live2.services.u-blox.com/GetOnlineData.ashx?token=auJrZm6U6k-kVDDk_7Y9_w;gnss=gps;datatype=eph;lat=%f;lon=%f;alt=%f;pacc=%f;filteronpos", lat, lon, alt, pacc];
    }else if (version == iBeaconVersion_T_Goal){
        url = [NSString stringWithFormat:@"https://online-live2.services.u-blox.com/GetOnlineData.ashx?token=auJrZm6U6k-kVDDk_7Y9_w;gnss=gps;datatype=eph;lat=%f;lon=%f;alt=%f;pacc=%f;filteronpos;format=aid", lat, lon, alt, pacc];
    }
    NSAssert(url, @"url错误");
    NSString *keepBackUrl = [url stringByReplacingOccurrencesOfString:@"live2" withString:@"live1"];
    retryDownloadAGPSCount = 0;
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

#pragma mark - Private

+ (NSURLSessionDownloadTask *)downloadAGPSFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress {
    
    return [self downloadFile:fileUrl handler:^(id result, NSError *error) {
        if (handler) {
            handler(result, error);
        }
    } progress:progress];
}

+ (NSURLSessionDownloadTask *)downloadFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress {
    
    handler = [handler copy];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    
    NSURLSessionDownloadTask *downloadTask = [[NetworkManager downloadManager] downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
        BLOCK_EXEC(progress, (CGFloat)downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    }destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[fileUrl MD5]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (handler) {
            handler(filePath, error);
        }
    }];
    
    [downloadTask resume];
    return downloadTask;
}

@end
