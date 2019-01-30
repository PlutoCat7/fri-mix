//
//  GBMatchInviteFriendCollectionCell.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBMatchInviteFriendCollectionCell;
@protocol GBMatchInviteFriendCollectionCellDelegate <NSObject>

- (void)didClickDeleteButton:(GBMatchInviteFriendCollectionCell *)cell;

@end

@interface GBMatchInviteFriendCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, weak) id<GBMatchInviteFriendCollectionCellDelegate> delegate;

@end
