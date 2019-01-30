//
//  AppDelegate+AppService.m
//  GB_Football
//
//  Created by yahua on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "AppDelegate+AppService.h"


#import "AFNetworkReachabilityManager.h"
#import "WXApi.h"


@implementation AppDelegate (AppService)

- (void)initService:(NSDictionary *)launchOptions {
    
    [self initAppConfig];
    [self initThirdPlatformService:launchOptions];
}

#pragma mark - Private

- (void)initAppConfig {
    
    //加载缓存
    [[RawCacheManager sharedRawCacheManager] loadCache];
    
    // 网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

- (void)initThirdPlatformService:(NSDictionary *)launchOptions {
    
    [self initUMeng];
    [self initWeChat];
}

- (void)initUMeng {
    
    // 友盟统计
    
}

- (void)initWeChat {
    
    [WXApi registerApp:kWeChatAppKey];
}

@end
