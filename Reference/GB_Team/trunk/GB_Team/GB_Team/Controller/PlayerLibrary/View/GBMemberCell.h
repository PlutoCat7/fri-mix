//
//  GBMemberCell.h
//  GB_Team
//
//  Created by Pizza on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GBPositionLabel.h"
#import "PlayerResponseInfo.h"

typedef NS_ENUM(NSUInteger, SELECT_STATE) {
    STATE_NOMAL,        // 未编辑未选择
    STATE_DELETE,       // 删除模式
    STATE_UNSELECT,     // 复选模式：未选择
    STATE_SELECTED,     // 复选模式：已选择
};

@interface GBMemberCell : UICollectionViewCell
@property (nonatomic,assign) SELECT_STATE selectState;// cell外观
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet GBPositionLabel *posIcon1;
@property (weak, nonatomic) IBOutlet GBPositionLabel *posIcon2;

- (void)refreshWithPlayer:(PlayerInfo *)playerInfo;

@end
