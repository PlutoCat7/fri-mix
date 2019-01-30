//
//  NetworkManager.m
//  GB_Football
//
//  Created by weilai on 16/7/6.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

+ (void)initManager:(NetworkManager *)networkManager withIsJSONRequest:(BOOL)isJSONRequest;
+ (void)updateManager:(NetworkManager *)networkManager;

@end

@implementation NetworkManager

+ (NetworkManager *)sharedNetworkManager {
    
    static NetworkManager *sharedNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedNetworkManager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:ServerAPIBaseURL]];
                      [self initManager:sharedNetworkManager withIsJSONRequest:NO];
                  });
    [self updateManager:sharedNetworkManager];
    return sharedNetworkManager;
}

+ (NetworkManager *)uploadImageManager {
    
    static NetworkManager *uploadImageNetworkManager = nil;
    static dispatch_once_t uploadImageOnceToken;
    dispatch_once(&uploadImageOnceToken, ^
                  {
                      uploadImageNetworkManager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:ServerAPIBaseURL]];
                      [self initManager:uploadImageNetworkManager withIsJSONRequest:NO];
                  });
    [self updateManager:uploadImageNetworkManager];
    return uploadImageNetworkManager;
}

+ (NetworkManager *)downloadManager {
    
    static NetworkManager *downloadNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      downloadNetworkManager = [[NetworkManager alloc] initWithSessionConfiguration:configuration];
                      [self initManager:downloadNetworkManager withIsJSONRequest:NO];
                  });
    [self updateManager:downloadNetworkManager];
    return downloadNetworkManager;
}

// 初始化网络管理器
+ (void)initManager:(NetworkManager *)networkManager withIsJSONRequest:(BOOL)isJSONRequest {
    
    if (networkManager == nil) {
        return;
    }
    
    NSString *localUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"Device-Id"];
    if (localUUID == nil || localUUID.length == 0) {
        localUUID = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:localUUID forKey:@"Device-Id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    networkManager.requestSerializer = isJSONRequest ? [[AFJSONRequestSerializer alloc] init] : [[AFHTTPRequestSerializer alloc] init];
    [networkManager.requestSerializer setValue:localUUID forHTTPHeaderField:@"Device-Id"];
}

// 更新网络管理器，主要做头部参数处理
+ (void)updateManager:(NetworkManager *)networkManager {
    
    // userid
    NSString *localUserId = [@([RawCacheManager sharedRawCacheManager].userInfo.userId) stringValue];
    [networkManager.requestSerializer setValue:[NSString stringIsNullOrEmpty:localUserId] ? @"" : localUserId forHTTPHeaderField:HEAD_USER_ID];
    
    // sessionid
    NSString *sessionId = [RawCacheManager sharedRawCacheManager].userInfo.sid;
    [networkManager.requestSerializer setValue:[NSString stringIsNullOrEmpty:sessionId] ? @"" : sessionId forHTTPHeaderField:KEY_SID];
    
    // clientType
    [networkManager.requestSerializer setValue:[NSString stringWithFormat:@"%d", IOS_CLIENT_TYPE] forHTTPHeaderField:HEAD_CLIENT_TYPE];
    
    NSString *deviceType = [[UIDevice currentDevice] hardwareSimpleDescription];
    [networkManager.requestSerializer setValue:deviceType forHTTPHeaderField:@"model"];
    
    NSInteger clientMark = 1;
    if ([deviceType hasPrefix:@"iPad"]) {
        clientMark = 2;
    }else if([deviceType hasPrefix:@"iPod"]) {
        clientMark = 3;
    }
    [networkManager.requestSerializer setValue:[NSString stringWithFormat:@"%td", clientMark] forHTTPHeaderField:@"clientmark"];
    
    [networkManager.requestSerializer setValue:[UIDevice appVersion] forHTTPHeaderField:@"clientvname"];
    
    [networkManager.requestSerializer setValue:[NSString stringWithFormat:@"%td", [UIDevice appVersionCode]] forHTTPHeaderField:@"clientvcode"];
    
    [networkManager.requestSerializer setValue:[UIDevice systemVersion] forHTTPHeaderField:@"sdkversion"];
    
    [networkManager.requestSerializer setValue:[UIDevice deviceScreen] forHTTPHeaderField:@"density"];
    
    [networkManager.requestSerializer setValue:[NSString stringWithFormat:@"%lf", [NSDate date].timeIntervalSince1970] forHTTPHeaderField:@"ts"];
    
    [networkManager.requestSerializer setValue:[UIDevice systemNetType] forHTTPHeaderField:@"nettype"];
    
}

#pragma mark - Public

#pragma mark - OverWrite

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", ServerAPIBaseURL, URLString];
    
    return [super GET:requestURL parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Dictionary expected.");
        GBLog(@"%@返回参数：%@", URLString, responseObject);
        BLOCK_EXEC(success, task, responseObject);
    } failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    //url_check添加
    NSString *value_str = @"";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray *keys = [paramDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = ([obj1 isKindOfClass:[NSString class]])?obj1:[obj1 stringValue];
        NSString *str2 = ([obj2 isKindOfClass:[NSString class]])?obj2:[obj2 stringValue];
        return [str1 compare:str2];
    }];
    for (NSString *key in keys) {
        id value = paramDic[key];
        value_str = [NSString stringWithFormat:@"%@%@", value_str, ([value isKindOfClass:[NSString class]])?value:[value stringValue]];
    }
    value_str = [NSString stringWithFormat:@"%@%@", value_str, @"t_goal_server_api"];
    [paramDic setValue:[[value_str MD5] lowercaseString] forKey:@"url_check"];
    
    GBLog(@"value_str:%@", value_str);
    GBLog(@"%@请求参数:%@", URLString, paramDic);
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", ServerAPIBaseURL, URLString];
    return [super POST:requestURL parameters:[paramDic copy] progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Dictionary expected.");
        GBLog(@"%@返回参数：%@", URLString, responseObject);
        BLOCK_EXEC(success, task, responseObject);
    } failure:failure];
}

//上传
- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    //url_check添加
    NSString *value_str = @"";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSArray *keys = [paramDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = ([obj1 isKindOfClass:[NSString class]])?obj1:[obj1 stringValue];
        NSString *str2 = ([obj2 isKindOfClass:[NSString class]])?obj2:[obj2 stringValue];
        return [str1 compare:str2];
    }];
    for (NSString *key in keys) {
        id value = paramDic[key];
        value_str = [NSString stringWithFormat:@"%@%@", value_str, ([value isKindOfClass:[NSString class]])?value:[value stringValue]];
    }
    value_str = [NSString stringWithFormat:@"%@%@", value_str, @"t_goal_server_api"];
    [paramDic setValue:[value_str MD5] forKey:@"url_check"];
    
    GBLog(@"value_str:%@", value_str);
    GBLog(@"%@请求参数:%@", URLString, paramDic);
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", ServerAPIBaseURL, URLString];
    
    return [super POST:requestURL parameters:paramDic constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Dictionary expected.");
        GBLog(@"%@返回参数：%@", URLString, responseObject);
        BLOCK_EXEC(success, task, responseObject);
    } failure:failure];
}

@end
