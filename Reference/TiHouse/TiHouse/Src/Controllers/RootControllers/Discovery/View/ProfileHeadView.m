//
//  ProfileHeadView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/18.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ProfileHeadView.h"
#import "ProfileHeadViewModel.h"

#define kIconWidthHeight 60

@interface ProfileHeadView ()

@property (nonatomic, strong  ) ProfileHeadViewModel *viewModel;

@property (nonatomic, strong  ) UIImageView *backgroundImageView;
@property (nonatomic, strong  ) UIImageView *tmpBackgroundImageView;

@property (nonatomic, strong  ) UILabel     *nameLabel;

@property (nonatomic, strong  ) UIView      *centerButtonView;
@property (nonatomic, strong  ) UIImageView *centerLeftImage;
@property (nonatomic, strong  ) UILabel     *centerRightTitle;

@property (nonatomic, strong  ) UIButton    *centerButton;

@property (nonatomic, strong  ) UIView      *bottomView;
@property (nonatomic, strong  ) UILabel     *bottomLeftLabel;
@property (nonatomic, strong  ) UILabel     *bottomRightLabel;

@property (nonatomic, strong  ) UIImageView *bottomRightImageView;

@end

@implementation ProfileHeadView

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
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.tmpBackgroundImageView];
    [self addSubview:self.topIcon];
    [self addSubview:self.nameLabel];
    [self addSubview:self.centerButtonView];
    [self addSubview:self.centerButton];
    [self addSubview:self.bottomView];
    [self addSubview:self.bottomRightImageView];
    
    [self.centerButtonView addSubview:self.centerLeftImage];
    [self.centerButtonView addSubview:self.centerRightTitle];
    
    [self.bottomView addSubview:self.bottomLeftLabel];
    [self.bottomView addSubview:self.bottomRightLabel];
    
    [self.centerButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_centerLeftImage]-4-[_centerRightTitle]-16-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_centerLeftImage,_centerRightTitle)]];
    [self.centerButtonView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_centerLeftImage]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_centerLeftImage)]];
    
    [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomLeftLabel]-18-[_bottomRightLabel]|" options:NSLayoutFormatAlignAllTop metrics:0 views:NSDictionaryOfVariableBindings(_bottomLeftLabel,_bottomRightLabel)]];
    [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bottomLeftLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomLeftLabel)]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_backgroundImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tmpBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tmpBackgroundImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tmpBackgroundImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tmpBackgroundImageView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_topIcon(kIconWidthHeight)]" options:0 metrics:@{@"kIconWidthHeight":@(kIconWidthHeight)} views:NSDictionaryOfVariableBindings(_topIcon)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topIcon(kIconWidthHeight)]-9-[_nameLabel]-12-[_centerButtonView]-15-[_bottomView]-12-|" options:NSLayoutFormatAlignAllCenterX metrics:@{@"kIconWidthHeight":@(kIconWidthHeight)} views:NSDictionaryOfVariableBindings(_topIcon,_nameLabel,_centerButtonView,_bottomView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nameLabel]-12-[_centerButton]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_nameLabel,_centerButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_centerButton(70)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_centerButton)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.centerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.centerButtonView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.centerButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_bottomRightImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomRightImageView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomRightImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bottomRightImageView)]];
}

- (void)resetViewWithViewModel:(ProfileHeadViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.topIcon sd_setImageWithURL:[NSURL URLWithString:viewModel.imageUrl] placeholderImage:viewModel.placeHolderImage];
    
    self.nameLabel.text = viewModel.name;
    
    self.centerButtonView.hidden = YES;
    self.centerButton.hidden = YES;
    
    self.centerButtonView.hidden = viewModel.hasButton;
    self.centerButton.hidden = !self.centerButtonView.hidden;
    
    self.centerLeftImage.image = viewModel.buttonLeftImage;
    self.centerRightTitle.text = viewModel.buttonRightText;
    
    self.centerButton.backgroundColor = viewModel.buttonBackgroundColor;
    [self.centerButton setTitle:viewModel.buttonText forState:UIControlStateNormal];
    
    self.bottomLeftLabel.text = viewModel.bottomLeftTitle;
    if (viewModel.bottomLeftAttributedTitle.length > 0)
    {
        NSMutableAttributedString *tmpContent = [[NSMutableAttributedString alloc]initWithString:viewModel.bottomLeftTitle];
        NSRange range = [[tmpContent string] rangeOfString:viewModel.bottomLeftAttributedTitle];
        [tmpContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:12.0f]] range:range];
        self.bottomLeftLabel.attributedText = tmpContent;
    }
    
    self.bottomRightLabel.text = viewModel.bottomRightTitle;
    if (viewModel.bottomRightAttributedTitle.length > 0)
    {
        NSMutableAttributedString *tmpContent = [[NSMutableAttributedString alloc]initWithString:viewModel.bottomRightTitle];
        NSRange range = [[tmpContent string] rangeOfString:viewModel.bottomRightAttributedTitle];
        [tmpContent addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:12.0f]] range:range];
        self.bottomRightLabel.attributedText = tmpContent;
    }
    
    self.bottomRightImageView.image = viewModel.bottomRightImage;
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.backgroundColorImageUrl] placeholderImage:viewModel.backgroundColorImage];
    
    self.tmpBackgroundImageView.userInteractionEnabled = viewModel.backgroundCanTouched;
}

- (void)respondsToTopIcon:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileHeadView:clickTopImageViewWithViewModel:)])
    {
        [self.delegate profileHeadView:self clickTopImageViewWithViewModel:self.viewModel];
    }
}

- (void)respondsToContentButtonView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileHeadView:clickCenterButtonViewWithViewModel:)])
    {
        [self.delegate profileHeadView:self clickCenterButtonViewWithViewModel:self.viewModel];
    }
}

- (void)respondsToBottomLeftLabel:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileHeadView:clickBottomLeftViewWithViewModel:)])
    {
        [self.delegate profileHeadView:self clickBottomLeftViewWithViewModel:self.viewModel];
    }
}

- (void)respondsToBottomRightLabel:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileHeadView:clickBottomRightViewWithViewModel:)])
    {
        [self.delegate profileHeadView:self clickBottomRightViewWithViewModel:self.viewModel];
    }
}

- (void)respondsToTmpBackgroundImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(profileHeadView:clickBackgroundImageViewWithViewModel:)])
    {
        [self.delegate profileHeadView:self clickBackgroundImageViewWithViewModel:self.viewModel];
    }
}

- (UIImageView *)topIcon
{
    if (!_topIcon)
    {
        _topIcon = [KitFactory imageView];
        _topIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _topIcon.layer.cornerRadius = kIconWidthHeight / 2;
        _topIcon.layer.borderWidth = 2;
        _topIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        _topIcon.layer.masksToBounds = YES;
        _topIcon.userInteractionEnabled = YES;
        [_topIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTopIcon:)]];
    }
    return _topIcon;
}

- (UIImageView *)centerLeftImage
{
    if (!_centerLeftImage)
    {
        _centerLeftImage = [KitFactory imageView];
        _centerLeftImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _centerLeftImage;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [KitFactory imageView];
        _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}

- (UIImageView *)tmpBackgroundImageView
{
    if (!_tmpBackgroundImageView)
    {
        _tmpBackgroundImageView = [KitFactory imageView];
        _tmpBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _tmpBackgroundImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [_tmpBackgroundImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTmpBackgroundImageView:)]];
    }
    return _tmpBackgroundImageView;
}


- (UIImageView *)bottomRightImageView
{
    if (!_bottomRightImageView)
    {
        _bottomRightImageView = [KitFactory imageView];
        _bottomRightImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomRightImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [KitFactory label];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:16]];
    }
    return _nameLabel;
}

- (UILabel *)centerRightTitle
{
    if (!_centerRightTitle)
    {
        _centerRightTitle = [KitFactory label];
        _centerRightTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _centerRightTitle.textColor = RGB(68, 68, 75);
        _centerRightTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:12]];
    }
    return _centerRightTitle;
}

- (UILabel *)bottomLeftLabel
{
    if (!_bottomLeftLabel)
    {
        _bottomLeftLabel = [KitFactory label];
        _bottomLeftLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomLeftLabel.textColor = [UIColor whiteColor];
        _bottomLeftLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        _bottomLeftLabel.userInteractionEnabled = YES;
        [_bottomLeftLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBottomLeftLabel:)]];
    }
    return _bottomLeftLabel;
}

- (UILabel *)bottomRightLabel
{
    if (!_bottomRightLabel)
    {
        _bottomRightLabel = [KitFactory label];
        _bottomRightLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomRightLabel.textColor = [UIColor whiteColor];
        _bottomRightLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        _bottomRightLabel.userInteractionEnabled = YES;
        [_bottomRightLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToBottomRightLabel:)]];
    }
    return _bottomRightLabel;
}

- (UIView *)centerButtonView
{
    if (!_centerButtonView)
    {
        _centerButtonView = [KitFactory view];
        _centerButtonView.translatesAutoresizingMaskIntoConstraints = NO;
        _centerButtonView.layer.cornerRadius = 4;
        _centerButtonView.layer.masksToBounds = YES;
        _centerButtonView.backgroundColor = [UIColor whiteColor];
        _centerButtonView.userInteractionEnabled = YES;
        [_centerButtonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToContentButtonView:)]];
    }
    return _centerButtonView;
}

- (UIButton *)centerButton
{
    if (!_centerButton)
    {
        _centerButton = [KitFactory button];
        _centerButton.translatesAutoresizingMaskIntoConstraints = NO;
        _centerButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        [_centerButton setTitleColor:RGB(96, 96, 96) forState:UIControlStateNormal];
        [_centerButton addTarget:self action:@selector(respondsToContentButtonView:) forControlEvents:UIControlEventTouchUpInside];
        _centerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _centerButton.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
        _centerButton.layer.cornerRadius = 6;
        _centerButton.layer.masksToBounds = YES;
    }
    return _centerButton;
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [KitFactory view];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _bottomView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
