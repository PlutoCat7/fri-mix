//
//  BaseNetworkRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

//网络请求回调
typedef void (^RequestCompleteHandler)(id result, NSError *error);

@interface BaseNetworkRequest : NSObject

+ (NSURLSessionTask *)POST:(NSString *)urlString parameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler;

+ (NSURLSessionTask *)GET:(NSString *)urlString parameters:(id)parameters responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler;

//上传
+ (NSURLSessionTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block progress:(void (^)(NSProgress *))uploadProgress responseClass:(Class)responseClass handler:(RequestCompleteHandler)handler;

+ (void)sendErrorReport:(NSError *)error uri:(NSString *)uri;

//日志上报
+ (void)sendLogReport:(NSString *)key mark:(NSString *)mark;

@end
