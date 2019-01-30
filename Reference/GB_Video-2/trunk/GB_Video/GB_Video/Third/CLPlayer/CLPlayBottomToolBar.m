//
//  PlayBottomToolBar.m
//  PlayView
//
//  Created by Rainy on 2017/12/29.
//  Copyright © 2017年 Rainy. All rights reserved.
//

//间隙
#define Padding        14

#import "CLPlayBottomToolBar.h"
#import "Masonry.h"

@interface CLPlayBottomToolBar ()


@end

@implementation CLPlayBottomToolBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.userInteractionEnabled = YES;
        [self setUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        [self setUI];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
}

#pragma mark - Action

//开始滑动
- (void)progressSliderTouchBegan:(CLSlider *)slider {
    
    if (_delegate && [_delegate respondsToSelector:@selector(sliderTouchBegan:inPlayBottomToolBar:)]) {
        [_delegate sliderTouchBegan:slider inPlayBottomToolBar:self];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动中
- (void)progressSliderValueChanged:(CLSlider *)slider {
    
    if (_delegate && [_delegate respondsToSelector:@selector(sliderValueChanged:inPlayBottomToolBar:)]) {
        [_delegate sliderValueChanged:slider inPlayBottomToolBar:self];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}
//滑动结束
- (void)progressSliderTouchEnded:(CLSlider *)slider {
    
    if (_delegate && [_delegate respondsToSelector:@selector(sliderTouchEnded:inPlayBottomToolBar:)]) {
        [_delegate sliderTouchEnded:slider inPlayBottomToolBar:self];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

//全屏按钮
- (void)fullButtonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(didClickFullInPlayBottomToolBar:)]) {
        [_delegate didClickFullInPlayBottomToolBar:self];
    }else{
        NSLog(@"没有实现代理或者没有设置代理人");
    }
}

#pragma mark - Private

- (void)setUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.progress];
    [self addSubview:self.slider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.fullButton];
    
    //当前播放时间
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    //全屏按钮
    [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(57);
    }];
    //总时间
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.right.equalTo(self.fullButton.mas_left);
        make.centerY.equalTo(self);
    }];
    //缓冲条
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(Padding);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-Padding);
        make.height.mas_equalTo(2);
        make.centerY.equalTo(self);
    }];
    //滑杆
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(self.progress);
    }];
}

#pragma mark - Setter and Getter

//当前播放时间
- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil){
        _currentTimeLabel                           = [[UILabel alloc] init];
        _currentTimeLabel.textColor                 = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        _currentTimeLabel.text                      = @"00:00";
        _currentTimeLabel.textAlignment             = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}
//总时间
- (UILabel *)totalTimeLabel {
    
    if (_totalTimeLabel == nil){
        _totalTimeLabel                           = [[UILabel alloc] init];
        _totalTimeLabel.textColor                 = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        _totalTimeLabel.text                      = @"00:00";
        _totalTimeLabel.textAlignment             = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
//缓冲条
- (UIProgressView *)progress {
    if (_progress == nil){
        _progress = [[UIProgressView alloc] init];
        _progress.trackTintColor = [UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:151 / 255.0 alpha:1];
        _progress.progressTintColor = [UIColor colorWithRed:228 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    }
    return _progress;
}
//滑动条
- (CLSlider *)slider {
    
    if (_slider == nil) {
        _slider = [[CLSlider alloc] init];
        //右边颜色
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.minimumTrackTintColor = [UIColor colorWithRed:228 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
        [_slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_slider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    }
    return _slider;
}
//全屏按钮
- (UIButton *)fullButton {
    
    if (_fullButton == nil) {
        _fullButton = [[UIButton alloc] init];
        [_fullButton setImage:[UIImage imageNamed:@"cl_full_screen"] forState:UIControlStateNormal];
        [_fullButton setImage:[UIImage imageNamed:@"cl_small_screen"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(fullButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}

@end
