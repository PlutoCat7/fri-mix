//
//  YHURLSessionManager.h
//  Download
//
//  Created by 王时温 on 10/19/15.
//  Copyright © 2015 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface YHURLSessionManager : NSObject

@property (readonly, nonatomic, strong) NSArray *downloadTasks;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration;

/**
 Invalidates the managed session, optionally canceling pending tasks.
 
 @param cancelPendingTasks Whether or not to cancel pending tasks.
 */
- (void)invalidateSessionCancelingTasks:(BOOL)cancelPendingTasks;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(nullable void (^)(NSURLSessionTask *response, id __nullable responseObject,  NSError * __nullable error))completionHandler;

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void (^)(int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite, double progress))progress
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLSessionTask *response, NSURL *filePath, NSError *error))completionHandler;

- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(void (^)(int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite, double progress))progress
                                             destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(void (^)(NSURLSessionTask *response, NSURL *filePath, NSError *error))completionHandler;

- (NSProgress *)downloadProgressForTask:(NSURLSessionDownloadTask *)downloadTask;

@end

///--------------------
/// @name Notifications
///--------------------

extern NSString * const YHNetworkingTaskDidResumeNotification;
extern NSString * const YHNetworkingTaskDidSuspendNotification;
extern NSString * const YHNetworkingTaskDidCompleteNotification;

//如果没有block回调 会发YHNetworkingTaskDidCompleteWithoutBlockNotification通知
extern NSString * const YHNetworkingTaskDidCompleteWithoutBlockNotification;
extern NSString * const YHNetworkingTaskDidCompleteErrorKey;
extern NSString * const YHNetworkingTaskDidCompleteTmpFileKey;


NS_ASSUME_NONNULL_END
