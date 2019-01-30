//
//  TeamLogic.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamLogic.h"
#import "TeamRequest.h"
#import "AppDelegate.h"

#import "GBTeamHomePageViewController.h"

@implementation TeamLogic

+ (void)joinTeamWithTeamId:(NSInteger)teamId handler:(void(^)(NSError *error))handler {
    
    [TeamRequest acceptTeamInviteWithTeamId:teamId handler:^(id result, NSError *error) {
        
        if (error) {
            
        }else {
            [self hasAddTeamWithTeamId:teamId];
        }
        BLOCK_EXEC(handler, error);
    }];
}

+ (void)disposeTeamApplyWithUserId:(NSInteger)userId agree:(BOOL)agree handler:(void(^)(NSError *error))handler {
    
    [TeamRequest disposeUserInvite:userId agree:agree handler:^(id result, NSError *error) {
       
        if (error) {
            [[UIApplication sharedApplication].keyWindow showToastWithText:error.domain];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Need_Refresh object:nil];
        }
        BLOCK_EXEC(handler, error);
    }];
}

+ (void)hasAddTeamWithTeamId:(NSInteger)teamId {
    
    UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
    userInfo.team_mess = [TeamInfo new];
    userInfo.team_mess.teamId = teamId;
    
    AppDelegate *delegaet = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:delegaet.navigationController. viewControllers];
    //判断
    NSArray *removeList = nil;
    for (NSInteger index=0; index<viewControllers.count; index++) {
        UIViewController *vc = viewControllers[index];
        if ([vc isKindOfClass:[GBTeamHomePageViewController class]]) {
            removeList = [viewControllers subarrayWithRange:NSMakeRange(index, viewControllers.count-index)];
            break;
        }
    }
    if (removeList) {
        [viewControllers removeObjectsInArray:removeList];
    }
    [viewControllers addObject:[[GBTeamHomePageViewController alloc] init]];
    
    [delegaet.navigationController setViewControllers:viewControllers animated:YES];

}

@end
