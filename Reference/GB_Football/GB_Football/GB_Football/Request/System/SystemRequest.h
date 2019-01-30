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
#import "BindWristbandCheckResponeInfo.h"
#import "BindWristbandResponseInfo.h"
#import "WristbandFilterResponseInfo.h"
#import "SplashResponseInfo.h"
#import "AppConfigResponseInfo.h"

@interface SystemRequest : BaseNetworkRequest

// 检查应用更新
+ (void)checkAppVersion:(RequestCompleteHandler)handler;

// 检查固件更新
+ (void)checkFirewareUpgrade:(RequestCompleteHandler)handler;

// 下载固件
+ (void)downloadFirewareFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress;

// 设备绑定和解绑接口
+ (void)bindWristband:(NSString *)wristbandMark handler:(RequestCompleteHandler)handler;

//修改手环昵称
+ (void)resetWristbandName:(NSString *)newName handler:(RequestCompleteHandler)handler;

// 云配置
+ (void)getCloudConfig:(RequestCompleteHandler)handler;

/**
 请求搜星文件

 @param lon 经度
 @param lat 纬度
 @param alt 海拨高度
 @param pacc 水平经度
 */
+ (void)doAGPSFile:(CGFloat)lon lat:(CGFloat)lat alt:(CGFloat)alt pacc:(CGFloat)pacc handler:(RequestCompleteHandler)handler;
// 下载星历
+ (NSURLSessionDownloadTask *)downloadAGPSFile:(NSString *)fileUrl handler:(RequestCompleteHandler)handler progress:(void(^)(CGFloat progress))progress;


/**
 根据手环mac获取手环信息，过滤掉已绑定的手环

 @param macList mac数组
 @param handler 请求完成的回调
 */
+ (void)wristbandListFilter:(NSArray *)macList handler:(RequestCompleteHandler)handler;


/**
 获取闪屏广告信息

 @param handler 请求完成的回调
 */
+ (void)getSplashInfoWithHandler:(RequestCompleteHandler)handler;

/**
 发送反馈意见

 @param type 反馈的意见类型
 @param message 发聩的字符串
 @param handler 请求完成的回调
 */
+ (void)sendFeedbackWithType:(FeedbackType)type message:(NSString *)message handler:(RequestCompleteHandler)handler;

@end
