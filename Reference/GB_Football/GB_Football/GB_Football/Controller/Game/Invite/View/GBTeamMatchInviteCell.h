//
//  GBTeamMatchInviteCell.h
//  GB_Football
//
//  Created by gxd on 17/8/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBPositionLabel.h"

typedef NS_ENUM(NSUInteger, TeamGameInviteType) {
    TeamGameInviteType_Selected,  //已选择
    TeamGameInviteType_UnSelected, //未选择
    TeamGameInviteType_NotSelected, //不能被选择
};


@interface GBTeamMatchInviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNumLabel;
@property (weak, nonatomic) IBOutlet GBPositionLabel *playerPosLabel;

@property (nonatomic, assign) TeamGameInviteType type;

@end
