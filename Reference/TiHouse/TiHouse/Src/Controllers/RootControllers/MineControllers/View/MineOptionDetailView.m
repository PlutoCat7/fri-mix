//
//  MineOptionDetailView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MineOptionDetailView.h"
#import "MineOptionDetailViewModel.h"

@interface MineOptionDetailView ()

@property (nonatomic, strong  ) MineOptionDetailViewModel *viewModel;
@property (nonatomic, strong  ) UIImageView *icon;
@property (nonatomic, strong  ) UILabel     *titleLabel;
@property (nonatomic, strong  ) UILabel     *badgeValueLabel;

@end

@implementation MineOptionDetailView

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
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToMineOptionDetailView:)]];
    
    UIView *tmpView = [KitFactory view];
    tmpView.translatesAutoresizingMaskIntoConstraints = NO;
    [tmpView addSubview:self.icon];
    [tmpView addSubview:self.titleLabel];
    [tmpView addSubview:self.badgeValueLabel];
    
    [self addSubview:tmpView];
    
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_icon]-2-[_titleLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_badgeValueLabel,_icon,_titleLabel)]];
    
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_badgeValueLabel(18)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_badgeValueLabel)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_badgeValueLabel(18)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_badgeValueLabel)]];
    
    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tmpView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeValueLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.icon attribute:NSLayoutAttributeRight multiplier:1.0 constant:4.0]];
    [tmpView addConstraint:[NSLayoutConstraint constraintWithItem:self.badgeValueLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.icon attribute:NSLayoutAttributeTop multiplier:1.0 constant:14.0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)resetViewWithViewModel:(MineOptionDetailViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.icon.image = viewModel.icon;
    self.titleLabel.text = viewModel.title;
    self.badgeValueLabel.text = viewModel.badgeValue;
    self.badgeValueLabel.hidden = [viewModel.badgeValue integerValue] == 0 ;
}

- (void)respondsToMineOptionDetailView:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(mineOptionDetailView:clickViewWithViewModel:)])
    {
        [self.delegate mineOptionDetailView:self clickViewWithViewModel:self.viewModel];
    }
}

- (UIImageView *)icon
{
    if (!_icon)
    {
        _icon = [[UIImageView alloc] init];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _icon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [KitFactory label];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = RGB(102, 102, 102);
        _titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UILabel *)badgeValueLabel
{
    if (!_badgeValueLabel)
    {
        _badgeValueLabel = [KitFactory label];
        _badgeValueLabel.textColor = [UIColor whiteColor];
        _badgeValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _badgeValueLabel.backgroundColor = RGB(255, 0, 0);
        _badgeValueLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:10]];
        _badgeValueLabel.layer.cornerRadius = 18 / 2;
        _badgeValueLabel.layer.masksToBounds = YES;
        _badgeValueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeValueLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
