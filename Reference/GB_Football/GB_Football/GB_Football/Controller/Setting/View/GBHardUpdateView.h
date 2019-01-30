//
//  GBHardUpdateView.h
//  GB_Football
//
//  Created by Pizza on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,HARD_STATE)
{
    STATE_IDLE = 0,         // 空闲
    STATE_DOWNLOADING,      // 下载开始－下载中
    STATE_DOWNLOAD_FINISH,  // 下载完成
    STATE_PROGRAMMING,      // 烧录开始－烧录中
    STATE_PROGRAM_FINISH,   // 烧录完成
};

typedef NS_ENUM(NSUInteger,HARD_UPDATE_TYPE)
{
    UPDATE_TYPE_HAVE_BUTTON = 0,// 有按钮版本
    UPDATE_TYPE_NO_BUTTON   = 1,// 无按钮版本
};


@interface GBHardUpdateView : UIView

// 手环固件版本 0 有按钮 1 无按钮
@property (nonatomic,assign) HARD_UPDATE_TYPE deviceUpdateType;
// 固件版本号
@property (nonatomic, copy) NSString *firmversion;

// 按钮点击回调  0取消   1重连
@property (nonatomic, copy) void(^didClickButton)(NSInteger index);

//取值范围0-100
@property (nonatomic,assign) CGFloat percent;

// 设置状态
-(void)setupState:(HARD_STATE)state;

// 显示
-(void)show;

// 移除
-(void)remove;

// 国际化
-(void)localizeUI;

@end
