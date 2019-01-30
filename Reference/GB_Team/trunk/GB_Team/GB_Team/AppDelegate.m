//
//  AppDelegate.m
//  GB_Team
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"

#import "GBLoginViewController.h"
#import "GBHomePageViewController.h"
#import "GBRecordPlayerListViewController.h"
#import "GBAlertView.h"
#import "APNSManager.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#import "PushItem.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate () <JPUSHRegisterDelegate>

@property (nonatomic, strong) GBAlertView *alertView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [GBMultiBleManager sharedMultiBleManager];
    // UI统一设置
    [self setupUI];
    [self setupNotification];
    
    // 高德初始化
    [AMapServices sharedServices].apiKey = GAODE_App_Key;
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    // 友盟统计
    UMConfigInstance.appKey = UM_App_Key;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    
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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [JPUSHService resetBadge];
    [JPUSHService removeNotification:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    // 如果已经登录设置登录信息
    if ([RawCacheManager sharedRawCacheManager].userInfo) {
        [JPUSHService setTags:nil aliasInbackground:@([RawCacheManager sharedRawCacheManager].userInfo.userId).stringValue];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    
    [[APNSManager shareInstance] pushNotificationWithDictionary:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification  completionHandler: %@", userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    [[APNSManager shareInstance] pushNotificationWithDictionary:userInfo];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isPhotoLibrary) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

#pragma mark- JPUSHRegisterDelegate

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
}

#pragma mark - Private
// UI统一设置
- (void)setupUI {
    // app总体风格设置
    [self styleUIForApp];
    // 制定导航控制器和窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if ([RawCacheManager sharedRawCacheManager].isLastLogined) {
        [self setupMainView];
    }else {
        [self setupLoginView];
    }
    
    [self.window makeKeyAndVisible];
}

// app总体风格设置
- (void)styleUIForApp {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITextField appearance] setTintColor:[UIColor greenColor]];
    [GBNavigationBar appearance].barTintGradientColors = @[[UIColor colorWithHex:0x26272c],
                                                           [UIColor colorWithHex:0x111111]];
    [GBNavigationBar appearance].tintColor = [UIColor whiteColor];
    [GBNavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName:[UIFont systemFontOfSize:16.f]};
}

// 设置全局通知
- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupMainView) name:Notification_ShowMainView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLoginView) name:Notification_NeedLogin object:nil];
}

- (void)setupMainView {
    
    self.navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBHomePageViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
    
    [JPUSHService setTags:nil aliasInbackground:@([RawCacheManager sharedRawCacheManager].userInfo.userId).stringValue];
}

// 制定导航控制器和窗口
- (void)setupLoginView {
    
    self.navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBLoginViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
    
    //清除数据
    [[RawCacheManager sharedRawCacheManager] clearCache];
    [[GBMultiBleManager sharedMultiBleManager] resetMultiBleManager];
    
    [JPUSHService setTags:nil aliasInbackground:@""];
}

@end
