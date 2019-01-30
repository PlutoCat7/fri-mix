//
//  GBSystemSettingViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSystemSettingViewController.h"
#import "GBHomePageViewController.h"
#import "GBWebBrowserViewController.h"
#import "GBModifyAccViewController.h"
#import "GBModifyPwdViewController.h"

#import "GBAlertView.h"

@interface GBSystemSettingViewController ()
// 版本号
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation GBSystemSettingViewController

#pragma mark -
#pragma mark Memory

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBHomePageViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Action
- (IBAction)actionModifyAccount:(id)sender {
    
    [self.navigationController pushViewController:[[GBModifyAccViewController alloc]init] animated:YES];
}

- (IBAction)actionModifyPassword:(id)sender {
    
    [self.navigationController pushViewController:[[GBModifyPwdViewController alloc]init] animated:YES];
}

- (IBAction)actionReadMe:(id)sender {
    
    GBWebBrowserViewController *webController = [[GBWebBrowserViewController alloc] initWithTitle:LS(@"使用说明") url:Tgoal_Introduce];
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)actionLogout {
    
    [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NeedLogin object:nil];
        }
    } title:LS(@"温馨提示") message:LS(@"您确定要退出团队之芯吗？") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"确定")];
}

#pragma mark - Private

- (void)setupUI {
    
    self.title = LS(@"系统设置");
    [self setupBackButtonWithBlock:nil];
    [self setupNavigationRightItem];
    
    self.versionLabel.text = [Utility appVersion];
}

- (void)setupNavigationRightItem {
    
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBtn setSize:CGSizeMake(80, 24)];
    [tmpBtn.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [tmpBtn setTitle:LS(@"退出登录") forState:UIControlStateNormal];
    [tmpBtn setTitle:LS(@"退出登录") forState:UIControlStateHighlighted];
    [tmpBtn setTitleColor:[UIColor colorWithHex:0xff0000] forState:UIControlStateNormal];
    [tmpBtn setTitleColor:[UIColor colorWithHex:0xff0000 andAlpha:0.8f] forState:UIControlStateHighlighted];
    tmpBtn.backgroundColor = [UIColor clearColor];
    [tmpBtn addTarget:self action:@selector(actionLogout) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:tmpBtn];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
}

@end
