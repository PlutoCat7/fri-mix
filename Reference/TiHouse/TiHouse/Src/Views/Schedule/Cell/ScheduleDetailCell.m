//
//  ScheduleDetailCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleDetailCell.h"
#import "ScheduleDetailViewModel.h"

@interface ScheduleDetailCell ()

@property (nonatomic, strong  ) UILabel *leftLabel;
@property (nonatomic, strong  ) UILabel *rightLabel;

@end

@implementation ScheduleDetailCell

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
    
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_leftLabel(20)]-10-[_rightLabel]-(>=22)-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_leftLabel,_rightLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftLabel(20)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_leftLabel)]];
}

- (void)resetCellWithViewModel:(ScheduleDetailViewModel *)model
{
    [super resetCellWithViewModel:model];

    self.leftLabel.backgroundColor = model.leftIconBackgroundColor;
    self.leftLabel.text = model.leftIconTitle;
    self.rightLabel.text = model.optionText;

}

- (UILabel *)leftLabel
{
    if (!_leftLabel)
    {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.font = [UIFont systemFontOfSize:6];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel)
    {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = RGB(96, 96, 96);
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightLabel;
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
