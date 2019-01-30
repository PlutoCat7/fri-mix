//
//  AppDelegate+AppUI.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/7/31.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "AppDelegate+AppUI.h"

#import "MainViewController.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"

@implementation AppDelegate (AppUI)

- (void)setupUI {
    
    [self styleUIForApp];
    [self initWindow];
}

// app总体风格设置
- (void)styleUIForApp
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //输入框颜色
    [[UITextField appearance] setTintColor:[ColorManager styleColor]];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    //导航背景色
    [UINavigationBar appearance].barTintColor = [ColorManager styleColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName:[UIFont systemFontOfSize:18.f]};
}

- (void)initWindow {
    
    // 制定导航控制器和窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self setupFirstView];
    [self.window makeKeyAndVisible];
}

- (void)setupFirstView {
    
    [self setupMainView];
}

- (void)setupMainView {
    
    self.navigationController = [[UINavigationController alloc] initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.viewControllers = @[[MainViewController CreateMainViewController]];
    self.window.rootViewController = self.navigationController;
}

@end
