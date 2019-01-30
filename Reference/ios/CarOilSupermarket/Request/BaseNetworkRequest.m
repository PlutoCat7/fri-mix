//
//  BaseNetworkRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"

#import "COSResponseInfo.h"
#import "GBRespDefine.h"

@implementation BaseNetworkRequest

+ (NSURLSessionTask *)POSTWithParameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    return [[NetworkManager sharedNetworkManager] POST:@"" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
                BLOCK_EXEC(handler, nil, [NSError errorWithDomain:@"网络未连接！请检查您的网络" code:RequestErrorCodeNetwork userInfo:nil]);
        }else {
            NSLog(@"请求错误:%@", error);
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:@"请求失败，请重试！" code:error.code userInfo:nil]);
        }
    }];
}

+ (NSURLSessionTask *)POSTWithParameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block progress:(void (^)(NSProgress * _Nonnull))uploadProgress responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        BLOCK_EXEC(handler, nil, [NSError errorWithDomain:@"network.tip.error" code:RequestErrorCodeNetwork userInfo:nil]);
        return nil;
    }
    
    return [[NetworkManager sharedNetworkManager] POST:@"" parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self class] analyseWithData:responseObject responseClass:responseClass handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:@"网络未连接！请检查您的网络" code:RequestErrorCodeNetwork userInfo:nil]);
        }else {
            BLOCK_EXEC(handler, nil, [NSError errorWithDomain:@"请求失败，请重试！" code:RequestErrorCodeHTTP userInfo:nil]);
        }
    }];
}

#pragma mark - Private

+ (void)analyseWithData:(id)data responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler {
    
    NSParameterAssert([responseClass isSubclassOfClass:[COSResponseInfo class]]);
    
    //json数据解析，检验请求是否正确
    [responseClass analyseWithData:data complete:^(__kindof YAHDataResponseInfo *result, NSError *error) {
        
        BLOCK_EXEC(handler, result, error);
    }];
}

@end
