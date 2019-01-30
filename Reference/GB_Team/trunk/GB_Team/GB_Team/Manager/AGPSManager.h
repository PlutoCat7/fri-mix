//
//  AGPSManager.h
//  GB_Football
//
//  Created by 王时温 on 2016/11/10.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGPSManager : NSObject

+ (instancetype)shareInstance;

//开始加速搜星
- (void)startAGPSWithMac:(NSString *)mac complete:(void(^)(NSString *mac, NSError *error))complete;

- (void)cancelAGPSWithMac:(NSString *)mac;

- (void)cleanAGPSFile;

/**
 检测手环搜星状态
 
 @param complete 回调block   0：搜星中   1：搜星成功    2：日常模式，无GPS   3:蓝牙错误
 */
- (void)checkAGPSStateWithMac:(NSString *)mac complete:(void(^)(NSString *mac, BleGpsState state))complete;

@end
