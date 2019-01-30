//
//  GBMatchInviteNotAcceptFriendCollectionCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBMatchInviteNotAcceptFriendCollectionCell;
@protocol GBMatchInviteNotAcceptFriendCollectionCellDelegate <NSObject>

- (void)didClcikRetryInviteButton:(GBMatchInviteNotAcceptFriendCollectionCell *)cell;

@end

@interface GBMatchInviteNotAcceptFriendCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (nonatomic, weak) id<GBMatchInviteNotAcceptFriendCollectionCellDelegate> delegate;

@end
