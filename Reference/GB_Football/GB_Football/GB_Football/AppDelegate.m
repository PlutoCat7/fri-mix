//
//  AppDelegate.m
//  GB_Football
//
//  Created by weilai on 16/7/6.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+AppUI.h"

#import "APNSManager.h"
#import "BLStopwatch.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[BLStopwatch sharedStopwatch] start];
    [self initService:launchOptions];
    [[BLStopwatch sharedStopwatch] splitWithDescription:@"initService"];
    [self clearPushInfo:application];
    
    [self setupUI];
    [[BLStopwatch sharedStopwatch] splitWithDescription:@"makeKeyAndVisible"];
    [[BLStopwatch sharedStopwatch] splitWithType:BLStopwatchSplitTypeContinuous description:@"didFinishLaunchingWithOptions 总耗时"];
    [[BLStopwatch sharedStopwatch] stopAndPresentResultsThenReset];
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
    
    [self clearPushInfo:application];
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

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - Private

- (void)clearPushInfo:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    [JPUSHService resetBadge];
    [JPUSHService removeNotification:nil];
}

@end
