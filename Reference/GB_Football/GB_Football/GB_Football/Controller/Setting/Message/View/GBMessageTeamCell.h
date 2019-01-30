//
//  GBMessageTeamCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBHightLightButton.h"

@class GBMessageTeamCell;
@protocol GBMessageTeamCellDelegate <NSObject>

- (void)didClickAgreeButton:(GBMessageTeamCell *)cell;

- (void)didClickRefuseButton:(GBMessageTeamCell *)cell;

@end

@interface GBMessageTeamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet GBHightLightButton *agreeButton;
@property (weak, nonatomic) IBOutlet GBHightLightButton *refuseButton;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, weak) id<GBMessageTeamCellDelegate> delegate;

@end
