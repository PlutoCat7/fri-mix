//
//  GBFriendInviteCell.h
//  GB_Football
//
//  Created by Pizza on 16/8/16.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GBNewTeammateCell;
@protocol GBNewTeammateCellDelegate <NSObject>
@optional
- (void)didAcceptCell:(GBNewTeammateCell *)cell;
- (void)didRefuseCell:(GBNewTeammateCell *)cell;
@end

@interface GBNewTeammateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UILabel *joinedLabel;

// 是否是section中的最后一row，用于处理分割线问题
@property (assign,nonatomic)BOOL isLastCell;
// 接受邀请点击按钮回调
@property (nonatomic, weak) id<GBNewTeammateCellDelegate> delegate;

- (void)refreshWithName:(NSString *)name imageUrl:(NSString *)imageUrl;

@end
