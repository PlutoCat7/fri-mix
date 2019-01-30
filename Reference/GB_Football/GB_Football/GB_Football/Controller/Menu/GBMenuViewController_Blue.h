//
//  GBMenuViewController_Blue.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMenuViewController.h"
#import "GBBatteryIndicator.h"

// 足球模式状态
typedef NS_ENUM(NSUInteger,FOOTBALL_MODE_STATE)
{
    FOOTBALL_MODE_STATE_IDLE,           // 模式未转换
    FOOTBALL_MODE_STATE_SWTICHING_Sport,      // 足球模式转换中
    FOOTBALL_MODE_STATE_OK_Sport,             // 足球模式转换OK
    FOOTBALL_MODE_STATE_SWTICHING_Run,      // 跑步模式转换中
    FOOTBALL_MODE_STATE_OK_Run,             // 跑步模式转换OK
};

@interface GBMenuViewController ()

// 已经连接右上角标志 绿色
@property (weak, nonatomic) IBOutlet UIView *connectedView;
// 未连接右上角标志 红色
@property (weak, nonatomic) IBOutlet UIView *unConnectView;
// 绑定手环 右上角标志 红色
@property (weak, nonatomic) IBOutlet UIView *bindConnectView;
// 链接中 右上角标志 青色
@property (weak, nonatomic) IBOutlet UIView *connectingConnectView;
// 电池电量标志
@property (weak, nonatomic) IBOutlet GBBatteryIndicator *batteryIndicator;
// 链接按钮 右上角
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
// 静态标签已连接
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
// 静态标签连接手环
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
// 静态标签绑定手环
@property (weak, nonatomic) IBOutlet UILabel *bindLabel;
// 静态标签链接中
@property (weak, nonatomic) IBOutlet UILabel *connectingLabel;

// 左上角足球模式切换标签
@property (weak, nonatomic) IBOutlet UIImageView    *footballSwitchImageView;
@property (weak, nonatomic) IBOutlet UILabel        *footballSwitchLabel;
@property (weak, nonatomic) IBOutlet UIView         *footballSwitchView;
// 足球模式状态
@property (assign, nonatomic) FOOTBALL_MODE_STATE   footballState;

@end
