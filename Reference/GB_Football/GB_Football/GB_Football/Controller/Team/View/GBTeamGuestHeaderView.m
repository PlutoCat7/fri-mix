//
//  GBTeamGuestHeaderView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamGuestHeaderView.h"

@implementation GBTeamGuestHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self localizeUI];
    self.avatorView.bgColor = [UIColor colorWithHex:0x252525];
}

- (void)localizeUI {
    
    [self.createButton setTitle:LS(@"team.home.create.team") forState:UIControlStateNormal];
    [self.joinButton setTitle:LS(@"team.home.join.team") forState:UIControlStateNormal];
}

- (void)setUserNoTeam:(BOOL)userNoTeam {
    
    _userNoTeam = userNoTeam;
    if (userNoTeam) {
        self.avatorView.avatorImageView.image = [UIImage imageNamed:@"portrait"];
        self.noTeamView.alpha = 1;
        self.teamNameLabel.alpha = 0;
        self.teamDescLabel.alpha = 0;
        self.modifyImageView.alpha = 0;
    }else {
        self.noTeamView.alpha = 0;
        self.teamNameLabel.alpha = 1;
        self.teamDescLabel.alpha = 1;
        self.modifyImageView.alpha = self.homeTeam ? 1 : 0;
    }
}

- (void)setHomeTeam:(BOOL)homeTeam {
    
    _homeTeam = homeTeam;
    if (self.userNoTeam) {
        self.avatorView.avatorImageView.image = [UIImage imageNamed:@"portrait"];
        self.noTeamView.alpha = 1;
        self.teamNameLabel.alpha = 0;
        self.teamDescLabel.alpha = 0;
        self.modifyImageView.alpha = 0;
    }else {
        self.noTeamView.alpha = 0;
        self.teamNameLabel.alpha = 1;
        self.teamDescLabel.alpha = 1;
        self.modifyImageView.alpha = self.homeTeam ? 1 : 0;
    }
}

#pragma mark - Action
- (IBAction)actionJoin:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickJoinTeam:)]) {
        [self.delegate didClickJoinTeam:self];
    }
}
- (IBAction)actionCreate:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickCreateTeam:)]) {
        [self.delegate didClickCreateTeam:self];
    }
}
- (IBAction)actionBackground:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickHeaderView:)]) {
        [self.delegate didClickHeaderView:self];
    }
}

@end
