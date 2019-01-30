//
//  NoRemindManager.h
//  管理app中不再提醒
//
//  Created by Pizza on 2017/3/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoRemindManager : NSObject

+ (NoRemindManager *)sharedInstance;
// V1版本演示教程
@property (nonatomic, assign) BOOL tutorialPagesV1;
// 切换模式
@property (nonatomic, assign) BOOL tutorialMaskFootBall;
// 赛后设置
@property (nonatomic, assign) BOOL tutorialMaskCompletGame;
// 球队创建教程
@property (nonatomic, assign) BOOL tutorialMaskTeam;
// 首页足球模式
@property (nonatomic, assign) BOOL tutorialMaskMenu;
// 切换至足球模式成功
@property (nonatomic, assign) BOOL sportModeSwitchSuccess;
// 切换到足球模式提醒晴空清空数据
@property (nonatomic, assign) BOOL footBallModeClearData;
// 多节模式教程
@property (nonatomic, assign) BOOL tutorialMultiMode;

//新球队模块引导图标
@property (nonatomic, assign) BOOL tutorialNewTeamIcon;

@end
