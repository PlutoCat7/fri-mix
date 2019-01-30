//
//  LeftRightLabelCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "LeftRightLabelCell.h"
#import "LeftRightLabelViewModel.h"

@interface LeftRightLabelCell ()

@property (nonatomic, strong) LeftRightLabelViewModel *viewModel;
@property (nonatomic, strong) UILabel     *leftOption;
@property (nonatomic, strong) UILabel     *rightOption;

@end

@implementation LeftRightLabelCell

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
    
    [self.contentView addSubview:self.leftOption];
    [self.contentView addSubview:self.rightOption];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftOption attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_leftOption]-(>=10)-[_rightOption]-10-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_leftOption,_rightOption)]];
}

- (void)resetCellWithViewModel:(LeftRightLabelViewModel *)model
{
    [super resetCellWithViewModel:model];
    
    self.viewModel = model;
    
    self.leftOption.text = model.leftTitle;
    self.rightOption.text = model.rightTitle;
}

- (UILabel *)leftOption
{
    if (!_leftOption)
    {
        _leftOption = [[UILabel alloc] init];
        _leftOption.backgroundColor = [UIColor clearColor];
        _leftOption.textColor = RGB(0, 0, 0);
        _leftOption.font = [UIFont systemFontOfSize:14];
        _leftOption.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftOption;
}

- (UILabel *)rightOption
{
    if (!_rightOption)
    {
        _rightOption = [[UILabel alloc] init];
        _rightOption.backgroundColor = [UIColor clearColor];
        _rightOption.textColor = RGB(191, 191, 191);
        _rightOption.font = [UIFont systemFontOfSize:12];
        _rightOption.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightOption;
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
