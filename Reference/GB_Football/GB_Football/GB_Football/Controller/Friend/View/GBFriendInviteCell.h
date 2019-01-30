//
//  GBFriendInviteCell.h
//  GB_Football
//
//  Created by Pizza on 16/8/16.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBFriendInviteCell;
@protocol GBFriendInviteCellDelegate <NSObject>
@optional
- (void)GBFriendInviteCell:(GBFriendInviteCell *)cell;
@end

@interface GBFriendInviteCell : UITableViewCell

// 是否是section中的最后一row，用于处理分割线问题
@property (assign,nonatomic)BOOL isLastCell;
// 接受邀请点击按钮回调
@property (nonatomic, weak) id<GBFriendInviteCellDelegate> delegate;

- (void)refreshWithName:(NSString *)name imageUrl:(NSString *)imageUrl;

@end
