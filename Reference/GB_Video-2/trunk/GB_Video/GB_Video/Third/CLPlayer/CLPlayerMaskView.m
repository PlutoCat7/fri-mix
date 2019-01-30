//
//  CLPlayerMaskView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2017/2/24.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLPlayerMaskView.h"
#import "CLSlider.h"
#import "Masonry.h"

//间隙
#define Padding        10

@interface CLPlayerMaskView () <
CLPlayTopToolBarDelegate,
CLPlayBottomToolBarDelegate>

@end

@implementation CLPlayerMaskView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
        
        [self addTarget:self
                      action:@selector(disappearAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - 布局
- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints {
    
    //顶部工具条
    [self.playTopToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    
    //底部工具条
    [self.playBottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(ToolBarHeight);
    }];
    
    //转子
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    //失败按钮
    [self.failButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - Public

- (void)setIsFullScreen:(BOOL)isFull {
    
    self.fullButton.selected = isFull;
}

#pragma mark - Action

- (void)disappearAction:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cl_disappear)]) {
        [_delegate cl_disappear];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

//播放按钮
- (void)playButtonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_playButtonAction:)]) {
        [_delegate cl_playButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

//失败按钮
- (void)failButtonAction:(UIButton *)button {
    
    self.failButton.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(cl_failButtonAction:)]) {
        [_delegate cl_failButtonAction:button];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

#pragma mark - Private

- (void)initSubviews {
    
    [self addSubview:self.playTopToolBar];
    [self addSubview:self.playBottomToolBar];
    [self addSubview:self.activity];
    [self addSubview:self.playButton];
    [self addSubview:self.failButton];
}

#pragma mark - Setter and Getter
//转子
- (CLLoadingView *)activity {
    
    if (_activity == nil){
        _activity             = [[CLLoadingView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _activity.strokeColor = [UIColor whiteColor];
        [_activity starAnimation];
    }
    return _activity;
}

//顶部工具栏
- (CLPlayTopToolBar *)playTopToolBar {
    
    if (!_playTopToolBar) {
        _playTopToolBar = [[CLPlayTopToolBar alloc]init];
        _playTopToolBar.delegate = self;
    }
    return _playTopToolBar;
}
//底部工具栏
- (CLPlayBottomToolBar *)playBottomToolBar {
    
    if (!_playBottomToolBar) {
        _playBottomToolBar = [[CLPlayBottomToolBar alloc]init];
        _playBottomToolBar.delegate = self;
    }
    return _playBottomToolBar;
}

//播放按钮
- (UIButton *)playButton {
    
    if (_playButton == nil){
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage imageNamed:@"cl_play"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"cl_pause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

//加载失败按钮
- (UIButton *) failButton
{
    if (_failButton == nil) {
        _failButton        = [[UIButton alloc] init];
        _failButton.hidden = YES;
        [_failButton setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        [_failButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _failButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _failButton.backgroundColor = [UIColor colorWithRed:0.00000f green:0.00000f blue:0.00000f alpha:0.50000f];
        [_failButton addTarget:self action:@selector(failButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _failButton;
}

//全屏按钮
- (UIButton *)fullButton {
    
    return self.playBottomToolBar.fullButton;
}
//当前播放时间
- (UILabel *)currentTimeLabel {
    
    return self.playBottomToolBar.currentTimeLabel;
}
//总时间
- (UILabel *)totalTimeLabel {
    
    return self.playBottomToolBar.totalTimeLabel;
}
//缓冲条
- (UIProgressView *)progress {
    
    return self.playBottomToolBar.progress;
}
//滑动条
- (CLSlider *)slider {
    
    return self.playBottomToolBar.slider;
}

#pragma mark - Delegate
#pragma mark PlayTopToolBarDelegate

- (void)didClickBackInPlayTopToolBar:(CLPlayTopToolBar *)topToolBar {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cl_backButtonAction)]) {
        [_delegate cl_backButtonAction];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

#pragma mark PlayBottomToolBarDelegate

- (void)didClickFullInPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cl_fullButtonAction)]) {
        [_delegate cl_fullButtonAction];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

- (void)sliderTouchBegan:(CLSlider *)slider inPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchBegan:)]) {
        [_delegate cl_progressSliderTouchBegan:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

- (void)sliderValueChanged:(CLSlider *)slider inPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderValueChanged:)]) {
        [_delegate cl_progressSliderValueChanged:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

- (void)sliderTouchEnded:(CLSlider *)slider inPlayBottomToolBar:(CLPlayBottomToolBar *)bottomToolBar {
    
    if (_delegate && [_delegate respondsToSelector:@selector(cl_progressSliderTouchEnded:)]) {
        [_delegate cl_progressSliderTouchEnded:slider];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

@end
