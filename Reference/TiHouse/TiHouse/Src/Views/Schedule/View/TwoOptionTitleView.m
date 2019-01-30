//
//  TwoOptionTitleView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TwoOptionTitleView.h"
#import "TwoOptionTitleViewModel.h"

@interface TwoOptionTitleView ()

@property (nonatomic, strong  ) UILabel *leftTitleLabel;
@property (nonatomic, strong  ) UILabel *centerTitleLabel;
@property (nonatomic, strong  ) UILabel *rightTitleLabel;
@property (nonatomic, strong  ) UIView  *rootView;
@property (nonatomic, strong  ) UIImageView *bottomLine;

@end

@implementation TwoOptionTitleView

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
    
    [self.rootView addSubview:self.leftTitleLabel];
    [self.rootView addSubview:self.rightTitleLabel];
    [self.rootView addSubview:self.centerTitleLabel];
    
    [self addSubview:self.rootView];
    [self addSubview:self.bottomLine];
    
    [self.rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rootView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftTitleLabel]-4-[_centerTitleLabel]-4-[_rightTitleLabel]|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_leftTitleLabel,_centerTitleLabel,_rightTitleLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rootView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rootView)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rootView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rootView][_bottomLine(0.5)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rootView,_bottomLine)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomLine]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomLine)]];
}

- (void)resetViewWithViewModel:(TwoOptionTitleViewModel *)viewModel
{
    self.leftTitleLabel.text = viewModel.leftTitle;
    self.rightTitleLabel.text = viewModel.rightTitle;
    self.centerTitleLabel.text = viewModel.centerTitle;
}

- (UILabel *)leftTitleLabel
{
    if (!_leftTitleLabel)
    {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.backgroundColor = [UIColor clearColor];
        _leftTitleLabel.textColor = RGB(68, 68, 75);
        _leftTitleLabel.font = [UIFont systemFontOfSize:12];
        _leftTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftTitleLabel;
}

- (UILabel *)rightTitleLabel
{
    if (!_rightTitleLabel)
    {
        _rightTitleLabel = [[UILabel alloc] init];
        _rightTitleLabel.backgroundColor = [UIColor clearColor];
        _rightTitleLabel.textColor = RGB(191, 191, 191);
        _rightTitleLabel.font = [UIFont systemFontOfSize:12];
        _rightTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightTitleLabel;
}

- (UILabel *)centerTitleLabel
{
    if (!_centerTitleLabel)
    {
        _centerTitleLabel = [[UILabel alloc] init];
        _centerTitleLabel.backgroundColor = [UIColor clearColor];
        _centerTitleLabel.textColor = RGB(191, 191, 191);
        _centerTitleLabel.font = [UIFont systemFontOfSize:12];
        _centerTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _centerTitleLabel;
}

- (UIView *)rootView
{
    if (!_rootView)
    {
        _rootView = [[UIView alloc] init];
        _rootView.translatesAutoresizingMaskIntoConstraints = NO;
        _rootView.backgroundColor = [UIColor clearColor];
    }
    return _rootView;
}

- (UIImageView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [[UIImageView alloc] init];
        _bottomLine.backgroundColor = RGB(229, 229, 229);
        _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
