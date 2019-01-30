//
//  ScheduleOneButtonView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleOneButtonView.h"
#import "ScheduleOneButtonViewModel.h"

@interface ScheduleOneButtonView ()

@property (nonatomic, strong  ) ScheduleOneButtonViewModel *viewModel;
@property (nonatomic, strong  ) UIButton *button;

@end

@implementation ScheduleOneButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUIInterface];
    }
    return self;
}

- (void)setupUIInterface
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.button];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_button(120)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_button)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_button(40)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_button)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)resetViewWithViewModel:(ScheduleOneButtonViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.button setTitle:viewModel.oneButtonTitle forState:UIControlStateNormal];
}

- (void)respondsToButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleOneButtonView:clickButtonWithViewModel:)])
    {
        [self.delegate scheduleOneButtonView:self clickButtonWithViewModel:self.viewModel];
    }
}

- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.layer.cornerRadius = 20;
        _button.layer.masksToBounds = YES;
        _button.backgroundColor = RGB(253, 240, 134);
        [_button setTitleColor:RGB(68, 68, 75) forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
