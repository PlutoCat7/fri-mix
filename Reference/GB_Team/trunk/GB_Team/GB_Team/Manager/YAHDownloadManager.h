//
//  GBDownloadManager.h
//  GB_Team
//
//  Created by 王时温 on 2017/3/23.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadCompleteHandler)(NSURL *filePath, NSError *error);
typedef void (^DownloadProgressHandler)(CGFloat progress);
typedef void(^DownloadNoParamsBlock)();

@interface YAHDownloadManager : NSObject

+ (instancetype)shareInstance;

- (void)donwloadWithUrl:(NSString *)url complete:(DownloadCompleteHandler)complete;

- (void)donwloadWithUrl:(NSString *)url progress:(DownloadProgressHandler)progress complete:(DownloadCompleteHandler)complete;

@end
