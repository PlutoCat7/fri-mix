//
//  AppDelegate+AppUI.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "AppDelegate+AppUI.h"

#import "GBNavigationController.h"

#import "GBLoadingViewController.h"
#import "GBHomeViewController.h"
#import "GBLoginViewController.h"

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
    [[UITextField appearance] setTintColor:[UIColor colorWithHex:0x288cee]];
    [[UITextView appearance] setTintColor:[UIColor colorWithHex:0x288cee]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbg"] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName:[UIFont systemFontOfSize:18.f]};
}

- (void)initWindow {
    
    // 制定导航控制器和窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self setupLoadingView];
    [self.window makeKeyAndVisible];
}

- (void)setupLoadingView {
    
    self.navigationController = [[GBNavigationController alloc] initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBLoadingViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
}

- (void)setupMainView {
    
    self.navigationController = [[GBNavigationController alloc] initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    self.navigationController.viewControllers = @[[[GBHomeViewController alloc] init]];
    self.window.rootViewController = self.navigationController;
}

- (void)setupLoginView {
    //清除数据
    [[RawCacheManager sharedRawCacheManager] clearLoginCache];
    
    GBLoginViewController *loginVC  = [[GBLoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed = YES;
    GBNavigationController *searchNav = [[GBNavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:searchNav animated:YES completion:^{}];
}

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupMainView) name:Notification_ShowMainView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupLoginView) name:Notification_NeedLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:Notification_ChangeLanguageRestart object:nil];
}

#pragma mark - 语言切换重启
- (void)changeLanguage {
    
}

@end
