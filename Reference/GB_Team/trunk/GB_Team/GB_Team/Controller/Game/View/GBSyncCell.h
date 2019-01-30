//
//  GBSyncCell.h
//  GB_Team
//
//  Created by weilai on 16/9/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBUpdateSlider.h"
#import "GBSpringButton.h"
@class GBSyncCell;
@protocol GBSyncCellDelegate <NSObject>

// 点击并按下了重试按钮
- (void)didPressRetryUpdateButtonWithGBSyncCell:(GBSyncCell *)cell;

@end

typedef NS_ENUM(NSUInteger, Sync_STATE)
{
    STATE_INIT,             // 初始状态
    STATE_UPDATING,         // 更新中
    STATE_FINISHED,         // 更新完成
    STATE_FAIL,             // 更新失败
};

@interface GBSyncCell : UITableViewCell
// 手环名称
@property (weak, nonatomic) IBOutlet UILabel *ringNameLabel;
// 手环状态
@property (weak, nonatomic) IBOutlet UILabel *ringStateLabel;
// 球员名称
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
// 同步进度条
@property (weak, nonatomic) IBOutlet GBUpdateSlider *slider;
// 单元格状态
@property (assign, nonatomic) Sync_STATE state;
// 重试按钮
@property (weak, nonatomic) IBOutlet GBSpringButton *retryButton;
// 对勾图片
@property (weak, nonatomic) IBOutlet UIImageView *yesImageView;
// 同步失败
@property (weak, nonatomic) IBOutlet UILabel *syncFailLabel;

@property (nonatomic, weak) id<GBSyncCellDelegate> delegate;

@end
