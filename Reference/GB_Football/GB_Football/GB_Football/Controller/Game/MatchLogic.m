//
//  MatchLogic.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MatchLogic.h"
#import "GBSyncDataViewController.h"
#import "GBFootBallModeViewController.h"
#import "GBGameCreateViewController.h"

#import "AGPSManager.h"
#import "AppDelegate.h"

#import "MatchRequest.h"

@implementation MatchLogic

+ (void)joinMatchGameWithMatchId:(NSInteger)matchId creatorId:(NSInteger)creatorId handler:(void(^)(NSError *error))handler {
    
    [MatchRequest joinMatchWithMatchId:matchId handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, error);
        if (error) {
            
        }else {
            UserMatchInfo *userMatchInfo = [[UserMatchInfo alloc] init];
            userMatchInfo.match_id = matchId;
            userMatchInfo.creator_id = creatorId;
            [RawCacheManager sharedRawCacheManager].userInfo.matchInfo = userMatchInfo
            ;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateMatchSuccess object:nil];
            
            AppDelegate *delegaet = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:delegaet.navigationController.viewControllers];
            if ([viewControllers.lastObject isKindOfClass:[GBGameCreateViewController class]]) {
                [viewControllers removeLastObject];
            }
            // 搜星模式直接进同步页
            switch ([AGPSManager shareInstance].status) {
                case iBeaconStatus_Sport:
                {
                    [viewControllers addObject:[[GBSyncDataViewController alloc] initWithMatchId:matchId showSportCard:NO]];
                }
                    break;
                default:
                {
                    [viewControllers addObject:[[GBFootBallModeViewController alloc] init]];
                }
                    break;
            }
            
            [delegaet.navigationController setViewControllers:viewControllers animated:YES];
        }
    }];
}

//0：时间设置异常   1:时间跨天   2：时间正常
+ (NSInteger)sectionsDateCompare:(NSDate *)oneDate twoDate:(NSDate *)twoDate {
    
    if (([oneDate compare:twoDate] == NSOrderedDescending)) {
        //判断是否处于21-03的时间段
        if (oneDate.hour>=21 && twoDate.hour<=3) {
            //下一天
            NSDate *nextDate = [twoDate dateByAddingDays:1];
            //两者相差不能超过三个小时
            if ([nextDate timeIntervalSinceDate:oneDate]<=3*60*60) {
                //该节所遇跨天
                return 1;
            }else {
                return 0;
            }
        }else {
            return 0;
        }
    }
    return 2;
}

+ (NSDate *)transferTomorrow:(NSDate *)date {
    
    if (date.hour<=3) {
        return [date dateByAddingDays:1];
    }
    return date;
}

@end
