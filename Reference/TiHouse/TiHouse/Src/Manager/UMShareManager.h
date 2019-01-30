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
    SHARE_TYPE_WEIBO,       // 新浪微博
    SHARE_TYPE_Favor,       // 收藏
    SHARE_TYPE_Favored,       // 已收藏
    SHARE_TYPE_Download,    // 下载
    SHARE_TYPE_NONE,        // 不显示
};

@interface UMShareManager : NSObject
// 截屏分享 complete 0成功 1 失败 2 取消
- (void)screenShare:(SHARE_TYPE)type image:(UIImage*)image complete:(void(^)(NSInteger state))complete;
// web页分享 complete 0成功 1 失败 2 取消
- (void)webShare:(SHARE_TYPE)type title:(NSString*)title content:(NSString*)content
             url:(NSString*)url image:(id)image complete:(void(^)(NSInteger state))complete;
- (void)imageShare:(SHARE_TYPE)type title:(NSString*)title content:(NSString*)content
               url:(NSString*)url image:(id)image complete:(void(^)(NSInteger state))complete;
//- (void)webShareImageUrl:(SHARE_TYPE)type title:(NSString*)title content:(NSString*)content
//             url:(NSString*)url image:(NSString*)image complete:(void(^)(NSInteger state))complete;
+(BOOL)isInstalledQQ;
+(BOOL)isInstalledWechat;
+(BOOL)isInstalledWeiBo;

@end
