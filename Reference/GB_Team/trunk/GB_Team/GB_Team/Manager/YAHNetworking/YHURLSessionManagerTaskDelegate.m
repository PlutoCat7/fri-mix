//
//  YHURLSessionManagerTaskDelegate.m
//  Download
//
//  Created by 王时温 on 10/19/15.
//  Copyright © 2015 王时温. All rights reserved.
//

#import "YHURLSessionManagerTaskDelegate.h"

@implementation YHURLSessionManagerTaskDelegate

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.mutableData = [NSMutableData data];
    self.progress = [NSProgress progressWithTotalUnitCount:0];
    
    return self;
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(__unused NSURLSession *)session
              task:(__unused NSURLSessionTask *)task
   didSendBodyData:(__unused int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    self.progress.totalUnitCount = totalBytesExpectedToSend;
    self.progress.completedUnitCount = totalBytesSent;
}

- (void)URLSession:(__unused NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completionHandler) {
                self.completionHandler(task, nil, error);
            }else {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                userInfo[YHNetworkingTaskDidCompleteErrorKey] = error;
                [[NSNotificationCenter defaultCenter] postNotificationName:YHNetworkingTaskDidCompleteWithoutBlockNotification object:task userInfo:userInfo];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            id responseObject = self.mutableData;
            if (self.downloadFilePath) {
                responseObject = self.downloadFilePath;  //data请求
            }
            if (self.completionHandler) {
                self.completionHandler(task, responseObject, error);
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:YHNetworkingTaskDidCompleteWithoutBlockNotification object:task userInfo:(self.tmpFilePath)?@{YHNetworkingTaskDidCompleteTmpFileKey: self.tmpFilePath}:nil];
            }
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:YHNetworkingTaskDidCompleteNotification object:task];
    });
#pragma clang diagnostic pop
}

#pragma mark - NSURLSessionDataTaskDelegate

- (void)URLSession:(__unused NSURLSession *)session
          dataTask:(__unused NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.mutableData appendData:data];
}

#pragma mark - NSURLSessionDownloadTaskDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
    self.downloadFilePath = nil;
    self.tmpFilePath = location;
    if (self.downloadTaskDidFinishDownloading) {
        self.downloadFilePath = self.downloadTaskDidFinishDownloading(session, downloadTask, location);
        if (self.downloadFilePath) {
            NSError *fileManagerError = nil;
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:self.downloadFilePath error:&fileManagerError];
            if (fileManagerError) {
                //文件存储失败
                //[[NSNotificationCenter defaultCenter] postNotificationName:AFURLSessionDownloadTaskDidFailToMoveFileNotification object:downloadTask userInfo:fileManagerError.userInfo];
            }
        }
    }
}

- (void)URLSession:(__unused NSURLSession *)session
      downloadTask:(__unused NSURLSessionDownloadTask *)downloadTask
      didWriteData:(__unused int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    self.progress.totalUnitCount = totalBytesExpectedToWrite;
    self.progress.completedUnitCount = totalBytesWritten;
    if (self.downloadTaskLoading) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadTaskLoading(totalBytesWritten, totalBytesExpectedToWrite, self.progress.fractionCompleted);
        });
    }
}

- (void)URLSession:(__unused NSURLSession *)session
      downloadTask:(__unused NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    self.progress.totalUnitCount = expectedTotalBytes;
    self.progress.completedUnitCount = fileOffset;
    if (self.downloadTaskLoading) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadTaskLoading(fileOffset, expectedTotalBytes, self.progress.fractionCompleted);
        });
    }
}

@end
