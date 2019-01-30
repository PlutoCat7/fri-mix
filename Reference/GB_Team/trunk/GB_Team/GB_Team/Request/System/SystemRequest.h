//
//  SystemRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "ApkUpdateResponseInfo.h"
#import "FirewareUpdateResponeInfo.h"
#import "BindWristbandListResponeInfo.h"

@interface SystemRequest : BaseNetworkRequest

// 检查应用更新
+ (void)checkAppVersion:(RequestCompleteHandler)handler;

// 检查固件更新
+ (void)checkFirewareUpgrade:(NSString *)version deviceVersion:(NSString *)deviceVersion handler:(RequestCompleteHandler)handler;

// 下载固件
+ (void)downloadFirewareFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress;
// 手环绑定
+ (void)bindWristband:(NSString *)wristbandMark handler:(RequestCompleteHandler)handler;

// 手环解绑
+ (void)unbindWristband:(NSArray<NSString *> *)bindWristband_ids handler:(RequestCompleteHandler)handler;

// 手环列表
+ (void)getBindWristbandListWithHandler:(RequestCompleteHandler)handler;

/**
 请求搜星文件
 
 @param lon 经度
 @param lat 纬度
 @param alt 海拨高度
 @param pacc 水平经度
 */
+ (void)doAGPSFile:(CGFloat)lon lat:(CGFloat)lat alt:(CGFloat)alt pacc:(CGFloat)pacc version:(iBeaconVersion)version handler:(RequestCompleteHandler)handler;

@end
