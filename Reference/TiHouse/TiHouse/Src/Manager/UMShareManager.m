//
//  UMShareManager.m
//  shareSDK分享封装
//
//  Created by Pizza on 2016/12/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UMShareManager.h"
#import "WXApi.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation UIImage (UMScreenShot)
+ (UIImage *)imageWithCapeture
{
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size, NO, 0);
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:ctf];
    UIImage * imageNow = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNow;
}
@end

@implementation UMShareManager

// 分享类型转换
-(UMSocialPlatformType)toSdkType:(SHARE_TYPE)type
{
    UMSocialPlatformType sdk = UMSocialPlatformType_UnKnown;
    switch (type)
    {
        case SHARE_TYPE_WECHAT:
        {
            sdk = UMSocialPlatformType_WechatSession;
        }
            break;
        case SHARE_TYPE_CIRCLE:
        {
            sdk = UMSocialPlatformType_WechatTimeLine;
        }
            break;
        case SHARE_TYPE_QQ:
        {
            sdk = UMSocialPlatformType_QQ;
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            sdk = UMSocialPlatformType_Sina;
        }
            break;
        default:
        {
            sdk = UMSocialPlatformType_UnKnown;
        }
            break;
    }
    return sdk;
}


// 截屏分享
- (void)screenShare:(SHARE_TYPE)type image:(UIImage*)image complete:(void(^)(NSInteger state))complete
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    [[UMSocialManager defaultManager] shareToPlatform:[self toSdkType:type]
                                        messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
                                            if (error) {
                                                if (complete) complete(1);
                                            } else {
                                                if (complete) complete(0);
                                            }
                                        }];
}

// 由于苹果审核政策需求，对于那些需要客户端分享的平台，例如微信，QQ，QQ空间等，
// 没有安装客户端不能显示
+(BOOL)isInstalledQQ
{
//    return [QQApiInterface isQQInstalled];
    return YES;
}

+(BOOL)isInstalledWechat
{
//    return [WXApi isWXAppInstalled];
    return YES;
}

+(BOOL)isInstalledWeiBo
{
//    return [WeiboSDK isWeiboAppInstalled];
    return YES;
}

// web页分享 complete 0成功 1 失败 2 取消
- (void)webShare:(SHARE_TYPE)type title:(NSString*)title content:(NSString*)content
             url:(NSString*)url image:(id)image complete:(void(^)(NSInteger state))complete
{
    //每次取消授权后 都会跳转到授权页面
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:[self toSdkType:type] completion:^(id result, NSError *error) {
        
    }];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建分享消息对象
    id thumImage = image != nil ? image : [UIImage imageNamed:@"w_share_icon"];
    
    id shareObject = nil;
    if (type == SHARE_TYPE_WEIBO)
    {
        messageObject.text = title;
        shareObject = [[UMShareImageObject alloc] init];
        [shareObject setShareImage:thumImage];
    }
    else
    {
        shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:(content == nil ? @"" : content) thumImage:(id)thumImage];
        [(UMShareWebpageObject *)shareObject setWebpageUrl:url];
    }
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:[self toSdkType:type]
                                        messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
                                            if (error) {
                                                if (complete) complete(1);
                                            } else {
                                                if (complete) complete(0);
                                            }
                                        }];
}

- (void)imageShare:(SHARE_TYPE)type title:(NSString*)title content:(NSString*)content
             url:(NSString*)url image:(id)image complete:(void(^)(NSInteger state))complete
{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:[self toSdkType:type] completion:^(id result, NSError *error) {
        
    }];
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建分享消息对象
    id thumImage = image != nil ? image : [UIImage imageNamed:@"w_share_icon"];
    
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:thumImage];
    
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:[self toSdkType:type]
                                        messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
                                            if (error) {
                                                if (complete) complete(1);
                                            } else {
                                                if (complete) complete(0);
                                            }
                                        }];
}

// web页分享 complete 0成功 1 失败 2 取消
//- (void)webShareImageUrl:(SHARE_TYPE)type title:(NSString*)title content:(NSString*)content
//             url:(NSString*)url image:(NSString*)image complete:(void(^)(NSInteger state))complete
//{
//    
//    //创建分享消息对象
//    id thumImage = image != nil ? image : [UIImage imageNamed:@"w_share_icon"];
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:(content == nil ? @"" : content) thumImage:(id)thumImage];
//    shareObject.webpageUrl = url;
//    
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    messageObject.shareObject = shareObject;
//    
//    [[UMSocialManager defaultManager] shareToPlatform:[self toSdkType:type]
//                                        messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
//                                            if (error) {
//                                                if (complete) complete(1);
//                                            } else {
//                                                if (complete) complete(0);
//                                            }
//                                        }];
//}

@end
