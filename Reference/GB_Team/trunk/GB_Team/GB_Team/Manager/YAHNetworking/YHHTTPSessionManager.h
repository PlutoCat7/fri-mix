//
//  YHHTTPSessionManager.h
//  Test
//
//  Created by 王时温 on 15/11/24.
//  Copyright © 2015年 王时温. All rights reserved.
//

#import "YHURLSessionManager.h"
#import "YHURLRequestSerialization.h"

NS_ASSUME_NONNULL_BEGIN
@interface YHHTTPSessionManager : YHURLSessionManager

/**
 The URL used to construct requests from relative paths in methods like `requestWithMethod:URLString:parameters:`, and the `GET` / `POST` / et al. convenience methods.
 */
@property (readonly, nonatomic, strong, nullable) NSURL *baseURL;

/**
 Requests created with `requestWithMethod:URLString:parameters:` & `multipartFormRequestWithMethod:URLString:parameters:constructingBodyWithBlock:` are constructed with a set of default headers using a parameter serialization specified by this property. By default, this is set to an instance of `AFHTTPRequestSerializer`, which serializes query string parameters for `GET`, `HEAD`, and `DELETE` requests, or otherwise URL-form-encodes HTTP message bodies.
 
 @warning `requestSerializer` must not be `nil`.
 */
@property (nonatomic, strong) YHHTTPRequestSerializer <YHURLRequestSerialization> *requestSerializer;

/**
 Creates and returns an `AFHTTPSessionManager` object.
 */
+ (instancetype)manager;

/**
 Initializes an `AFHTTPSessionManager` object with the specified base URL.
 
 @param url The base URL for the HTTP client.
 
 @return The newly-initialized HTTP client
 */
- (instancetype)initWithBaseURL:(nullable NSURL *)url;

/**
 Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 @see -dataTaskWithRequest:completionHandler:
 */
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
