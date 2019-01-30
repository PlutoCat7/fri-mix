//
//  GBMenuViewModel.m
//  GB_Football
//
//  Created by yahua on 2017/8/22.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMenuViewModel.h"

#import "NoRemindManager.h"
#import "AGPSManager.h"
#import "UserRequest.h"
#import "SystemRequest.h"

#import "AppDelegate.h"
#import "GBFootBallModeViewController.h"
#import "GBSyncDataViewController.h"
#import "GBGuestGameCompeleteViewController.h"

@interface GBMenuViewModel ()

@property (nonatomic, strong) NewMessageInfo *hasNewMessageInfo;

@end

@implementation GBMenuViewModel

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self resetMenuImage];
        //刷新用户数据
        [UserRequest getUserInfoWithHandler:^(id result, NSError *error) {
            if (!error) {
                [self resetMenuImage];
            }
        }];
        
        //刷新配置信息
        [SystemRequest getCloudConfig:nil];

        //标记为已登录
        [RawCacheManager sharedRawCacheManager].isLastLogined = YES;
        
        [self setupNotification];
    }
    return self;
}

#pragma mark - Public

- (BOOL)isShowCourseMask {
    
    return [NoRemindManager sharedInstance].tutorialMaskMenu == NO
    && [NoRemindManager sharedInstance].tutorialPagesV1 == YES
    && [AGPSManager shareInstance].status == iBeaconStatus_Sport;
}

- (void)checkHasNewMessage {
    
    [MessageRequest checkHasNewMessageWithHandler:^(id result, NSError *error) {
        if (!error) {
            self.hasNewMessageInfo = result;
            self.isNewMessage = (self.hasNewMessageInfo.newMessageSystemCount+self.hasNewMessageInfo.newMessageMatchInviteCount+self.hasNewMessageInfo.newMessageTeamCount)>0;
        }
    }];
}

- (UIImage *)messageIcon {
    
    return self.isNewMessage?[UIImage imageNamed:@"hone_message_remind"]:[UIImage imageNamed:@"hone_message"];
}

- (NSArray<NSString *> *)bigItemNames {
    
    BOOL hasMatch = [RawCacheManager sharedRawCacheManager].userInfo.matchInfo != nil;
    
    return  @[@"STAR CARD",
              @"MY RANKING",
              @"GAME RECORD",
              hasMatch?@"FINISH GAME":@"CREATE GAME",
              @"MY TEAM",
              @"DAILY RECORD",
              @"MY FRIEND",
              @"SYSTEM SETTING"];
}

#pragma mark - Private

- (void)setupNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createMatchNotification) name:Notification_CreateMatchSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMatchNotification) name:Notification_DeleteMatchSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishMatchNotification) name:Notification_FinishMatchSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamNeedRefreshNotification:) name:Notification_Team_Need_Refresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoNotification) name:Notification_Team_CreateSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoNotification) name:Notification_Team_RemoveSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)resetMenuImage {
    
    BOOL hasMatch = [RawCacheManager sharedRawCacheManager].userInfo.matchInfo != nil;
    
    self.bigItemImageNames =  @[@"star_card",
             @"ranking",
             @"record",
             hasMatch?@"complete":@"Create",
             @"menu_team_max",
             @"daily",
             @"friends",
             @"set"];
    
    self.smallItemImageNames =  @[@"menu_card",@"menu_rank",
             @"menu_record",
             hasMatch?@"menu_finish":@"menu_create",
             @"menu_team_min",
             @"menu_day",
             @"menu_friend",
             @"menu_set"];
}

#pragma mark - Notification

- (void)applicationWillEnterForegroundNotification {
    
    [self refreshUserInfoNotification];
    
    //刷新配置信息
    [SystemRequest getCloudConfig:nil];
}

- (void)deleteMatchNotification {
    
    [[RawCacheManager sharedRawCacheManager].userInfo clearMatchInfo];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = delegate.navigationController;
    if([navigationController.topViewController isMemberOfClass:[GBFootBallModeViewController class]] ||
        [navigationController.topViewController isMemberOfClass:[GBSyncDataViewController class]] ||
       [navigationController.topViewController isMemberOfClass:[GBGuestGameCompeleteViewController class]]) {  //防止在非比赛界面返回到首页
        
        [navigationController popToRootViewControllerAnimated:YES];
    }
        
    [self resetMenuImage];
}

- (void)finishMatchNotification {
    
    [self resetMenuImage];
    //刷新最近球场
    [UserRequest getUserInfoWithHandler:nil];
}

- (void)createMatchNotification {
    
    [self resetMenuImage];
}

- (void)teamNeedRefreshNotification:(NSNotification *)notification {
    if (notification.object == nil) {
        return;
    }
    
    PushType type = [notification.object intValue];
    if (type == PushType_TEAM_APPOINT_LEADER_DEPUTY || type == PushType_TEAM_REMOVE_LEADER_DEPUTY) {
        //刷新用户数据
        [UserRequest getUserInfoWithHandler:^(id result, NSError *error) {
            if (!error) {
                [self resetMenuImage];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_BaseInfo object:nil];
            }
        }];
    }
    
}

- (void)refreshUserInfoNotification {
    //刷新用户数据
    [UserRequest getUserInfoWithHandler:^(id result, NSError *error) {
        if (!error) {
            [self resetMenuImage];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_BaseInfo object:nil];
        }
    }];
}

@end
