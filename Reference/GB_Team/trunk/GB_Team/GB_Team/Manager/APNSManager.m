//
//  APNSManager.m
//  GB_Football
//
//  Created by 王时温 on 2016/12/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "APNSManager.h"

#import "GBRecordPlayerListViewController.h"
#import "GBAlertView.h"
#import "AppDelegate.h"

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
    
    PushItem *pushItem = [[PushItem alloc] initWithDictionary:dic];
    
    if (pushItem == nil) {
        return;
    }
    
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if (applicationState == UIApplicationStateInactive) {
        // 直接处理push消息
        [self disposePush:pushItem needLogin:YES];
        
    } else if (applicationState == UIApplicationStateActive) {
        if (self.alertView) {
            [self.alertView dismiss];
        }
        

        self.alertView = [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self disposePush:pushItem needLogin:YES];
            }
            self.alertView = nil;
        } title:LS(@"温馨提示") message:pushItem.title ? pushItem.title : @"" cancelButtonName:LS(@"忽略") otherButtonTitle:LS(@"去看看")];
        
    }
}

#pragma mark - Private

/**
 处理消息

 @param pushItem 推送信息
 @param needLogin 是否需要用户登录
 */
- (BOOL)disposePush:(PushItem *)pushItem needLogin:(BOOL)needLogin
{
    if (!pushItem) {
        return NO;
    }
    
    if ( needLogin && !([RawCacheManager sharedRawCacheManager].isLastLogined && [RawCacheManager sharedRawCacheManager].userInfo)) {   //未登录
        return NO;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigationController = delegate.navigationController;
    if (pushItem.type == PushType_MatchData) {
        GBRecordPlayerListViewController *controller = (GBRecordPlayerListViewController *)[Utility findController:navigationController class:[GBRecordPlayerListViewController class]];
        
        if (!controller) {
            controller = [[GBRecordPlayerListViewController alloc] initWithMatchId:pushItem.msgId];
            [navigationController pushViewController:controller animated:YES];
        } else {
            [navigationController popToViewController:controller animated:YES];
            controller.matchId = pushItem.msgId;
        }
    }
    return YES;
}

@end
