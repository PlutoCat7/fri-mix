//
//  GBRingCell.h
//  GB_Team
//
//  Created by Pizza on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBRingCell;

typedef NS_ENUM(NSUInteger, RING_STATE)
{
    STATE_NOMAL,        // 未编辑未选择,待检测
    STATE_UNSELECT,     // 复选模式：未选择
    STATE_SELECTED,     // 复选模式：已选择
    STATE_SHOW_BATTERY, // 显示电量
    STATE_FAIL_RETRY,   // 电量获取失败，重试
    STATE_GETTING,      // 正在获取电量
};
@protocol GBRingCellDelegate <NSObject>
-(void)GBRingCell:(GBRingCell*)cell didPressGetBatteryWithState:(RING_STATE)state;
-(void)GBRingCell:(GBRingCell*)cell didDoubleTapsWithState:(RING_STATE)state;
@end

@interface GBRingCell : UITableViewCell
// 手环名称
@property (weak, nonatomic) IBOutlet UILabel *ringNameLabel;
// 手环编号
@property (weak, nonatomic) IBOutlet UILabel *ringNumberLabel;
// 勾选按钮
@property (weak, nonatomic) IBOutlet UIImageView *yesImageView;
// 电量检测
@property (weak, nonatomic) IBOutlet UIButton *batteryButton;
// cell状态
@property (nonatomic,assign) RING_STATE selectState;
// 电量0-100
@property (nonatomic,assign) NSInteger batteryInt;
// 代理
@property (nonatomic,weak) id<GBRingCellDelegate> delegate;
// 正在获取电量指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
