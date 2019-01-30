//
//  YHURLSessionManagerTaskDelegate.h
//  Download
//
//  Created by 王时温 on 10/19/15.
//  Copyright © 2015 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHURLSessionManager.h"

typedef NSURL * (^YHURLSessionDownloadTaskDidFinishDownloadingBlock)(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location);
typedef void (^YHURLSessionTaskLoadingBlock)(int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite, double progress);
typedef void (^YHURLSessionTaskCompletionHandler)(NSURLSessionTask *urlSessionTask, id responseObject, NSError *error);

//暂时只做下载功能
@interface YHURLSessionManagerTaskDelegate : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, copy)   NSURL *downloadFilePath;
@property (nonatomic, copy)   NSURL *tmpFilePath;    //URLSession的临时路径
@property (nonatomic, copy)   YHURLSessionDownloadTaskDidFinishDownloadingBlock downloadTaskDidFinishDownloading;
@property (nonatomic, copy)   YHURLSessionTaskLoadingBlock downloadTaskLoading;
@property (nonatomic, copy)   YHURLSessionTaskCompletionHandler completionHandler;

@end
