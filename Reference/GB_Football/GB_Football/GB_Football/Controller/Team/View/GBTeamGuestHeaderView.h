//
//  GBTeamGuestHeaderView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBAvatorView.h"

@class GBTeamGuestHeaderView;
@protocol GBTeamGuestHeaderViewDelegate <NSObject>

@optional
- (void)didClickHeaderView:(GBTeamGuestHeaderView *)headerView;

- (void)didClickCreateTeam:(GBTeamGuestHeaderView *)headerView;

- (void)didClickJoinTeam:(GBTeamGuestHeaderView *)headerView;


@end

@interface GBTeamGuestHeaderView : UIView

@property (weak, nonatomic) IBOutlet GBAvatorView *avatorView;
@property (weak, nonatomic) IBOutlet UIImageView *modifyImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamDescLabel;

@property (weak, nonatomic) IBOutlet UIView *noTeamView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (nonatomic, assign) BOOL userNoTeam;
@property (nonatomic, assign) BOOL homeTeam;
@property (nonatomic, weak) id<GBTeamGuestHeaderViewDelegate> delegate;

@end
