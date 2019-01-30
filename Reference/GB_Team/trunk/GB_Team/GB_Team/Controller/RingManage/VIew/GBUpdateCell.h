//
//  GBUpdateCell.h
//  GB_Team
//
//  Created by Pizza on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBUpdateSlider.h"
#import "GBSpringButton.h"

@class GBUpdateCell;
@protocol GBUpdateCellDelegate <NSObject>
@optional
// 点击按下了检查更新按钮
- (void)didPressCheckUpdateButtonWithGBUpdateCell:(GBUpdateCell *)cell;
// 点击并按下了重试按钮
- (void)didPressRetryUpdateButtonWithGBUpdateCell:(GBUpdateCell *)cell;
@end


typedef NS_ENUM(NSUInteger, UPDATE_STATE)
{
    STATE_INIT,             // 初始状态
    STATE_WAITING,          // 等待更行
    STATE_UPDATING,         // 更新中
    STATE_FINISHED,         // 更新完成
    STATE_FAIL,             // 更新失败
    STATE_NO_UPDATE,        // 已是最新版本无需更新
};

@interface GBUpdateCell : UITableViewCell

// 手环名称
@property (weak, nonatomic) IBOutlet UILabel *ringNameLabel;
// 手环状态
@property (weak, nonatomic) IBOutlet UILabel *ringStateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *stateActivityIndicator;
// 更新进度条
@property (weak, nonatomic) IBOutlet GBUpdateSlider *slider;
// 单元格状态
@property (assign, nonatomic) UPDATE_STATE state;
// 检测更新按钮
@property (weak, nonatomic) IBOutlet GBSpringButton *checkButton;
// 重试按钮
@property (weak, nonatomic) IBOutlet GBSpringButton *retryButton;
// 对勾图片
@property (weak, nonatomic) IBOutlet UIImageView *yesImageView;
// 按钮点击回调
@property (nonatomic, weak) id<GBUpdateCellDelegate> delegate;

@end
