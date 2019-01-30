//
//  AdvertisementsOptionTitleCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AdvertisementsOptionTitleCell.h"
#import "AdvertisementsOptionTitleViewModel.h"

@interface  AdvertisementsOptionTitleCell ()

@property (nonatomic, strong) AdvertisementsOptionTitleViewModel *viewModel;
@property (nonatomic, strong) UILabel     *option;
@property (nonatomic, strong) UILabel     *rightOption;
@property (nonatomic, strong) UIImageView *rightArrowImage;
@property (nonatomic, strong) UIView      *rightView;

@end

@implementation AdvertisementsOptionTitleCell

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
    
    [self.contentView addSubview:self.option];
    
    [self.rightView addSubview:self.rightArrowImage];
    [self.rightView addSubview:self.rightOption];
    [self.contentView addSubview:self.rightView];
    
    [self.rightView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightOption attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_rightOption]-2-[_rightArrowImage]-4-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_rightOption,_rightArrowImage)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.option attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_option]-(>=13)-[_rightView]-13-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_option,_rightView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rightView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightView)]];
}

- (void)resetCellWithViewModel:(AdvertisementsOptionTitleViewModel *)model
{
    [super resetCellWithViewModel:model];

    self.viewModel = model;
    self.option.text = model.title;
    self.rightOption.text = model.rightTitle;
    self.rightArrowImage.image = model.icon;
}

- (void)respondsToRightView:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(advertisementsOptionTitleCell:clickRightViewWithViewModel:)])
    {
        [self.delegate advertisementsOptionTitleCell:self clickRightViewWithViewModel:self.viewModel];
    }
}

- (UILabel *)option
{
    if (!_option)
    {
        _option = [[UILabel alloc] init];
        _option.backgroundColor = [UIColor clearColor];
        _option.textColor = RGB(96, 96, 96);
        _option.font = [UIFont systemFontOfSize:13];
        _option.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _option;
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
