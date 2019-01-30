//
//  GBTeamSectionHeaderView.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBTeamSectionHeaderView;
@protocol GBTeamSectionHeaderViewDelegate <NSObject>

/**
 点击菜单事件

 @param headerView
 @param itemIndex 菜单索引
 */
- (void)didClickTeamSectionHeaderView:(GBTeamSectionHeaderView *)headerView itemIndex:(NSInteger)itemIndex;

@end

@interface GBTeamSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<GBTeamSectionHeaderViewDelegate> delegate;
- (void)hideNewTeammateView:(BOOL)isHide;

@end
