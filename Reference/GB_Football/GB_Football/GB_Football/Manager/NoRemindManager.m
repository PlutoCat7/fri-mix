//
//  NoRemindManager.m
//  管理app中不再提醒
//
//  Created by Pizza on 2017/3/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "NoRemindManager.h"

NSString *const kTutorialPagesV1            = @"kTutorialPagesV1";

NSString *const kTutorialMaskFootBall       = @"kTutorialMaskFootBall";

NSString *const kTutorialMaskCompletGame    = @"kTutorialMaskCompletGame";

NSString *const kTutorialMaskTeam           = @"kTutorialMaskTeam";

NSString *const kSportModeSwitchSuccess     = @"kSportModeSwitchSuccess";

NSString *const kFootBallModeClearData      = @"kFootBallModeClearData";

NSString *const kTutorialMaskMenu           = @"kTutorialMaskMenu";

NSString *const kTutorialMultiMode          = @"kTutorialMultiMode";

NSString *const kTutorialNewTeamIcon          = @"kTutorialNewTeamIcon";


@implementation NoRemindManager

+ (NoRemindManager *)sharedInstance {
    
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[NoRemindManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!self.tutorialNewTeamIcon) { //未显示过
            if (!self.tutorialPagesV1) { //且未显示过教程
                //new icon 已显示
                self.tutorialNewTeamIcon = YES;
            }
        }
    }
    return self;
}

-(void)setTutorialMaskMenu:(BOOL)tutorialMaskMenu
{
    [[NSUserDefaults standardUserDefaults] setBool:tutorialMaskMenu forKey:kTutorialMaskMenu];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)tutorialMaskMenu
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialMaskMenu];
}

-(void)setTutorialPagesV1:(BOOL)tutorialPagesV1
{
    [[NSUserDefaults standardUserDefaults] setBool:tutorialPagesV1 forKey:kTutorialPagesV1];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)tutorialPagesV1
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialPagesV1];
}

-(void)setTutorialMaskFootBall:(BOOL)tutorialMaskFootBall
{
    [[NSUserDefaults standardUserDefaults] setBool:tutorialMaskFootBall forKey:kTutorialMaskFootBall];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)tutorialMaskFootBall
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialMaskFootBall];
}

-(void)setTutorialMaskCompletGame:(BOOL)tutorialMaskCompletGame
{
    [[NSUserDefaults standardUserDefaults] setBool:tutorialMaskCompletGame forKey:kTutorialMaskCompletGame];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)tutorialMaskCompletGame
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialMaskCompletGame];
}

-(void)setTutorialMaskTeam:(BOOL)tutorialMaskTeam
{
    [[NSUserDefaults standardUserDefaults] setBool:tutorialMaskTeam forKey:kTutorialMaskTeam];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)tutorialMaskTeam
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialMaskTeam];
}

-(void)setFootBallModeClearData:(BOOL)footBallModeClearData
{
    [[NSUserDefaults standardUserDefaults] setBool:footBallModeClearData forKey:kFootBallModeClearData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)footBallModeClearData
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFootBallModeClearData];
}

-(void)setSportModeSwitchSuccess:(BOOL)sportModeSwitchSuccess
{
    [[NSUserDefaults standardUserDefaults] setBool:sportModeSwitchSuccess forKey:kSportModeSwitchSuccess];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)sportModeSwitchSuccess
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSportModeSwitchSuccess];
}

-(void)setTutorialMultiMode:(BOOL)tutorialMultiMode
{
    [[NSUserDefaults standardUserDefaults] setBool:tutorialMultiMode forKey:kTutorialMultiMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)tutorialMultiMode
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialMultiMode];
}

- (void)setTutorialNewTeamIcon:(BOOL)tutorialNewTeamIcon {
    
    [[NSUserDefaults standardUserDefaults] setBool:tutorialNewTeamIcon forKey:kTutorialNewTeamIcon];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)tutorialNewTeamIcon {
    
    BOOL newIcon = [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialNewTeamIcon];
    return newIcon;
}

@end
