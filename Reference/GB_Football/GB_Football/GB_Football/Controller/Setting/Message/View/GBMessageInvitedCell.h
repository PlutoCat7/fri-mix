//
//  GBMessageInvitedCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/1.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBHightLightButton.h"

@class GBMessageInvitedCell;
@protocol GBMessageInvitedCellDelegate <NSObject>

- (void)didClickJoinButton:(GBMessageInvitedCell *)cell;

@end

@interface GBMessageInvitedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *matchNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *createNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchAddressLabel;
@property (weak, nonatomic) IBOutlet GBHightLightButton *joinButton;
@property (weak, nonatomic) IBOutlet UILabel *overLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, weak) id<GBMessageInvitedCellDelegate> delegate;

@end
