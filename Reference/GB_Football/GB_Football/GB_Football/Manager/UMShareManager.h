//
//  UMShareManager.h
//  shareSDK分享封装
//
//  Created by Pizza on 2016/12/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

// 系统截屏
@interface UIImage (UMScreenShot)
+ (UIImage *)imageWithCapeture;
@end

typedef NS_ENUM(NSUInteger, SHARE_TYPE)
{
    SHARE_TYPE_WECHAT = 0,  // 微信
    SHARE_TYPE_CIRCLE,      // 微信朋友圈
    SHARE_TYPE_QQ,          // QQ
    SHARE_TYPE_QQZONE,      // QQ空间
    SHARE_TYPE_WEIBO,       // 新浪微博
    SHARE_TYPE_NONE,        // 不显示
};

@interface UMShareManager : NSObject
+ (void)regiser;
// 截屏分享 complete 0成功 1 失败 2 取消
- (void)screenShare:(SHARE_TYPE)type image:(UIImage*)image complete:(void(^)(NSInteger state))complete;
// web页分享 complete 0成功 1 失败 2 取消
- (void)webShare:(SHARE_TYPE)type titile:(NSString*)title content:(NSString*)content
             url:(NSString*)url image:(UIImage*)image complete:(void(^)(NSInteger state))complete;
+(BOOL)isInstalledQQ;
+(BOOL)isInstalledWechat;
+(BOOL)isInstalledWeiBo;

+(void)event:(NSString *)eventId;
+(void)beginPageView:(NSString *)pageName;
+(void)endPageView:(NSString *)pageName;

@end
