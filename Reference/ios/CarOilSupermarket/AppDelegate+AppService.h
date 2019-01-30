//
//  AppDelegate+AppService.h
//  GB_Football
//
//  Created by yahua on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "AppDelegate.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate (AppService)

- (void)initService:(NSDictionary *)launchOptions;

@end
