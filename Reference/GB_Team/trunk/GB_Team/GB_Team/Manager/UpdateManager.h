//
//  UpdateManager.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//  app及固件升级管理

#import <Foundation/Foundation.h>


@interface UpdateManager : NSObject

+ (instancetype)shareInstance;

- (void)checkAppUpdate:(void(^)(NSString *url, NSError *error))complete;

- (void)checkFirewareUpdate:(void(^)(NSString *url, NSError *error))complete;

@end
