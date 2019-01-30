//
//  OptionDetailCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "OptionDetailCell.h"
#import "OptionDetailViewModel.h"

@interface  OptionDetailCell ()

@property (nonatomic, strong) OptionDetailViewModel *viewModel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel     *option;
@property (nonatomic, strong) UILabel     *rightOption;
@property (nonatomic, strong) UIImageView *arrowImage;

@end

@implementation OptionDetailCell

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
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.option];
    [self.contentView addSubview:self.rightOption];
    [self.contentView addSubview:self.arrowImage];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.icon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_icon]-8-[_option]-(>=10)-[_rightOption(14)]-8-[_arrowImage]-12-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_icon,_option,_rightOption,_arrowImage)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightOption(14)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_rightOption)]];
}

- (void)resetCellWithViewModel:(OptionDetailViewModel *)model
{
    [super resetCellWithViewModel:model];
    
    self.viewModel = model;
    
    self.icon.image = model.leftIcon;
    self.option.text = model.optionText;
    
    self.rightOption.hidden = [model.rightOptionText integerValue] == 0;
    self.rightOption.text = model.rightOptionText;
    
    self.arrowImage.image = model.arrowImage;
}

- (UIImageView *)icon
{
    if (!_icon)
    {
        _icon = [[UIImageView alloc] init];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
        _icon.backgroundColor = [UIColor clearColor];
    }
    return _icon;
}

- (UILabel *)option
{
    if (!_option)
    {
        _option = [[UILabel alloc] init];
        _option.backgroundColor = [UIColor clearColor];
        _option.textColor = RGB(96, 96, 96);
        _option.font = [UIFont systemFontOfSize:14];
        _option.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _option;
}

- (UILabel *)rightOption
{
    if (!_rightOption)
    {
        _rightOption = [[UILabel alloc] init];
        _rightOption.backgroundColor = RGB(241, 56, 56);
        _rightOption.textColor = [UIColor whiteColor];
        _rightOption.font = [UIFont systemFontOfSize:8];
        _rightOption.translatesAutoresizingMaskIntoConstraints = NO;
        _rightOption.layer.cornerRadius = 14/2;
        _rightOption.layer.masksToBounds = YES;
        _rightOption.textAlignment = NSTextAlignmentCenter;
    }
    return _rightOption;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [[UIImageView alloc] init];
        _arrowImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _arrowImage;
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
