//
//  GBHomePageViewController.m
//  GB_Team
//
//  Created by Pizza on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBHomePageViewController.h"
#import "GBSystemSettingViewController.h"
#import "GBMemberListViewController.h"
#import "GBFieldListViewController.h"
#import "GBTeamListViewController.h"
#import "GBRecordListViewController.h"
#import "GBRingManageViewController.h"
#import "GBSyncDataViewController.h"

#import "GBMenuButton.h"
#import "GBAlertView.h"

#import "SystemRequest.h"

@interface GBHomePageViewController ()
@property (weak, nonatomic) IBOutlet GBMenuButton *createMatchBtn;
// 版本号
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation GBHomePageViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self performBlock:^{//延迟处理，AF网络状态马上获取是提示无网络
        [SystemRequest checkAppVersion:^(id result, NSError *error) {
            
            NSString *appUrl = result;
            if (!error && [appUrl length]>0) {
                [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1) {
                        UIApplication *application = [UIApplication sharedApplication];
                        [application openURL:[NSURL URLWithString:appUrl]];
                    }
                } title:LS(@"温馨提示") message:LS(@"有新版本发布，赶快去更新吧。") cancelButtonName:LS(@"取消") otherButtonTitle:LS(@"更新")];
            }
        }];
    } delay:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - Action
- (IBAction)actionPlayerLibrary:(id)sender {
    
    [self.navigationController pushViewController:[[GBMemberListViewController alloc]init] animated:YES];
}

- (IBAction)actionTeamManage:(id)sender {
    
    [self.navigationController pushViewController:[[GBTeamListViewController alloc]init] animated:YES];
}

- (IBAction)actionCreateGame:(id)sender {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo && userInfo.matchId > 0) {
        [self.navigationController pushViewController:[[GBSyncDataViewController alloc] initWithMatcId:userInfo.matchId] animated:YES];
    } else {
        [self.navigationController pushViewController:[[GBFieldListViewController alloc]init] animated:YES];
    }
}

- (IBAction)actionRingManage:(id)sender {
    
    [self.navigationController pushViewController:[[GBRingManageViewController alloc]init] animated:YES];
}

- (IBAction)actionTeamRecord:(id)sender {
    
    [self.navigationController pushViewController:[[GBRecordListViewController alloc]init] animated:YES];
}

- (IBAction)actionSystemSetting:(id)sender {
    
    [self.navigationController pushViewController:[[GBSystemSettingViewController alloc]init] animated:YES];
}


#pragma mark - Notification

- (void)deleteMatchNotification {
    
    [self updateCreateMatchButton];
}

- (void)createMatchNotification {
    
    [self updateCreateMatchButton];
}

- (void)completeMatchNotification {
    
    [self updateCreateMatchButton];
}

#pragma mark - Private

- (void)setupUI {
    
    self.versionLabel.text = [Utility appVersion];
    
    [self setupNotification];
    [self updateCreateMatchButton];
}

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMatchNotification) name:Notification_CreateMatchSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMatchNotification) name:Notification_DeleteMatchSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeMatchNotification) name:Notification_CompleteMatchSuccess object:nil];
}

- (void)updateCreateMatchButton {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    if (userInfo && userInfo.matchId > 0) {
        [self.createMatchBtn setTitle:LS(@"完成比赛") forState:UIControlStateNormal];
    } else {
        [self.createMatchBtn setTitle:LS(@"创建比赛") forState:UIControlStateNormal];
    }
}

@end
