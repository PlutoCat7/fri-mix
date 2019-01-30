//
//  APNSManager.m
//  GB_Football
//
//  Created by 王时温 on 2016/12/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "APNSManager.h"
#import "GBFriendBaseViewController.h"
#import "GBRecordDetailViewController.h"
#import "GBWKWebViewController.h"
#import "GBFootBallModeViewController.h"
#import "GBSyncDataViewController.h"

#import "GBAlertInviteView.h"
#import "GBAlertRemovedView.h"
#import "GBAlertTeamInviteView.h"
#import "GBAlertTeamApplyView.h"
#import "GBAlertViewOneWay.h"

#import "AppDelegate.h"
#import "PushMatchInviteItem.h"
#import "PushTeamInviteItem.h"
#import "PushTeamApplyItem.h"
#import "PushTeamAcceptItem.h"
#import "MatchLogic.h"
#import "TeamLogic.h"

@interface APNSManager ()

@property (nonatomic, strong) GBAlertView *alertView;

@end

@implementation APNSManager

+ (instancetype)shareInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[APNSManager alloc] init];
    });
    return instance;
}

#pragma mark - Public

- (void)pushNotificationWithDictionary:(NSDictionary *)dic {
    
    PushBaseItem *pushItem = [[PushBaseItem alloc] initWithDictionary:dic];
    
    if (pushItem == nil) {
        return;
    }
    
    switch (pushItem.type) {
        case PushType_Friend:
            [self handleFriendAPNSWithItem:pushItem];
            break;
        case PushType_MatchData:
            [self handleMatchDataAPNSWithItem:pushItem];
            break;
        case PushType_MatchInvite:
            [self handleMatchInviteAPNSWithItem:pushItem];
            break;
        case PushType_TEAM_APPLY:
        case PushType_TEAM_ACCEPT_APPLY:
        case PushType_TEAM_REFUSE_APPLY:
        case PushType_TEAM_INVITE:
        case PushType_TEAM_ACCEPT_INVITE:
        case PushType_TEAM_APPOINT_LEADER_DEPUTY:
        case PushType_TEAM_REMOVE_LEADER_DEPUTY:
        case PushType_TEAM_DISMISS:
        case PushType_TEAM_TRAN:
            [self handleTeamInviteAPNSWithItem:pushItem];
            break;
            
        case PushType_InsideWeb:
        case PushType_OutsideWeb:
        {
            PushItem *realPushItem = [[PushItem alloc] initWithDictionary:dic];
            [self disposePush:realPushItem needLogin:YES];
        }
            break;
            
        default:
        {
            [self disposePush:pushItem needLogin:YES];
        }
            break;
    }
    
}

- (void)pushSystemMessage:(MessageInfo *)messageInfo {
    
    if (!messageInfo) {
        return;
    }
    
    PushItem *item = [[PushItem alloc] init];
    item.type = (PushType)messageInfo.type;
    item.title = messageInfo.title;
    item.content = messageInfo.content;
    item.param_url = messageInfo.param_url;
    item.param_id = messageInfo.param_id;
    item.param_uri = messageInfo.param_uri;
    
    [self disposePush:item needLogin:YES];
}

- (void)pushShopItem:(ShopItemInfo *)itemInfo {
    
    if (!itemInfo) {
        return;
    }
    
    PushItem *item = [[PushItem alloc] init];
    item.type = (PushType)itemInfo.type;
    item.param_url = itemInfo.param_url;
    item.param_id = itemInfo.param_id;
    item.param_uri = itemInfo.param_uri;
    item.title = itemInfo.title;
    item.content = itemInfo.content;
    
    [self disposePush:item needLogin:YES];
}

- (BOOL)pushSplash:(SplashInfo *)info {
    
    if (!info) {
        return NO;
    }
    
    PushItem *item = [[PushItem alloc] init];
    item.type = info.type;
    item.param_url = info.param_url;
    item.param_id = info.param_id;
    item.param_uri = info.param_uri;
    item.title = info.title;
    item.content = info.content;
    
    return [self disposePush:item needLogin:NO];
}

#pragma mark - Private

- (void)handleFriendAPNSWithItem:(PushBaseItem *)pushItem {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Friend_SomeOne_add_RightAway object:nil];
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if (applicationState == UIApplicationStateInactive) {
        
        [self disposePush:pushItem needLogin:YES];
    } else if (applicationState == UIApplicationStateActive) {
        if (pushItem.type == PushType_Friend || pushItem.type == PushType_MatchData) {
            if (self.alertView) {
                [self.alertView dismiss];
            }
            self.alertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self disposePush:pushItem needLogin:YES];
                }
                self.alertView = nil;
            } title:LS(@"common.popbox.title.tip") message:pushItem.title ? pushItem.title : @"" cancelButtonName:LS(@"common.btn.ignore") otherButtonTitle:LS(@"common.btn.go") style:GBALERT_STYLE_NOMAL];
        }
    }
}

- (void)handleMatchDataAPNSWithItem:(PushBaseItem *)pushItem {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Match_Handle_Complete object:nil];
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if (applicationState == UIApplicationStateInactive) {
        
        [self disposePush:pushItem needLogin:YES];
    } else if (applicationState == UIApplicationStateActive) {
        if (pushItem.type == PushType_Friend || pushItem.type == PushType_MatchData) {
            if (self.alertView) {
                [self.alertView dismiss];
            }
            self.alertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self disposePush:pushItem needLogin:YES];
                }
                self.alertView = nil;
            } title:LS(@"common.popbox.title.tip") message:pushItem.title ? pushItem.title : @"" cancelButtonName:LS(@"common.btn.ignore") otherButtonTitle:LS(@"common.btn.go") style:GBALERT_STYLE_NOMAL];
        }
    }
}

- (void)handleMatchInviteAPNSWithItem:(PushBaseItem *)pushItem {
    
    PushMatchInviteItem *item = [[PushMatchInviteItem alloc] initWithDictionary:pushItem.pushDict];
    if (item.inviteType == PushMatchInviteItemType_Remove) {
        [GBAlertRemovedView alertWithUserName:item.creatorName matchName:item.matchName];
        [[RawCacheManager sharedRawCacheManager].userInfo clearMatchInfo];
        [self disposePush:item needLogin:YES];
    }else {
        [GBAlertInviteView alertWithImageUrl:item.creatorImageUrl name:item.creatorName matchName:item.matchName courtName:item.courtName CallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self disposePush:item needLogin:YES];
            }
        }];
    }
}

- (void)handleTeamInviteAPNSWithItem:(PushBaseItem *)pushItem {
    
    PushTeamItem *item = [[PushTeamItem alloc] initWithDictionary:pushItem.pushDict];
    if (item.type == PushType_TEAM_INVITE) {
        PushTeamInviteItem *realItem = [[PushTeamInviteItem alloc] initWithDictionary:pushItem.pushDict];
        [GBAlertTeamInviteView alertWithImageUrl:realItem.image_url name:realItem.nick_name teamName:realItem.teamName CallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self disposePush:realItem needLogin:YES];
            }
        }];
    }else if (item.type == PushType_TEAM_APPLY){
        PushTeamApplyItem *realItem = [[PushTeamApplyItem alloc] initWithDictionary:pushItem.pushDict];
        [GBAlertTeamApplyView alertWithImageUrl:realItem.image_url name:realItem.nick_name CallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) { //拒绝
                [TeamLogic disposeTeamApplyWithUserId:realItem.ope_user_id agree:NO handler:nil];
            }else if (buttonIndex == 1) { //同意
                [TeamLogic disposeTeamApplyWithUserId:realItem.ope_user_id agree:YES handler:nil];
            }
        }];
    }else if (item.type == PushType_TEAM_ACCEPT_APPLY){
        PushTeamAcceptItem *realItem = [[PushTeamAcceptItem alloc] initWithDictionary:pushItem.pushDict];
        [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:[NSString stringWithFormat:@"%@ %@", realItem.nick_name, LS(@"team.agree.add")] button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        
        [TeamLogic hasAddTeamWithTeamId:realItem.team_id];
        
    }else if (item.type == PushType_TEAM_REFUSE_APPLY){
        [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:[NSString stringWithFormat:@"%@ %@", item.nick_name, LS(@"team.refuse.add")] button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        
    }else if (item.type == PushType_TEAM_ACCEPT_INVITE){
        [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:[NSString stringWithFormat:@"%@ %@", item.nick_name, LS(@"team.has.add")] button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Need_Refresh object:nil];
    }else if (item.type == PushType_TEAM_APPOINT_LEADER_DEPUTY){
        [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:LS(@"team.has.vice.captain") button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Need_Refresh object:@(item.type)];
    }else if (item.type == PushType_TEAM_TRAN){
        [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:LS(@"team.has.captain") button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Need_Refresh object:nil];
    }else if (item.type == PushType_TEAM_REMOVE_LEADER_DEPUTY){
        [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:LS(@"team.refuse.vice.captain") button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Need_Refresh object:@(item.type)];
    }else if (item.type == PushType_TEAM_DISMISS){
        [GBAlertViewOneWay showWithTitle:LS(@"common.popbox.title.tip") content:LS(@"team.message.tick.out") button:LS(@"sync.popbox.btn.got.it") onOk:nil style:GBALERT_STYLE_SURE_GREEN];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_RemoveSuccess object:nil];
    }
}

/**
 处理消息

 @param pushItem 推送信息
 @param needLogin 是否需要用户登录
 */
- (BOOL)disposePush:(PushBaseItem *)pushItem needLogin:(BOOL)needLogin
{
    if (!pushItem) {
        return NO;
    }
    
    if ( needLogin && !([RawCacheManager sharedRawCacheManager].isLastLogined && [RawCacheManager sharedRawCacheManager].userInfo)) {   //未登录
        return NO;
    }
    
    if ([[UpdateManager shareInstance] checkNeedAppUpdateWithPushType:pushItem.type]) {
        return NO;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = delegate.navigationController;
    switch (pushItem.type) {
        case PushType_None:
            break;
            
        case PushType_Friend:
        {
            GBFriendBaseViewController *controller = (GBFriendBaseViewController *)[Utility findController:navigationController class:[GBFriendBaseViewController class]];
            if (!controller) {
                controller = [[GBFriendBaseViewController alloc] init];
                [controller goToNewFriend];
                [navigationController pushViewController:controller animated:YES];
                
            } else {
                [controller goToNewFriend];
                [navigationController popToViewController:controller animated:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Friend_SomeOne_add object:nil];
            return YES;
        }
            break;
        case PushType_MatchData:
        {
            PushItem *realItem = [[PushItem alloc] initWithDictionary:pushItem.pushDict];
            GBRecordDetailViewController *controller = (GBRecordDetailViewController *)[Utility findController:navigationController class:[GBRecordDetailViewController class]];
            if (!controller) {
                controller = [[GBRecordDetailViewController alloc] init];
                controller.matchId = realItem.msgId;
                [navigationController pushViewController:controller animated:YES];
                
            } else {
                [navigationController popToViewController:controller animated:YES];
                controller.matchId = realItem.msgId;
                [controller reloadData];
                
            }
            return YES;
        }
            break;
        case PushType_InsideWeb:
        {
            PushItem *realItem = (PushItem *)pushItem;
            GBWKWebViewController *vc = [[GBWKWebViewController alloc]initWithTitle:pushItem.title content:pushItem.content webUrl:realItem.param_url];
            [navigationController pushViewController:vc animated:YES];
            return YES;
        }
            break;
        case PushType_OutsideWeb:
        {
            // 统计外链打开次数
            [UMShareManager event:Analy_Click_Outside_Url];
            
            PushItem *realItem = (PushItem *)pushItem;
            if (![self tryToOpenInApp:realItem]) {
                [self tryToOpenInSafari:realItem];
            }
            return YES;
        }
            break;
        case PushType_MatchInvite:
        {
            PushMatchInviteItem *inviteItem = (PushMatchInviteItem *)pushItem;
            if (inviteItem.inviteType == PushMatchInviteItemType_Invite) {
                [delegate.window showLoadingToast];
                [MatchLogic joinMatchGameWithMatchId:inviteItem.matchId creatorId:inviteItem.creatorId handler:^(NSError *error) {
                    
                    [delegate.window dismissToast];
                    if (error) {
                        [delegate.window showToastWithText:error.domain];
                    }
                }];
            }else {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DeleteMatchSuccess object:nil];
            }
        }
            return YES;
        case PushType_TEAM_INVITE:
        {
            PushTeamInviteItem *inviteItem = (PushTeamInviteItem *)pushItem;
            [delegate.window showLoadingToast];
            [TeamLogic joinTeamWithTeamId:inviteItem.teamId handler:^(NSError *error) {
                
                [delegate.window dismissToast];
                if (error) {
                    [delegate.window showToastWithText:error.domain];
                }
            }];
            
        }
            return YES;
        case PushType_TEAM_ACCEPT_INVITE:
            return YES;
        case PushType_TEAM_APPLY:
            return YES;
        case PushType_TEAM_ACCEPT_APPLY:
            return YES;
        case PushType_TEAM_REFUSE_APPLY:
            return YES;
        case PushType_TEAM_APPOINT_LEADER_DEPUTY:
        case PushType_TEAM_REMOVE_LEADER_DEPUTY:
        case PushType_TEAM_DISMISS:
        case PushType_TEAM_TRAN:
            return YES;
        default:   //不在定义的推送类型中， 提示升级app
        {
            [[UIApplication sharedApplication].keyWindow showToastWithText:@"请更新至最新的app"];
        }
            break;
    }
    return NO;
}

- (BOOL)tryToOpenInApp:(PushItem *)item {
    
    if ([NSString stringIsNullOrEmpty:item.param_uri]) {
        return NO;
    }
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.param_uri]];
}

- (BOOL)tryToOpenInSafari:(PushItem *)item {
    
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.param_url]];
}

#pragma mark - Test

- (void)Test_ShowTeamInviteAlertView {
    
    [GBAlertTeamInviteView alertWithImageUrl:@"" name:@"罗纳尔多" teamName:@"皇家马德里" CallBackBlock:nil];
}

- (void)Test_ShowTeamApplyAlertView {
    
    [GBAlertTeamApplyView alertWithImageUrl:@"" name:@"罗纳尔多" CallBackBlock:nil];
}

@end
