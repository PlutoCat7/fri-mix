//
//  GBGameDetailUserInfoView.m
//  GB_Football
//
//  Created by yahua on 2017/8/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameDetailUserInfoView.h"

#import "GBPositionLabel.h"
#import "UIImageView+WebCache.h"

@interface GBGameDetailUserInfoView ()

// 球员姓名
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
// 球衣号码
@property (weak, nonatomic) IBOutlet UILabel *playerNoLabel;
// 球员踢的位置
@property (weak, nonatomic) IBOutlet GBPositionLabel *position1;
// 所属球队
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

// 静态国际化标签
@property (weak, nonatomic) IBOutlet UILabel *playerNameStLabel;
@property (weak, nonatomic) IBOutlet UILabel *noStLabel;
@property (weak, nonatomic) IBOutlet UILabel *postionStLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamStLabel;

@end

@implementation GBGameDetailUserInfoView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self localizeUI];
    [self refreshUI];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.headImageView.layer setCornerRadius:self.headImageView.width/2];
    [self.headImageView.layer setMasksToBounds:YES];
}

#pragma mark - Setter & Getter
- (void)setMatchUserInfo:(MatchUserInfo *)matchUserInfo {
    _matchUserInfo = matchUserInfo;
    
    [self refreshUI];
}

#pragma mark - Private

- (void)localizeUI {
    
    self.playerNameStLabel.text = LS(@"full.label.name");
    self.noStLabel.text = LS(@"full.label.number");
    self.postionStLabel.text = LS(@"full.label.positon");
    self.teamStLabel.text = LS(@"full.label.team");
}

- (void)refreshUI {
    
    MatchUserInfo *userInfo = self.matchUserInfo;
    if (userInfo == nil) {
        return;
    }
    
    self.playerNameLabel.text = userInfo.nickName;
    self.playerNoLabel.text = @(userInfo.teamNo).stringValue;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    NSArray *positionList = [userInfo.position componentsSeparatedByString:@","];
    self.position1.index = positionList.count > 0 ? [positionList.firstObject integerValue] : 0;
    
    NSString *teamName = userInfo.teamName.length == 0 ? LS(@"team.info.name.empty") : userInfo.teamName;
    self.teamNameLabel.text = teamName;
}

@end
