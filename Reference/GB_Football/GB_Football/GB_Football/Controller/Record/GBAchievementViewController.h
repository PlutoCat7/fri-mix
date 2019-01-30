//
//  GBAchievementViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//  成就

#import "GBBaseViewController.h"

#import "MatchInfo.h"

@interface GBAchievementViewController : GBBaseViewController

- (instancetype)initWithAchieve:(MatchAchieveInfo *)achieveInfo isShowShare:(BOOL)isShowShare;

@end
