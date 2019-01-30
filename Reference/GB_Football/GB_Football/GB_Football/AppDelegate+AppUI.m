//
//  AppDelegate+AppUI.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "AppDelegate+AppUI.h"

#import "GBNavigationController.h"
#import "GBWelComeViewController.h"
#import "GBMenuViewController.h"
#import "GBLoadingViewController.h"
#import "GBScanViewController.h"
#import "GBCoursePageViewController.h"
#import "GBSettingViewController.h"

#import "JPUSHService.h"

#import "GBBluetoothManager.h"
#import "NoRemindManager.h"
#import "BLStopwatch.h"

@implementation AppDelegate (AppUI)

- (void)setupUI {
    
    [self setupNotification];
    [self styleUIForApp];
    [self initWindow];
}

#pragma mark - Private

// app总体风格设置
- (void)styleUIForApp
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITextField appearance] setTintColor:[UIColor greenColor]];
    [[UITextView appearance] setTintColor:[UIColor greenColor]];
    [GBNavigationBar appearance].barTintGradientColors = @[[UIColor colorWithHex:0x26272c],
                                                           [UIColor colorWithHex:0x111111]];
    [GBNavigationBar appearance].tintColor = [UIColor whiteColor];
    BOOL isEnglish = [[LanguageManager sharedLanguageManager] isEnglish];
    [GBNavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName:isEnglish?[UIFont systemFontOfSize:19.f]:[UIFont systemFontOfSize:16.f]};
}

- (void)initWindow {
    
    
    // 制定导航控制器和窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self setupLoadingView];
    [self.window makeKeyAndVisible];
    
    
    
}

- (void)setupLoadingView {
    
    self.navigationController = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBLoadingViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
}

// 制定导航控制器和窗口
- (void)setupLoginView {
    
    //取消监听
    [[UpdateManager shareInstance] stopMonitoring];
    
    //蓝牙清空
    [[GBBluetoothManager sharedGBBluetoothManager] resetGBBluetoothManager];
    
    self.isPushingScanView = NO;
    self.navigationController = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBWelComeViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
    
    //清除数据
    [[RawCacheManager sharedRawCacheManager] clearLoginCache];
    
    [JPUSHService setTags:nil aliasInbackground:@""];
}

- (void)setupMainView {
    // 未播放过教程-新增教程播放
    if ([NoRemindManager sharedInstance].tutorialPagesV1 == NO) {
        self.navigationController.viewControllers = @[[[GBCoursePageViewController alloc] init]];
        self.window.rootViewController = self.navigationController;
        return;
    }
    // 播放过教程
    [[UpdateManager shareInstance] startMonitoring];
    [JPUSHService setTags:nil aliasInbackground:@([RawCacheManager sharedRawCacheManager].userInfo.userId).stringValue];
    self.navigationController = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBMenuViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
}

- (void)needBindiBeacon {
    
    if ([self.navigationController.topViewController isMemberOfClass:[GBScanViewController class]] || self.isPushingScanView) {
        return;
    }
    if (![self.navigationController.viewControllers.firstObject isKindOfClass:[GBMenuViewController class]]) {
        return;
    }
    
    self.isPushingScanView = YES;
    [self.navigationController pushViewController:[GBScanViewController new] animated:YES completion:^{
        self.isPushingScanView = NO;
    }];
}

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupMainView) name:Notification_ShowMainView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLoginView) name:Notification_NeedLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needBindiBeacon) name:Notification_NeedBindiBeacon object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:Notification_ChangeLanguageRestart object:nil];
}

#pragma mark - 语言切换重启
- (void)changeLanguage {
    self.navigationController = [[GBNavigationController alloc] initWithNavigationBarClass:[GBNavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBMenuViewController alloc] initForRestart], [[GBSettingViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
}

@end
