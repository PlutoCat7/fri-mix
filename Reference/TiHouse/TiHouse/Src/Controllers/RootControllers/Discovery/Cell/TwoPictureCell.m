//
//  TwoPictureCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TwoPictureCell.h"
#import "TwoPictureViewModel.h"

@interface TwoPictureCell ()

@property (nonatomic, strong  ) TwoPictureViewModel *viewModel;
@property (nonatomic, strong  ) UIImageView         *topRightIcon;
@property (nonatomic, strong  ) UIImageView         *topLeftIcon;

@end

@implementation TwoPictureCell

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
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.rightImageView];
    
    [self.leftImageView addSubview:self.topLeftIcon];
    [self.rightImageView addSubview:self.topRightIcon];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_leftImageView]-6-[_rightImageView]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftImageView,_rightImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_leftImageView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftImageView)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.rightImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.rightImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    
    [self.leftImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_topLeftIcon]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topLeftIcon)]];
    [self.leftImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_topLeftIcon]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topLeftIcon)]];

    [self.rightImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_topRightIcon]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topRightIcon)]];
    [self.rightImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_topRightIcon]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topRightIcon)]];
}

- (void)resetCellWithViewModel:(TwoPictureViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.firstImageUrl] placeholderImage:viewModel.firstPlaceHolder];
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.secondImageUrl] placeholderImage:viewModel.secondPlaceHolder];
    self.topLeftIcon.image = viewModel.topLeftIcon;
    self.topLeftIcon.hidden = !viewModel.hasTopLeftIcon;
    
    self.topRightIcon.image = viewModel.topRightIcon;
    self.topRightIcon.hidden = !viewModel.hasTopRightIcon;
}

- (void)respondsToLeftImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(twoPictureCell:clickLeftImageWithViewModel:)])
    {
        [self.delegate twoPictureCell:self clickLeftImageWithViewModel:self.viewModel];
    }
}

- (void)respondsToRightImageView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(twoPictureCell:clickRightImageWithViewModel:)])
    {
        [self.delegate twoPictureCell:self clickRightImageWithViewModel:self.viewModel];
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

- (UIImageView *)rightImageView
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

- (UIImageView *)topRightIcon
{
    if (!_topRightIcon)
    {
        _topRightIcon = [KitFactory imageView];
        _topRightIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _topRightIcon;
}

- (UIImageView *)topLeftIcon
{
    if (!_topLeftIcon)
    {
        _topLeftIcon = [KitFactory imageView];
        _topLeftIcon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _topLeftIcon;
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
