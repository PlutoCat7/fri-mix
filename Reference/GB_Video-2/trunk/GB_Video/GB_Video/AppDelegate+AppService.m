//
//  AppDelegate+AppService.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "AppDelegate+AppService.h"

#import <UMMobClick/MobClick.h>
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import "AFNetworkReachabilityManager.h"


@implementation AppDelegate (AppService)

- (void)initService:(NSDictionary *)launchOptions {
    
    [self initAppConfig];
    [self initThirdPlatformService:launchOptions];
}

#pragma mark - Private

- (void)initAppConfig {
    
    // 网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //
    // [NoRemindManager sharedInstance];
    
    // 社会化分享初始化
    // [UMShareManager regiser];

}

- (void)initThirdPlatformService:(NSDictionary *)launchOptions {
    
    [self initUMeng];
    [self initHttpDns];
    [self initPushService:launchOptions];
}


- (void)initUMeng {
    
    // 友盟统计
//    UMConfigInstance.appKey = UM_App_Key;
//    UMConfigInstance.ePolicy = BATCH;
//    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)initHttpDns {
    /*
    //使用HTTPNDS
    // 初始化HTTPDNS
    HttpDnsService *httpdns = [HttpDnsService sharedInstance];
    
    // 设置AccoutID
    [httpdns setAccountID:HttpDns_Account];
    
    // 为HTTPDNS服务设置降级机制
    //[httpdns setDelegateForDegradationFilter:(id<HttpDNSDegradationDelegate>)self];
    
    // 打开HTTPDNS Log，线上建议关闭
    //[httpdns setLogEnabled:YES];
    */
    /*
     *  设置HTTPDNS域名解析请求类型(HTTP/HTTPS)，若不调用该接口，默认为HTTP请求；
     *  SDK内部HTTP请求基于CFNetwork实现，不受ATS限制。
     *//*
    [httpdns setHTTPSRequestEnabled:YES];
    
    NSArray *preResolveHosts = @[@"apiv1.t-goal.com", @"testapiv1.t-goal.com"];
    // 设置预解析域名列表
    [httpdns setPreResolveHosts:preResolveHosts];*/
}

- (void)initPushService:(NSDictionary *)launchOptions {
    /*
    // 推送初始化
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
#ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions appKey:JPush_App_Key channel:nil apsForProduction:NO];
#else
    [JPUSHService setupWithOption:launchOptions appKey:JPush_App_Key channel:nil apsForProduction:YES];
#endif
    */
}

#pragma mark- JPUSHRegisterDelegate
/*
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
    [[APNSManager shareInstance] pushNotificationWithDictionary:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    [[APNSManager shareInstance] pushNotificationWithDictionary:userInfo];
}*/

@end
