//
//  ThreePictureCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ThreePictureCell.h"
#import "ThreePictureViewModel.h"

@interface ThreePictureCell ()

@property (nonatomic, strong  ) ThreePictureViewModel *viewModel;
@property (nonatomic, strong  ) UIImageView           *firstIcon;
@property (nonatomic, strong  ) UIImageView           *secondIcon;
@property (nonatomic, strong  ) UIImageView           *thirdIcon;

@end

@implementation ThreePictureCell

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
    
    [self.leftImageView addSubview:self.firstIcon];
    [self.contentView addSubview:self.leftImageView];
    
    [self.centerImageView addSubview:self.secondIcon];
    [self.contentView addSubview:self.centerImageView];
    
    [self.rightImageView addSubview:self.thirdIcon];
    [self.contentView addSubview:self.rightImageView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_leftImageView]-2-[_centerImageView]-2-[_rightImageView]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftImageView,_rightImageView,_centerImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.rightImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.rightImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.centerImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.rightImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.centerImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.rightImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self.leftImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_firstIcon]-20-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_firstIcon)]];
    [self.leftImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_firstIcon]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_firstIcon)]];
    
    [self.centerImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_secondIcon]-20-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_secondIcon)]];
    [self.centerImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_secondIcon]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_secondIcon)]];
    
    [self.rightImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_thirdIcon]-20-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_thirdIcon)]];
    [self.rightImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_thirdIcon]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_thirdIcon)]];
}

- (void)resetCellWithViewModel:(ThreePictureViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    self.leftImageView.hidden = YES;
    self.centerImageView.hidden = YES;
    self.rightImageView.hidden = YES;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.firstImageUrl] placeholderImage:viewModel.firstPlaceHolder];
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.secondImageUrl] placeholderImage:viewModel.secondPlaceHolder];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.thirdImageUrl] placeholderImage:viewModel.thirdPlaceHolder];
    
    self.leftImageView.hidden = viewModel.firstImageUrl.length == 0;
    self.centerImageView.hidden = viewModel.secondImageUrl.length == 0;
    self.rightImageView.hidden = viewModel.thirdImageUrl.length == 0;
    
    self.firstIcon.image = viewModel.firstTopIcon;
    self.firstIcon.hidden = !viewModel.hasFirstTopIcon;
    
    self.secondIcon.image = viewModel.secondTopIcon;
    self.secondIcon.hidden = !viewModel.hasSecondTopIcon;
    
    self.thirdIcon.image = viewModel.thirdTopIcon;
    self.thirdIcon.hidden = !viewModel.hasThirdTopIcon;
}

- (void)respondsToLeftImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(threePictureCell:clickLeftImageWithViewModel:)])
    {
        [self.delegate threePictureCell:self clickLeftImageWithViewModel:self.viewModel];
    }
}

- (void)respondsToRightImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(threePictureCell:clickRightImageWithViewModel:)])
    {
        [self.delegate threePictureCell:self clickRightImageWithViewModel:self.viewModel];
    }
}

- (void)respondsToCenterImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(threePictureCell:clickCenterImageWithViewModel:)])
    {
        [self.delegate threePictureCell:self clickCenterImageWithViewModel:self.viewModel];
    }
}

- (WebImageView *)leftImageView
{
    if (!_leftImageView)
    {
        _leftImageView = [[WebImageView alloc] init];
        _leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _leftImageView.userInteractionEnabled = YES;
        [_leftImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLeftImageView:)]];
    }
    return _leftImageView;
}

- (WebImageView *)rightImageView
{
    if (!_rightImageView)
    {
        _rightImageView = [[WebImageView alloc] init];
        _rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightImageView.userInteractionEnabled = YES;
        [_rightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToRightImageView:)]];
    }
    return _rightImageView;
}

- (WebImageView *)centerImageView
{
    if (!_centerImageView)
    {
        _centerImageView = [[WebImageView alloc] init];
        _centerImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToCenterImageView:)]];
    }
    return _centerImageView;
}

- (UIImageView *)firstIcon
{
    if (!_firstIcon)
    {
        _firstIcon = [KitFactory imageView];
        _firstIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _firstIcon;
}

- (UIImageView *)secondIcon
{
    if (!_secondIcon)
    {
        _secondIcon = [KitFactory imageView];
        _secondIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _secondIcon;
}

- (UIImageView *)thirdIcon
{
    if (!_thirdIcon)
    {
        _thirdIcon = [KitFactory imageView];
        _thirdIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _thirdIcon;
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
