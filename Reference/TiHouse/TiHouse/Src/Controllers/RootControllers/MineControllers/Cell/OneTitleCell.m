//
//  OneTitleCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "OneTitleCell.h"
#import "OneTitleViewModel.h"

@interface OneTitleCell ()

@property (nonatomic, strong  ) UILabel *contentTitle;

@end

@implementation OneTitleCell

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
    [self.contentView addSubview:self.contentTitle];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_contentTitle]-(>=12)-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_contentTitle)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)resetCellWithViewModel:(OneTitleViewModel *)model
{
    [super resetCellWithViewModel:model];
    self.contentTitle.text = model.title;
}

- (UILabel *)contentTitle
{
    if (!_contentTitle)
    {
        _contentTitle = [KitFactory label];
        _contentTitle.textColor = RGB(192, 192, 192);
        _contentTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:14]];
        _contentTitle.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentTitle;
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
