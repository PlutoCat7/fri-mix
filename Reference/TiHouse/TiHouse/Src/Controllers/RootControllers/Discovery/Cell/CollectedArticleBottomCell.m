//
//  CollectedArticleBottomCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/24.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CollectedArticleBottomCell.h"
#import "CollectedArticleBottomViewModel.h"

#define kIconWidth_Height 24

@interface CollectedArticleBottomCell ()

@property (nonatomic, strong) CollectedArticleBottomViewModel *viewModel;
@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIButton    *rightButton;
@property (nonatomic, strong) UIView      *tmpBackgroundView;


@end

@implementation CollectedArticleBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUIInterface];
    }
    return self;
}

- (void)setupUIInterface
{
    [self.contentView addSubview:self.tmpBackgroundView];
    [self.contentView addSubview:self.leftIcon];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.rightButton];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_tmpBackgroundView]-12-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tmpBackgroundView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tmpBackgroundView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tmpBackgroundView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[_leftIcon(kIconWidth_Height)]-5-[_nameLabel]-5-[_timeLabel]-(>=28)-[_rightButton]-22-|" options:NSLayoutFormatAlignAllCenterY metrics:@{@"kIconWidth_Height":@(kIconWidth_Height)} views:NSDictionaryOfVariableBindings(_leftIcon,_nameLabel,_timeLabel,_rightButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftIcon(kIconWidth_Height)]" options:0 metrics:@{@"kIconWidth_Height":@(kIconWidth_Height)} views:NSDictionaryOfVariableBindings(_leftIcon)]];
}

- (void)resetCellWithViewModel:(CollectedArticleBottomViewModel *)model
{
    [super resetCellWithViewModel:model];
    
    self.viewModel = model;
 
    [self.leftIcon sd_setImageWithURL:[NSURL URLWithString:model.leftImageUrl] placeholderImage:model.leftPlaceHolder];
    
    self.nameLabel.text = model.name;
    self.timeLabel.text = model.time;
    [self.rightButton setImage:model.rightButton forState:UIControlStateNormal];
}

- (void)respondsToRightButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectedArticleBottomCell:clickRightButtonWithViewModel:)])
    {
        [self.delegate collectedArticleBottomCell:self clickRightButtonWithViewModel:self.viewModel];
    }
}

- (UIImageView *)leftIcon
{
    if (!_leftIcon)
    {
        _leftIcon = [KitFactory imageView];
        _leftIcon.layer.cornerRadius = kIconWidth_Height / 2;
        _leftIcon.layer.masksToBounds = YES;
        _leftIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftIcon;
}

- (UIButton *)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [KitFactory button];
        _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_rightButton addTarget:self action:@selector(respondsToRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [KitFactory label];
        _nameLabel.textColor = RGB(0, 0, 0);
        _nameLabel.font = [UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [KitFactory label];
        _timeLabel.textColor = RGB(153, 153, 153);
        _timeLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _timeLabel;
}

- (UIView *)tmpBackgroundView
{
    if (!_tmpBackgroundView)
    {
        _tmpBackgroundView = [KitFactory view];
        _tmpBackgroundView.backgroundColor = [UIColor whiteColor];
        _tmpBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tmpBackgroundView;
}

@end
