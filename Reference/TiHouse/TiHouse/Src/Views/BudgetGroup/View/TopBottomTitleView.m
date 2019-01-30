//
//  TopBottomTitleView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/5/15.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TopBottomTitleView.h"
#import "TopBottomTitleViewModel.h"

@interface TopBottomTitleView ()

@property (nonatomic, strong  ) TopBottomTitleViewModel *viewModel;
@property (nonatomic, strong  ) UILabel *topTitle;
@property (nonatomic, strong  ) UILabel *bottomTitle;

@end

@implementation TopBottomTitleView

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
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTopBottomTitleView:)]];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    UIView *tmpView = [KitFactory view];
    tmpView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [tmpView addSubview:self.topTitle];
    [tmpView addSubview:self.bottomTitle];
    
    [self addSubview:tmpView];
    
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topTitle)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomTitle)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topTitle]-2-[_bottomTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topTitle,_bottomTitle)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)respondsToTopBottomTitleView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBottomTitleView:clickViewWithViewModel:)])
    {
        [self.delegate topBottomTitleView:self clickViewWithViewModel:self.viewModel];
    }
}

- (void)resetViewWithViewModel:(TopBottomTitleViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.topTitle.text = viewModel.topTitle;
    self.bottomTitle.text = viewModel.bottomTitle;
    
    self.backgroundColor = viewModel.cellBackgroundColor;
}

- (UILabel *)topTitle
{
    if (!_topTitle)
    {
        _topTitle = [KitFactory label];
        _topTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _topTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
        _topTitle.textColor = [UIColor whiteColor];
        _topTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _topTitle;
}

- (UILabel *)bottomTitle
{
    if (!_bottomTitle)
    {
        _bottomTitle = [KitFactory label]; 
        _bottomTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
        _bottomTitle.textColor = [UIColor whiteColor];
        _bottomTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomTitle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
