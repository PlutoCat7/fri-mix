//
//  AuthorCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AuthorCell.h"
#import "AuthorViewModel.h"

#define kIconWidth_Height 30

@interface AuthorCell ()

@property (nonatomic, strong) AuthorViewModel *viewModel;
@property (nonatomic, strong) WebImageView *leftIcon;
@property (nonatomic, strong) UILabel     *topTitle;
@property (nonatomic, strong) UILabel     *bottomTitle;

//关注样式
@property (nonatomic, strong) UIButton    *rightButton;

//广告样式view
@property (nonatomic, strong) UILabel     *rightOption;
@property (nonatomic, strong) UIImageView *rightArrowImage;
@property (nonatomic, strong) UIView      *rightView;

@property (nonatomic, strong) UIButton    *rightEditButton;//编辑样式按钮

@end

@implementation AuthorCell

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
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *tmpView = [KitFactory view];
    tmpView.translatesAutoresizingMaskIntoConstraints = NO;
    [tmpView addSubview:self.topTitle];
    [tmpView addSubview:self.bottomTitle];

    [self.rightView addSubview:self.rightArrowImage];
    [self.rightView addSubview:self.rightOption];
    
    [self.contentView addSubview:self.leftIcon];
    [self.contentView addSubview:tmpView];
    [self.contentView addSubview:self.rightButton];
    [self.contentView addSubview:self.rightView];
    [self.contentView addSubview:self.rightEditButton];
    
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topTitle)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomTitle)]];
    [tmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topTitle]-3-[_bottomTitle]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topTitle,_bottomTitle)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_leftIcon(kIconWidth_Height)]-8-[tmpView]-(>=10)-[_rightButton(70)]-10-|" options:NSLayoutFormatAlignAllCenterY metrics:@{@"kIconWidth_Height":@(kIconWidth_Height)} views:NSDictionaryOfVariableBindings(_leftIcon,tmpView,_rightButton)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftIcon(kIconWidth_Height)]" options:0 metrics:@{@"kIconWidth_Height":@(kIconWidth_Height)} views:NSDictionaryOfVariableBindings(_leftIcon)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightButton(34)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightButton)]];
    
    [self.rightView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightOption attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_rightOption]-2-[_rightArrowImage]-4-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_rightOption,_rightArrowImage)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightView(20)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_rightView]-13-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightView)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_rightEditButton]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightEditButton)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightEditButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)resetCellWithViewModel:(AuthorViewModel *)model
{
    [super resetCellWithViewModel:model];
    
    self.viewModel = model;
    
    self.rightView.hidden = YES;
    self.rightButton.hidden = YES;
    self.rightEditButton.hidden = YES;
    
    [self.leftIcon sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:model.placeHolder];
    self.topTitle.text = model.topTitle;
    self.bottomTitle.text = model.bottomTitle;
    
    [self.rightButton removeTarget:self action:@selector(respondsToRightButton:) forControlEvents:UIControlEventTouchUpInside];
    if (model.buttonCanTouch)
    {
        [self.rightButton addTarget:self action:@selector(respondsToRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (model.hasRightButton)
    {
        self.rightOption.text = model.advButtonTitle;
        self.rightArrowImage.image = model.advButtonArrowImage;
        
        if (model.type == AUTHORVIEWMODELTYPE_ADVERTISEMENTSTYPE)
        {
            self.rightView.hidden = NO;
        }
        if (model.type == AUTHORVIEWMODELTYPE_CONCERNTYPE)
        {
            self.rightButton.backgroundColor = model.buttonBackgroundColor;
            [self.rightButton setTitle:model.buttonTitle forState:UIControlStateNormal];
            self.rightButton.hidden = NO;
        }
        else if (model.type == AUTHORVIEWMODELTYPE_EDITTYPE)
        {
            [self.rightEditButton setImage:model.rightButtonImage forState:UIControlStateNormal];
            self.rightEditButton.hidden = NO;
        }
    }
}

- (void)respondsToRightButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorCell:clickRightButtonWithViewModel:)])
    {
        [self.delegate authorCell:self clickRightButtonWithViewModel:self.viewModel];
    }
}

- (void)respondsToLeftIcon:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorCell:clickLeftIconAndTopTitleBottomTitleWithViewModel:)])
    {
        [self.delegate authorCell:self clickLeftIconAndTopTitleBottomTitleWithViewModel:self.viewModel];
    }
}

- (void)respondsToTopTitle:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorCell:clickLeftIconAndTopTitleBottomTitleWithViewModel:)])
    {
        [self.delegate authorCell:self clickLeftIconAndTopTitleBottomTitleWithViewModel:self.viewModel];
    }
}

- (void)respondsToBottomTitle:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorCell:clickLeftIconAndTopTitleBottomTitleWithViewModel:)])
    {
        [self.delegate authorCell:self clickLeftIconAndTopTitleBottomTitleWithViewModel:self.viewModel];
    }
}

- (void)respondsToRightView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(authorCell:clickRightButtonWithViewModel:)])
    {
        [self.delegate authorCell:self clickRightButtonWithViewModel:self.viewModel];
    }
}

- (WebImageView *)leftIcon
{
    if (!_leftIcon)
    {
        _leftIcon = [KitFactory imageView];
        _leftIcon.layer.cornerRadius = kIconWidth_Height / 2;
        _leftIcon.layer.masksToBounds = YES;
        _leftIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _leftIcon.userInteractionEnabled = YES;
        [_leftIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLeftIcon:)]];
    }
    return _leftIcon;
}

- (UIButton *)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [KitFactory button];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        _rightButton.layer.cornerRadius = 6;
        _rightButton.layer.masksToBounds = YES;
        _rightButton.translatesAutoresizingMaskIntoConstraints = NO;
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _rightButton;
}

- (UIButton *)rightEditButton
{
    if (!_rightEditButton)
    {
        _rightEditButton = [KitFactory button];
        _rightEditButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_rightEditButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToRightButton:)]];
    }
    return _rightEditButton;
}

- (UILabel *)topTitle
{
    if (!_topTitle)
    {
        _topTitle = [KitFactory label];
        _topTitle.backgroundColor = [UIColor clearColor];
        _topTitle.textColor = RGB(0, 0, 0);
        _topTitle.font = [UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:14]];
        _topTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _topTitle.userInteractionEnabled = YES;
        [_topTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTopTitle:)]];
    }
    return _topTitle;
}

- (UILabel *)bottomTitle
{
    if (!_bottomTitle)
    {
        _bottomTitle = [KitFactory label];
        _bottomTitle.backgroundColor = [UIColor clearColor];
        _bottomTitle.textColor = RGB(191, 191, 191);
        _bottomTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:9]];
        _bottomTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomTitle.userInteractionEnabled = YES;
        [_bottomTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBottomTitle:)]];
    }
    return _bottomTitle;
}

- (UILabel *)rightOption
{
    if (!_rightOption)
    {
        _rightOption = [[UILabel alloc] init];
        _rightOption.backgroundColor = [UIColor clearColor];
        _rightOption.textColor = RGB(191, 191, 191);
        _rightOption.font = [UIFont systemFontOfSize:9];
        _rightOption.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightOption;
}

- (UIView *)rightView
{
    if (!_rightView)
    {
        _rightView = [[UIView alloc] init];
        _rightView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightView.backgroundColor = [UIColor clearColor];
        _rightView.layer.cornerRadius = 5;
        _rightView.layer.borderWidth = kLineHeight;
        _rightView.layer.borderColor = RGB(191, 191, 191).CGColor;
        _rightView.layer.masksToBounds = YES;
        _rightView.userInteractionEnabled = YES;
        [_rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToRightView:)]];
    }
    return _rightView;
}

- (UIImageView *)rightArrowImage
{
    if (!_rightArrowImage)
    {
        _rightArrowImage = [[UIImageView alloc] init];
        _rightArrowImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightArrowImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
