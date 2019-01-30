//
//  BaseNetworkRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"

#import "GBResponseInfo.h"
#import "GBRespDefine.h"

@implementation BaseNetworkRequest

+ (NSURLSessionTask *)POST:(NSString *)urlString parameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.error") code:RequestErrorCodeNetwork userInfo:nil]);
        return nil;
    }
    
    return [[NetworkManager sharedNetworkManager] POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *errorString = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
        if (!errorString) {
            errorString = [error localizedDescription];
        }
        GBLog(@"请求失败-%@, %@", urlString, errorString);
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
                BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.error") code:RequestErrorCodeNetwork userInfo:nil]);
        }else {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.fail") code:RequestErrorCodeHTTP userInfo:nil]);
            //添加错误报告
            if (!KGBDebug) {
                [self sendErrorReport:error uri:urlString];
            }
        }
    }];
}

+ (NSURLSessionTask *)GET:(NSString *)urlString parameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.error") code:RequestErrorCodeNetwork userInfo:nil]);
        return nil;
    }
    return [[NetworkManager sharedNetworkManager] GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        GBLog(@"%@请求失败", urlString);
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.error") code:RequestErrorCodeNetwork userInfo:nil]);
        }else {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.fail") code:RequestErrorCodeHTTP userInfo:nil]);
            //添加错误报告
            if (!KGBDebug) {
                [self sendErrorReport:error uri:urlString];
            }
        }
    }];
}

+ (NSURLSessionTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.error") code:RequestErrorCodeNetwork userInfo:nil]);
        return nil;
    }
    
    return [[NetworkManager sharedNetworkManager] POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        GBLog(@"%@请求失败", URLString);
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.error") code:RequestErrorCodeNetwork userInfo:nil]);
        }else {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"network.tip.fail") code:RequestErrorCodeHTTP userInfo:nil]);
            //添加错误报告
            if (!KGBDebug) {
                [self sendErrorReport:error uri:URLString];
            }
        }
    }];
}

#pragma mark - Private

+ (void)analyseWithData:(id)data responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    NSParameterAssert([responseClass isSubclassOfClass:[GBResponseInfo class]]);
    
    //json数据解析，检验请求是否正确
    [responseClass analyseWithData:data complete:^(__kindof YAHDataResponseInfo *result, NSError *error) {
        
        BLOCK_EXEC(handler, result, error);
    }];
}

//请求错误上报
+ (void)sendErrorReport:(NSError *)error uri:(NSString *)uri {
    /*
    NSString *errorURL = @"http://114.55.65.99:8081/apps/report_error_controller/doadd";
    NSString *errorString = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
    if (!errorString) {
        errorString = [error localizedDescription];
    }
    if (!errorString) {
        errorString = @"";
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self reportDefaultParameters]];
    [parameters setObject:uri?uri:@"" forKey:@"uri"];
    [parameters setObject:@(error.code) forKey:@"error_no"];
    [parameters setObject:errorString forKey:@"return_message"];
    [[AFHTTPSessionManager manager] POST:errorURL parameters:[parameters copy] progress:nil success:nil failure:nil];
     */
}

+ (void)sendLogReport:(NSString *)key mark:(NSString *)mark {
    /*
    NSString *logURL = @"http://114.55.65.99:8081/apps/report_log_controller/doadd";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self reportDefaultParameters]];
    [parameters setObject:key?key:@"" forKey:@"key"];
    [parameters setObject:mark?mark:@"" forKey:@"mark"];
    [[AFHTTPSessionManager manager] POST:logURL parameters:[parameters copy] progress:nil success:nil failure:nil];
     */
}

+ (NSDictionary *)reportDefaultParameters {
    
    NSString *deviceType = [[UIDevice currentDevice] hardwareSimpleDescription];
    NSInteger clientMark = 1;
    if ([deviceType hasPrefix:@"iPad"]) {
        clientMark = 2;
    }else if([deviceType hasPrefix:@"iPod"]) {
        clientMark = 3;
    }

    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    NSDictionary *parameters = @{@"client_vcode":[NSString stringWithFormat:@"%td", [UIDevice appVersionCode]],
                                 @"client_mark":[NSString stringWithFormat:@"%td", clientMark],
                                 @"client_time":[NSString stringWithFormat:@"%lf", [NSDate date].timeIntervalSince1970],
                                 @"pkg_name":[Utility appBundleIdentifier]?[Utility appBundleIdentifier]:@"",
                                 @"client_type":[NSString stringWithFormat:@"%d", IOS_CLIENT_TYPE],
                                 @"user_id":@(userInfo.userId),
                                 @"sid":userInfo.token?userInfo.token:@""};
    return parameters;
}

@end
