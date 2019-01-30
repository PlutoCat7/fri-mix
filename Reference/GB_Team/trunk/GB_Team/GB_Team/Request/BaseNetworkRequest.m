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
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"无法连接网络，请稍候！") code:RequestErrorCodeNetwork userInfo:nil]);
        return nil;
    }
    
    return [[NetworkManager sharedNetworkManager] POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"请求失败，请稍候") code:RequestErrorCodeNetwork userInfo:nil]);
    }];
}


+ (NSURLSessionTask *)GET:(NSString *)urlString parameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"无法连接网络，请稍候！") code:RequestErrorCodeNetwork userInfo:nil]);
        return nil;
    }
    return [[NetworkManager sharedNetworkManager] GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"请求失败，请稍候") code:RequestErrorCodeNetwork userInfo:nil]);
    }];
}

+ (NSURLSessionTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"无法连接网络，请稍候！") code:RequestErrorCodeNetwork userInfo:nil]);
        return nil;
    }
    
    return [[NetworkManager sharedNetworkManager] POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:LS(@"请求失败，请稍候") code:RequestErrorCodeNetwork userInfo:nil]);
    }];
}

#pragma mark - Private

+ (void)analyseWithData:(id)data responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    NSParameterAssert([responseClass isSubclassOfClass:[GBResponseInfo class]]);
    
    //json数据解析，检验请求是否正确
    [responseClass analyseWithData:data complete:^(__kindof YAHDataResponseInfo *result, NSString *errMsg) {
        
        if (errMsg) {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:errMsg code:ActionType_ShowError userInfo:nil]);
        }else {
            BLOCK_EXEC(handler, result, nil);
        }
    }];
}

@end
