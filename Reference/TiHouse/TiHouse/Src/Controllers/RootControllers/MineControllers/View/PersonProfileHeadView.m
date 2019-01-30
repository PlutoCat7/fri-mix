//
//  PersonProfileHeadView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PersonProfileHeadView.h"
#import "PersonProfileHeadViewModel.h"

#define kIconWidthHeight 62

@interface PersonProfileHeadView ()

@property (nonatomic, strong  ) PersonProfileHeadViewModel *viewModel;
@property (nonatomic, strong  ) UILabel *nameLabel;

@end

@implementation PersonProfileHeadView

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
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPersonProfileHeadView:)]];
    
    UIView *optionView = [KitFactory view]; 
    optionView.translatesAutoresizingMaskIntoConstraints = NO; 
    [optionView addSubview:self.topIcon];
    [optionView addSubview:self.nameLabel];
    
    [self addSubview:optionView];
    
    [optionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_topIcon(kIconWidthHeight)]" options:0 metrics:@{@"kIconWidthHeight":@(kIconWidthHeight)} views:NSDictionaryOfVariableBindings(_topIcon)]];
    [optionView addConstraint:[NSLayoutConstraint constraintWithItem:self.topIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:optionView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [optionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nameLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_nameLabel)]];
    [optionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topIcon(kIconWidthHeight)]-8-[_nameLabel]|" options:0 metrics:@{@"kIconWidthHeight":@(kIconWidthHeight)} views:NSDictionaryOfVariableBindings(_topIcon,_nameLabel)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:optionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:optionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:kSTATUSBARH]];
}

- (void)resetViewWithViewModel:(PersonProfileHeadViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    self.backgroundColor = viewModel.headViewBackgroundColor;
    self.nameLabel.text = viewModel.name;
    [self.topIcon sd_setImageWithURL:[NSURL URLWithString:viewModel.imageUrl] placeholderImage:viewModel.placeHolderImage];
}

- (void)respondsToTopIcon:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personProfileHeadView:clickAvatarWithViewModel:)])
    {
        [self.delegate personProfileHeadView:self clickAvatarWithViewModel:self.viewModel];
    }
}

- (void)respondsToPersonProfileHeadView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personProfileHeadView:clickBackgroundWithViewModel:)])
    {
        [self.delegate personProfileHeadView:self clickBackgroundWithViewModel:self.viewModel];
    }
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [KitFactory label];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.textColor = RGB(3, 3, 3);
        _nameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:18]];
    }
    return _nameLabel;
}

- (UIImageView *)topIcon
{
    if (!_topIcon)
    {
        _topIcon = [KitFactory imageView];
        _topIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _topIcon.layer.cornerRadius = kIconWidthHeight / 2;
        _topIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        _topIcon.layer.borderWidth = 2;
        _topIcon.layer.masksToBounds = YES;
        _topIcon.userInteractionEnabled = YES;
        [_topIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTopIcon:)]];
    }
    return _topIcon;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
