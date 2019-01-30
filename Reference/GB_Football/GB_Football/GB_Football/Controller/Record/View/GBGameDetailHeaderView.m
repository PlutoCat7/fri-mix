//
//  GBGameDetailHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/16.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameDetailHeaderView.h"
#import "GBProgressCircle.h"
#import "POPNumberAnimation.h"

@interface GBGameDetailHeaderView () <POPNumberAnimationDelegate>

// 主队名称
@property (weak, nonatomic) IBOutlet UILabel *hostNameLabel;
// 客队名称
@property (weak, nonatomic) IBOutlet UILabel *enemyNameLabel;
// 主队得分
@property (weak, nonatomic) IBOutlet UILabel *hostScoreLabel;
// 客队得分
@property (weak, nonatomic) IBOutlet UILabel *enemyScoreLabel;
// 持续时间
@property (weak, nonatomic) IBOutlet UILabel *duringTimeLabel;
// 比赛时间进度环
@property (weak, nonatomic) IBOutlet GBProgressCircle *progressCircle;
// 数字动画
@property (strong, nonatomic) POPNumberAnimation* numberAnimation;

// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *homeStLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitStLabel;
@property (weak, nonatomic) IBOutlet UILabel *hStLabel;
@property (weak, nonatomic) IBOutlet UILabel *vStLabel;

@end

@implementation GBGameDetailHeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localizeUI];
}

- (void)localizeUI{
    self.homeStLabel.text   = LS(@"gamedata.label.team.home");
    self.visitStLabel.text  = LS(@"gamedata.label.team.visting");
    self.hStLabel.text      = LS(@"gamedata.label.score.home");
    self.vStLabel.text      = LS(@"gamedata.label.score.visting");
}

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo {
    
    self.hostNameLabel.text = [NSString stringIsNullOrEmpty:matchInfo.host_team]?[RawCacheManager sharedRawCacheManager].userInfo.teamName:matchInfo.host_team;
    self.enemyNameLabel.text = matchInfo.follow_team;
    self.hostScoreLabel.text = @(matchInfo.homeScore).stringValue;
    self.enemyScoreLabel.text = @(matchInfo.guestScore).stringValue;
    NSInteger gameTime = 0;
    if (matchInfo.gameType == GameType_Standard || matchInfo.gameType == GameType_Team) {
        gameTime = [[NSDate dateWithTimeIntervalSince1970:matchInfo.firstEndTime] minutesAfterDate:[NSDate dateWithTimeIntervalSince1970:matchInfo.firstStartTime]] + [[NSDate dateWithTimeIntervalSince1970:matchInfo.secondEndTime] minutesAfterDate:[NSDate dateWithTimeIntervalSince1970:matchInfo.secondStartTime]];
    }else {
        for (MatchSectonInfo *info in matchInfo.split) {
            gameTime += [[NSDate dateWithTimeIntervalSince1970:info.end_time] minutesAfterDate:[NSDate dateWithTimeIntervalSince1970:info.start_time]];
        }
    }
    self.duringTimeLabel.text = @(gameTime).stringValue;
    
    // 动画效果
    [self.progressCircle setPercent:[self timePercent:gameTime]];
    self.numberAnimation.toValue = gameTime;
    [self.numberAnimation saveValues];
    [self.numberAnimation startAnimation];
}

#pragma mark - Private

-(CGFloat)timePercent:(NSInteger)gameTime
{
    return gameTime>=90 ? 1.f : gameTime*1.0f/90;
}

#pragma mark - Setter and Getter

- (POPNumberAnimation *)numberAnimation {
    
    if (!_numberAnimation) {
        _numberAnimation = [[POPNumberAnimation alloc]init];
        _numberAnimation.delegate = self;
        _numberAnimation.fromValue      = 0;
        _numberAnimation.duration       = 1.8f;
    }
    
    return _numberAnimation;
}

#pragma mark - POPNumberAnimationDelegate

- (void)POPNumberAnimation:(POPNumberAnimation *)numberAnimation currentValue:(CGFloat)currentValue
{
    self.duringTimeLabel.text = [NSString stringWithFormat:@"%td", (NSInteger)currentValue];
}

@end
