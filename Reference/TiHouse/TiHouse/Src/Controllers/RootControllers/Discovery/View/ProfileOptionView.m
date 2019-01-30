//
//  ProfileOptionView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/19.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ProfileOptionView.h"
#import "ProfileOptionViewModel.h"

@interface ProfileOptionView ()

@property (nonatomic, strong  ) ProfileOptionViewModel *viewModel;

@property (nonatomic, strong  ) UIView *leftView;
@property (nonatomic, strong  ) UIImageView *leftImageView;
@property (nonatomic, strong  ) UILabel *leftTitle;

@property (nonatomic, strong  ) UIImageView *centerLine;

@property (nonatomic, strong  ) UIImageView *rightImageView;
@property (nonatomic, strong  ) UIView *rightView;
@property (nonatomic, strong  ) UILabel *rightTitle;

@property (nonatomic, strong  ) UIImageView *bottomLine;

@end

@implementation ProfileOptionView

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
    
    [self addSubview:self.leftView];
    [self addSubview:self.centerLine];
    [self addSubview:self.rightView];
    [self addSubview:self.bottomLine];
    
    UIView *tmpLeftView = [KitFactory view];
    tmpLeftView.translatesAutoresizingMaskIntoConstraints = NO;
    [tmpLeftView addSubview:self.leftImageView];
    [tmpLeftView addSubview:self.leftTitle];
    [self.leftView addSubview:tmpLeftView];
    
    UIView *tmpRightView = [KitFactory view];
    tmpRightView.translatesAutoresizingMaskIntoConstraints = NO;
    [tmpRightView addSubview:self.rightImageView];
    [tmpRightView addSubview:self.rightTitle];
    [self.rightView addSubview:tmpRightView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftView][_centerLine(0.5)][_rightView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftView,_centerLine,_rightView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftView][_bottomLine(0.5)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftView,_bottomLine)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightView][_bottomLine(0.5)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightView,_bottomLine)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_centerLine]-15-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_centerLine)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomLine]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomLine)]];
    
    [tmpLeftView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftTitle)]];
    [tmpLeftView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftImageView]-8-[_leftTitle]|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:NSDictionaryOfVariableBindings(_leftImageView,_leftTitle)]];
    [self.leftView addConstraint:[NSLayoutConstraint constraintWithItem:tmpLeftView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.leftView addConstraint:[NSLayoutConstraint constraintWithItem:tmpLeftView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
 
    [tmpRightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightTitle)]];
    [tmpRightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightImageView]-8-[_rightTitle]|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:NSDictionaryOfVariableBindings(_rightImageView,_rightTitle)]];
    [self.rightView addConstraint:[NSLayoutConstraint constraintWithItem:tmpRightView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.rightView addConstraint:[NSLayoutConstraint constraintWithItem:tmpRightView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)resetViewWithViewModel:(ProfileOptionViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    self.leftTitle.text = viewModel.optionLeftTitle;
    self.leftImageView.image = viewModel.optionLeftImage;
    
    self.rightTitle.text = viewModel.optionRightTitle;
    self.rightImageView.image = viewModel.optionRightImage;
}

- (void)respondsToLeftView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileOptionView:clickLeftViewWithViewModel:)])
    {
        [self.delegate profileOptionView:self clickLeftViewWithViewModel:self.viewModel];
    }
}

- (void)respondsToRightView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileOptionView:clickRightViewWithViewModel:)])
    {
        [self.delegate profileOptionView:self clickRightViewWithViewModel:self.viewModel];
    }
}

- (UIView *)leftView
{
    if (!_leftView)
    {
        _leftView = [KitFactory view]; 
        _leftView.translatesAutoresizingMaskIntoConstraints = NO;
        _leftView.userInteractionEnabled = YES;
        [_leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLeftView:)]];
    }
    return _leftView;
}

- (UIView *)rightView
{
    if (!_rightView)
    {
        _rightView = [KitFactory view];
        _rightView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightView.userInteractionEnabled = YES;
        [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToRightView:)]];
    }
    return _rightView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView)
    {
        _leftImageView = [KitFactory imageView];
        _leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView)
    {
        _rightImageView = [KitFactory imageView];
        _rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightImageView;
}

- (UIImageView *)centerLine
{
    if (!_centerLine)
    {
        _centerLine = [KitFactory imageView];
        _centerLine.translatesAutoresizingMaskIntoConstraints = NO;
        _centerLine.backgroundColor = RGB(235, 235, 235);
    }
    return _centerLine;
}

- (UIImageView *)bottomLine
{
    if (!_bottomLine)
    {
        _bottomLine = [KitFactory imageView];
        _bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomLine.backgroundColor = RGB(219, 219, 219);
    }
    return _bottomLine;
}


- (UILabel *)leftTitle
{
    if (!_leftTitle)
    {
        _leftTitle = [KitFactory label];
        _leftTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _leftTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:11]];
        _leftTitle.textColor = [UIColor blackColor];
    }
    return _leftTitle;
}

- (UILabel *)rightTitle
{
    if (!_rightTitle)
    {
        _rightTitle = [KitFactory label];
        _rightTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _rightTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:11]];
        _rightTitle.textColor = [UIColor blackColor];
    }
    return _rightTitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
