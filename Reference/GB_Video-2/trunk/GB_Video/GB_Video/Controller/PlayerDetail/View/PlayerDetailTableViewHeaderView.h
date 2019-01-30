//
//  PlayerDetailTableViewHeaderView.h
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPlayerDetailTableViewHeaderViewHeight (kAppScale*110)

@class PlayerDetailHeaderModel;
@class PlayerDetailTableViewHeaderView;
@protocol PlayerDetailTableViewHeaderViewDelegate <NSObject>

- (void)praiseWithPlayerDetailTableViewHeaderView:(PlayerDetailTableViewHeaderView *)headerView;

- (void)collectionWithPlayerDetailTableViewHeaderView:(PlayerDetailTableViewHeaderView *)headerView;

@end

@interface PlayerDetailTableViewHeaderView : UIView

@property (nonatomic, weak) id<PlayerDetailTableViewHeaderViewDelegate> delegate;

- (void)refreshWithModel:(PlayerDetailHeaderModel *)model;

@end
