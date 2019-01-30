//
//  CLPlayerMaskView.h
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/2/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSlider.h"
#import "CLLoadingView.h"
#import "CLPlayBottomToolBar.h"
#import "CLPlayTopToolBar.h"

@protocol CLPlayerMaskViewDelegate <NSObject>
/**点击空白部分代理， 用于显示或隐藏toolview*/
- (void)cl_disappear;
/**返回按钮代理*/
- (void)cl_backButtonAction;
/**播放按钮代理*/
- (void)cl_playButtonAction:(UIButton *)button;
/**全屏按钮代理*/
- (void)cl_fullButtonAction;
/**失败按钮代理*/
- (void)cl_failButtonAction:(UIButton *)button;
/**开始滑动*/
- (void)cl_progressSliderTouchBegan:(CLSlider *)slider;
/**滑动中*/
- (void)cl_progressSliderValueChanged:(CLSlider *)slider;
/**滑动结束*/
- (void)cl_progressSliderTouchEnded:(CLSlider *)slider;

@end

@interface CLPlayerMaskView : UIButton

/**代理人*/
@property (nonatomic,weak) id<CLPlayerMaskViewDelegate> delegate;

/**顶部工具条*/
@property (nonatomic,strong) CLPlayTopToolBar *playTopToolBar;
/**底部工具条*/
@property(nonatomic,strong)CLPlayBottomToolBar *playBottomToolBar;
/**转子*/
@property (nonatomic,strong) CLLoadingView *activity;

/**底部工具条播放按钮*/
@property (nonatomic,strong) UIButton *playButton;
/**底部工具条全屏按钮*/
@property (nonatomic,strong) UIButton *fullButton;
/**底部工具条当前播放时间*/
@property (nonatomic,strong) UILabel *currentTimeLabel;
/**底部工具条视频总时间*/
@property (nonatomic,strong) UILabel *totalTimeLabel;
/**缓冲进度条*/
@property (nonatomic,strong) UIProgressView *progress;
/**播放进度条*/
@property (nonatomic,strong) CLSlider *slider;
/**加载失败按钮*/
@property (nonatomic,strong) UIButton *failButton;

- (void)setIsFullScreen:(BOOL)isFull;

@end
