//
//  SwitchOptionsView.m
//  YouSuHuoPinDot
//
//  Created by Teen Ma on 2017/11/2.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "SwitchOptionsView.h"
#import "SwitchOptionsViewModel.h"

#define kBottomViewHeight 4
#define kBottomViewWidth 30

@interface SwitchOptionsView ()

@property (nonatomic, strong) NSMutableArray *viewButtonsArray;
@property (nonatomic, strong) NSMutableArray *viewModel;
@property (nonatomic, strong) UIView         *animationView;

@end

@implementation SwitchOptionsView

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
    self.backgroundColor = [UIColor clearColor];
    self.viewButtonsArray = [NSMutableArray array];
}

- (UIView *)animationView
{
    if (!_animationView)
    {
        _animationView = [KitFactory view];
        _animationView.backgroundColor = RGB(254, 192, 12);
        _animationView.layer.cornerRadius = 2;
        _animationView.layer.masksToBounds = YES;
    }
    return _animationView;
}

- (void)resetViewWithArray:(NSMutableArray *)viewModels 
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self.viewButtonsArray removeAllObjects]; 
    
    if (viewModels.count > 0)
    {
        float kButtonWidth = self.frame.size.width / viewModels.count;
        self.animationView.frame = CGRectMake(0, self.frame.size.height - kBottomViewHeight, kBottomViewWidth, kBottomViewHeight);
        [self addSubview:self.animationView];
        
        for (int i = 0; i < viewModels.count; i++)
        {
            SwitchOptionsViewModel *viewModel = [viewModels objectAtIndex:i];
            UIButton *button = [KitFactory button];
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:viewModel.title forState:UIControlStateNormal];
            [button setTitleColor:viewModel.titleColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:15.0f]];
            [button addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(kButtonWidth * i, 0, kButtonWidth, self.frame.size.height);
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [self addSubview:button];
            
            [self.viewButtonsArray addObject:button];
        }
        self.viewModel = viewModels;
    }
}

- (void)refreshOptionViewWithIndex:(NSInteger)index
{
    __block UIButton *tmpButton;
    for (int i = 0 ; i < self.viewButtonsArray.count ; i++)
    {
        SwitchOptionsViewModel *viewModel = [self.viewModel objectAtIndex:i];
        UIButton *button = [self.viewButtonsArray objectAtIndex:i];
        if (index == i)
        {
            viewModel.isChoosed = YES;
            tmpButton = button;
        }
        else
        {
            viewModel.isChoosed = NO;
        }
        [button setTitleColor:viewModel.titleColor forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect centeredRect = CGRectMake(tmpButton.frame.origin.x + tmpButton.size.width/2.0 - self.animationView.frame.size.width/2.0,
                                         self.animationView.frame.origin.y,
                                         self.animationView.frame.size.width,
                                         self.animationView.frame.size.height);
        self.animationView.frame = centeredRect;
    }];
}

- (void)respondsToButton:(UIButton *)button
{
    NSInteger index = [self.viewButtonsArray indexOfObject:button];
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchOptionsView:clickOptionWithViewModel:)])
    {
        [self.delegate switchOptionsView:self clickOptionWithViewModel:[self.viewModel objectAtIndex:index]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
