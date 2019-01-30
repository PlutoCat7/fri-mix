//
//  UMShareManager.m
//  shareSDK分享封装
//
//  Created by Pizza on 2016/12/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UMShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <MOBFoundation/MOBFoundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <UMMobClick/MobClick.h>

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

// 注册实现
+ (void)regiser{
    @try {
        [ShareSDK registerApp:@"110e9288fbfc0"
         
              activePlatforms:@[
                                @(SSDKPlatformTypeSinaWeibo),
                                @(SSDKPlatformTypeWechat),
                                @(SSDKPlatformSubTypeWechatTimeline),
                                @(SSDKPlatformSubTypeQQFriend),
                                @(SSDKPlatformSubTypeQZone)]
                     onImport:^(SSDKPlatformType platformType)
         {
             switch (platformType)
             {
                 case SSDKPlatformTypeWechat:
                     [ShareSDKConnector connectWeChat:[WXApi class]];
                     break;
                 case SSDKPlatformTypeQQ:
                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                     break;
                 case SSDKPlatformTypeSinaWeibo:
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                     break;
                 default:
                     break;
             }
         }
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
         {
             
             switch (platformType)
             {
                 case SSDKPlatformTypeSinaWeibo:
                     [appInfo SSDKSetupSinaWeiboByAppKey:@"370222072"
                                               appSecret:@"07ec4a49e44cd341e799a228f26641a4"
                                             redirectUri:@"http://www.t-goal.com"
                                                authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:@"wx44ea3f20f13422d3"
                                           appSecret:@"eb7798e989ba8f26485ab3776e0eddae"];
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:@"1105830894"
                                          appKey:@"Jrl4uLKldMfcwsQW"
                                        authType:SSDKAuthTypeBoth];
                     break;
                     
                 default:
                     break;
             }
         }];
        
    } @catch (NSException *exception) {
    }
    
}

// 分享类型转换
-(SSDKPlatformType)toSdkType:(SHARE_TYPE)type
{
    SSDKPlatformType sdk = SSDKPlatformTypeUnknown;
    switch (type)
    {
        case SHARE_TYPE_WECHAT:
        {
            sdk = SSDKPlatformTypeWechat;
        }
            break;
        case SHARE_TYPE_CIRCLE:
        {
            sdk = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case SHARE_TYPE_QQ:
        {
            sdk = SSDKPlatformTypeQQ;
        }
            break;
        case SHARE_TYPE_QQZONE:
        {
            sdk = SSDKPlatformSubTypeQZone;
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            sdk = SSDKPlatformTypeSinaWeibo;
        }
            break;
        default:
        {
            sdk = SSDKPlatformTypeWechat;
        }
            break;
    }
    return sdk;
}

// 截屏分享
- (void)screenShare:(SHARE_TYPE)type image:(UIImage*)image complete:(void(^)(NSInteger state))complete
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    [shareParams SSDKSetupShareParamsByText:@""
                                     images:@[image]
                                        url:[NSURL URLWithString:@"http://www.t-goal.com"]
                                      title:@""
                                       type:SSDKContentTypeImage];
    [shareParams SSDKEnableUseClientShare];
    //进行分享
    [ShareSDK share:[self toSdkType:type]
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state)
         {
             case SSDKResponseStateSuccess:
             {
                 BLOCK_EXEC(complete,0);
                 break;
             }
             case SSDKResponseStateFail:
             {
                 BLOCK_EXEC(complete,1);
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 BLOCK_EXEC(complete,2);
                 break;
             }
             default:
                 break;
         }
     }];
    return ;
}

// 由于苹果审核政策需求，对于那些需要客户端分享的平台，例如微信，QQ，QQ空间等，
// 没有安装客户端不能显示
+(BOOL)isInstalledQQ
{
    return [QQApiInterface isQQInstalled];
}

+(BOOL)isInstalledWechat
{
    return [WXApi isWXAppInstalled];
}

+(BOOL)isInstalledWeiBo
{
    return [WeiboSDK isWeiboAppInstalled];
}

// web页分享 complete 0成功 1 失败 2 取消
- (void)webShare:(SHARE_TYPE)type titile:(NSString*)title content:(NSString*)content
             url:(NSString*)url image:(UIImage*)image complete:(void(^)(NSInteger state))complete
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if(image == nil)image       = [UIImage imageNamed:@"shareIcon"];
    if([NSString stringIsNullOrEmpty:title])title       = @" ";
    if([NSString stringIsNullOrEmpty:content])content   = @" ";
    if ([NSString stringIsNullOrEmpty:url])url          = @" ";
    [shareParams SSDKSetupShareParamsByText:content
                                     images:@[image]
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]
                                      title:title
                                       type:SSDKContentTypeWebPage];
    
    [shareParams SSDKEnableUseClientShare];
    [ShareSDK share:[self toSdkType:type]
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 BLOCK_EXEC(complete,0);
                 break;
             }
             case SSDKResponseStateFail:
             {
                 BLOCK_EXEC(complete,1);
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 BLOCK_EXEC(complete,2);
                 break;
             }
             default:
                 break;
         }
     }];
}

#pragma mark - analytics event
+(void)event:(NSString *)eventId {
    
    if (![NSString stringIsNullOrEmpty:eventId]) {
        
        @try {
            [MobClick event:eventId];
            
        } @catch (NSException *exception) {
        }
    }
}

+(void)beginPageView:(NSString *)pageName {
    if (![NSString stringIsNullOrEmpty:pageName]) {
        
        @try {
            [MobClick beginLogPageView:pageName];
            
        } @catch (NSException *exception) {
        }
    }
}

+(void)endPageView:(NSString *)pageName {
    if (![NSString stringIsNullOrEmpty:pageName]) {
        
        @try {
            [MobClick endLogPageView:pageName];
            
        } @catch (NSException *exception) {
        }
    }
}

@end
