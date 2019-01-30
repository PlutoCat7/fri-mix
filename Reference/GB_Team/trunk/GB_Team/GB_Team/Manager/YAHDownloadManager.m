//
//  GBDownloadManager.m
//  GB_Team
//
//  Created by 王时温 on 2017/3/23.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHDownloadManager.h"
#import "CacheManager.h"
#import "YHURLSessionManager.h"

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface YAHDownloadManager ()

@property (nonatomic, strong) NSMutableDictionary *URLCallbacks;
@property (nonatomic, strong) CacheManager *cacheManager;
@property (nonatomic, strong) YHURLSessionManager *downloader;

@end

@implementation YAHDownloadManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [[YAHDownloadManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cacheManager = [[CacheManager alloc] initWithCacheName:@"GBDownloadManager_Cache"];
        _URLCallbacks = [NSMutableDictionary dictionaryWithCapacity:1];
        _downloader = [[YHURLSessionManager alloc] init];
    }
    return self;
}

- (void)donwloadWithUrl:(NSString *)url complete:(DownloadCompleteHandler)complete {
    
    [self donwloadWithUrl:url progress:nil complete:complete];
}

- (void)donwloadWithUrl:(NSString *)url progress:(DownloadProgressHandler)progress complete:(DownloadCompleteHandler)complete {
    
    //检查URL有效性
    if (!([url isKindOfClass:NSString.class] && url.length>0)) {
        if (complete) {
            complete(nil, [NSError errorWithDomain:@"url is empty" code:0 userInfo:nil]);
        }
        return;
    }
    NSURL *fileUrl = [NSURL URLWithString:url];
    if (!fileUrl) {
        if (complete) {
            complete(nil, [NSError errorWithDomain:@"url is empty" code:0 userInfo:nil]);
        }
        return;
    }
    
    //检查是否已下载
    NSURL *filePath = (NSURL *)[self.cacheManager objectForKey:[url MD5]];
    if (filePath) {
        if (complete) {
            filePath = [YAHDownloadManager downloadFilePath:filePath];
            complete(filePath, nil);
        }
        return;
    }
    
    //下载
    
    __weak typeof(self) weakSelf  = self;
    [self addProgressCallback:progress completedBlock:complete forURL:fileUrl createCallback:^{
        
        NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
        NSURLSessionDownloadTask *task = [weakSelf.downloader downloadTaskWithRequest:request progress:^(int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite, double progress) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return ;
            }
            NSArray *callbacksForURL;
            callbacksForURL = [strongSelf.URLCallbacks[fileUrl] copy];
            for (NSDictionary *callbacks in callbacksForURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DownloadProgressHandler callback = callbacks[kProgressCallbackKey];
                    if (callback) callback(progress);
                });
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

            return [YAHDownloadManager downloadFilePath:fileUrl];
        } completionHandler:^(NSURLSessionTask * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return ;
            }
            NSArray *callbacksForURL;
            callbacksForURL = [strongSelf.URLCallbacks[fileUrl] copy];
            for (NSDictionary *callbacks in callbacksForURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DownloadCompleteHandler callback = callbacks[kCompletedCallbackKey];
                    if (callback) callback(filePath, error);
                });
            }
            [strongSelf.URLCallbacks removeObjectForKey:fileUrl];
            
            //缓存住
            [strongSelf.cacheManager setObject:filePath forKey:[url MD5]];
        }];
        
        [task resume];
    }];
}

#pragma mark - Private

- (void)addProgressCallback:(DownloadProgressHandler)progressBlock completedBlock:(DownloadCompleteHandler)completedBlock forURL:(NSURL *)url createCallback:(DownloadNoParamsBlock)createCallback {
    
    if (!url) {
        BLOCK_EXEC(completedBlock, nil, nil);
        return;
    }
    BOOL first = NO;
    if (!self.URLCallbacks[url]) {
        self.URLCallbacks[url] = [NSMutableArray new];
        first = YES;
    }
    
    // Handle single download of simultaneous download request for the same URL
    NSMutableArray *callbacksForURL = self.URLCallbacks[url];
    NSMutableDictionary *callbacks = [NSMutableDictionary new];
    if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
    if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
    [callbacksForURL addObject:callbacks];
    self.URLCallbacks[url] = callbacksForURL;
    
    if (first) {
        createCallback();
    }
}

+ (NSURL *)downloadFilePath:(NSURL *)url {
    
    NSString *fileName = [url lastPathComponent];
    NSString *folderName =@"YAHDownload";
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *optionPath = [documentPath stringByAppendingPathComponent:folderName];
    if (![fm fileExistsAtPath:optionPath]) {
        [fm createDirectoryAtPath:optionPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", optionPath, fileName]];
}


@end
