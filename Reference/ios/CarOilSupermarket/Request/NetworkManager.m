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

+ (NetworkManager *)sharedNetworkManager
{
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

+ (NetworkManager *)uploadImageManager
{
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

// 初始化网络管理器
+ (void)initManager:(NetworkManager *)networkManager withIsJSONRequest:(BOOL)isJSONRequest {
    if (networkManager == nil) {
        return;
    }
    
    networkManager.requestSerializer = isJSONRequest ? [[AFJSONRequestSerializer alloc] init] : [[AFHTTPRequestSerializer alloc] init];
}

// 更新网络管理器，主要做头部参数处理
+ (void)updateManager:(NetworkManager *)networkManager {
    
}

#pragma mark - OverWrite

- (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    //url_check添加
    NSDictionary *paramDic = [self parametersWithUrl_check:parameters];
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
    NSDictionary *paramDic = [self parametersWithUrl_check:parameters];
    GBLog(@"%@请求参数:%@", URLString, paramDic);
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", ServerAPIBaseURL, URLString];
    return [super POST:requestURL parameters:paramDic constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"Dictionary expected.");
        GBLog(@"%@返回参数：%@", URLString, responseObject);
        BLOCK_EXEC(success, task, responseObject);
    } failure:failure];
}

- (NSDictionary *)parametersWithUrl_check:(NSDictionary *)parameters {
    
    //url_check添加
    NSString *value_str = @"";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //添加默认
    [paramDic setObject:@"ios_dev" forKey:@"_client"];
    [paramDic setValue:[NSString stringWithFormat:@"%td", (NSInteger)[NSDate date].timeIntervalSince1970] forKey:@"_ts"];
    
    NSArray *keys = [paramDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = ([obj1 isKindOfClass:[NSString class]])?obj1:[obj1 stringValue];
        NSString *str2 = ([obj2 isKindOfClass:[NSString class]])?obj2:[obj2 stringValue];
        return [str1 compare:str2];
    }];
    for (NSString *key in keys) {
        id value = paramDic[key];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *strValue = value;
            if (strValue.length == 0) {
                continue;
            }
        }
        value_str = [NSString stringWithFormat:@"%@%@=%@&", value_str, key, ([value isKindOfClass:[NSString class]])?value:[value stringValue]];
    }
    value_str = [NSString stringWithFormat:@"%@_secret=88888888", value_str];
    [paramDic setValue:[value_str MD5].uppercaseString forKey:@"_sig"];
    
    return [paramDic copy];
}


@end
