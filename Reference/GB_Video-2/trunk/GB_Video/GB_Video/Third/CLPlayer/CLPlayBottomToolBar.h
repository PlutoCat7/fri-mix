//
//  PlayBottomToolBar.h
//  PlayView
//
//  Created by Rainy on 2017/12/29.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSlider.h"

@class CLPlayBottomToolBar;

@protocol CLPlayBottomToolBarDelegate <NSObject>

/**全屏按钮代理*/
- (void)didClickFullInPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar;
/**开始滑动*/
- (void)sliderTouchBegan:(CLSlider *)slider inPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar;
/**滑动中*/
- (void)sliderValueChanged:(CLSlider *)slider inPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar;;
/**滑动结束*/
- (void)sliderTouchEnded:(CLSlider *)slider inPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar;

@end

@interface CLPlayBottomToolBar : UIView

@property (nonatomic, weak) id<CLPlayBottomToolBarDelegate> delegate;

/**底部工具条当前播放时间*/
@property (nonatomic,strong) UILabel *currentTimeLabel;
/**底部工具条视频总时间*/
@property (nonatomic,strong) UILabel *totalTimeLabel;
/**缓冲进度条*/
@property (nonatomic,strong) UIProgressView *progress;
/**播放进度条*/
@property (nonatomic,strong) CLSlider *slider;
/**底部工具条全屏按钮*/
@property (nonatomic,strong) UIButton *fullButton;

@end
