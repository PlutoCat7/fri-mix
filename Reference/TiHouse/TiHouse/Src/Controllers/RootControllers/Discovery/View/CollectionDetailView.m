//
//  CollectionDetailView.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CollectionDetailView.h"
#import "CollectionDetailViewModel.h"

#define kIconWidthHeight 3

@interface CollectionDetailView ()

@property (nonatomic, strong  ) CollectionDetailViewModel *viewModel;
@property (nonatomic, strong  ) WebImageView *largeImage;

@property (nonatomic, strong  ) UIView      *optionTextView;

@property (nonatomic, strong  ) UILabel     *optionTextBottomLabel;

@property (nonatomic, strong  ) UIView      *optionTopView;
@property (nonatomic, strong  ) UIImageView *optionTopLeftIcon;
@property (nonatomic, strong  ) UIImageView *optionTopRightIcon;
@property (nonatomic, strong  ) UILabel     *optionTextTopLabel;

@end

@implementation CollectionDetailView

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
    [self addSubview:self.largeImage];
    
    [self.largeImage addSubview:self.optionTextView];
    
    UIView *optionView = [KitFactory view];
    optionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.optionTextView addSubview:optionView];
    
    [self.optionTopView addSubview:self.optionTextTopLabel];
    [self.optionTopView addSubview:self.optionTopLeftIcon];
    [self.optionTopView addSubview:self.optionTopRightIcon];
    
    [optionView addSubview:self.optionTopView];
    [optionView addSubview:self.optionTextBottomLabel];
    
    [self.optionTextView addSubview:optionView];
    
    [self.optionTopView addConstraint:[NSLayoutConstraint constraintWithItem:self.optionTopLeftIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.optionTopView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.optionTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_optionTopLeftIcon(3)]-8-[_optionTextTopLabel]-8-[_optionTopRightIcon(3)]|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_optionTopLeftIcon,_optionTextTopLabel,_optionTopRightIcon)]];
    [self.optionTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_optionTextTopLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_optionTextTopLabel)]];
    [self.optionTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_optionTopLeftIcon(3)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_optionTopLeftIcon)]];
    [self.optionTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_optionTopRightIcon(3)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_optionTopRightIcon)]];
    
    [optionView addConstraint:[NSLayoutConstraint constraintWithItem:self.optionTopView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:optionView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [optionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_optionTextBottomLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_optionTextBottomLabel)]];
    [optionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_optionTopView]-2-[_optionTextBottomLabel]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_optionTopView,_optionTextBottomLabel)]];
    
    [self.optionTextView addConstraint:[NSLayoutConstraint constraintWithItem:optionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.optionTextView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.optionTextView addConstraint:[NSLayoutConstraint constraintWithItem:optionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.optionTextView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    [self.largeImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-17-[_optionTextView]-17-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_optionTextView)]];
    [self.largeImage addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_optionTextView(56)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_optionTextView)]];
    [self.largeImage addConstraint:[NSLayoutConstraint constraintWithItem:self.optionTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.largeImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_largeImage]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeImage)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_largeImage]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeImage)]];
}

- (void)resetViewWithViewModel:(CollectionDetailViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.largeImage sd_setImageWithURL:[NSURL URLWithString:viewModel.imgUrl] placeholderImage:viewModel.placeHolder];
    
    self.optionTextTopLabel.text = viewModel.topTitle;
    self.optionTextBottomLabel.text = viewModel.bottomTitle;
}

- (void)respondsToCollectionDetailView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionDetailView:clickLargeImageWithViewModel:)])
    {
        [self.delegate collectionDetailView:self clickLargeImageWithViewModel:self.viewModel];
    }
}

- (WebImageView *)largeImage
{
    if (!_largeImage)
    {
        _largeImage = [KitFactory imageView];
        _largeImage.translatesAutoresizingMaskIntoConstraints = NO;
        _largeImage.userInteractionEnabled = YES;
        _largeImage.layer.cornerRadius = 4;
        _largeImage.layer.masksToBounds = YES;
        [_largeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCollectionDetailView:)]];
    }
    return _largeImage;
}

- (UIView *)optionTextView
{
    if (!_optionTextView)
    {
        _optionTextView = [KitFactory view];
        _optionTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _optionTextView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _optionTextView.layer.cornerRadius = 4;
        _optionTextView.layer.masksToBounds = YES;
    }
    return _optionTextView;
}

- (UILabel *)optionTextTopLabel
{
    if (!_optionTextTopLabel)
    {
        _optionTextTopLabel = [KitFactory label];
        _optionTextTopLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _optionTextTopLabel.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:9]];
        _optionTextTopLabel.textColor = RGB(96, 96, 96);
        _optionTextTopLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _optionTextTopLabel;
}

- (UILabel *)optionTextBottomLabel
{
    if (!_optionTextBottomLabel)
    {
        _optionTextBottomLabel = [KitFactory label];
        _optionTextBottomLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _optionTextBottomLabel.font = [UIFont boldSystemFontOfSize:[UIFont adjustFontFromFontSize:12]];
        _optionTextBottomLabel.textColor = [UIColor blackColor];
        _optionTextBottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _optionTextBottomLabel;
}

- (UIImageView *)optionTopLeftIcon
{
    if (!_optionTopLeftIcon)
    {
        _optionTopLeftIcon = [KitFactory imageView];
        _optionTopLeftIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _optionTopLeftIcon.backgroundColor = RGBA(96, 96, 96, 0.9);
        _optionTopLeftIcon.layer.cornerRadius = kIconWidthHeight / 2;
        _optionTopLeftIcon.layer.masksToBounds = YES;
    }
    return _optionTopLeftIcon;
}

- (UIImageView *)optionTopRightIcon
{
    if (!_optionTopRightIcon)
    {
        _optionTopRightIcon = [KitFactory imageView];
        _optionTopRightIcon.translatesAutoresizingMaskIntoConstraints = NO;
        _optionTopRightIcon.backgroundColor = RGBA(96, 96, 96, 0.9);
        _optionTopRightIcon.layer.cornerRadius = kIconWidthHeight / 2;
        _optionTopRightIcon.layer.masksToBounds = YES;
    }
    return _optionTopRightIcon;
}

- (UIView *)optionTopView
{
    if (!_optionTopView)
    {
        _optionTopView = [KitFactory view];
        _optionTopView.translatesAutoresizingMaskIntoConstraints = NO; 
    }
    return _optionTopView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
