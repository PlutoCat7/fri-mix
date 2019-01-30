//
//  LeftRightTitleArrowCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/23.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "LeftRightTitleArrowCell.h"
#import "LeftRightTitleArrowViewModel.h"

@interface LeftRightTitleArrowCell ()

@property (nonatomic, strong  ) UILabel *leftTitle;
@property (nonatomic, strong  ) UILabel *rightTitle;
@property (nonatomic, strong  ) UIImageView *arrowImage;

@end

@implementation LeftRightTitleArrowCell

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
    
    [self.contentView addSubview:self.leftTitle];
    [self.contentView addSubview:self.rightTitle];
    [self.contentView addSubview:self.arrowImage];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_leftTitle]-(>=12)-[_rightTitle][_arrowImage]-12-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_leftTitle,_rightTitle,_arrowImage)]];
}

- (void)resetCellWithViewModel:(LeftRightTitleArrowViewModel *)model
{
    [super resetCellWithViewModel:model];
    
    self.leftTitle.text = model.leftTitle;
    self.rightTitle.text = model.rightTitle;
    self.arrowImage.image = model.arrowImage;
}

- (UILabel *)leftTitle
{
    if (!_leftTitle)
    {
        _leftTitle = [KitFactory label];
        _leftTitle.textColor = RGB(51, 51, 51);
        _leftTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:14]];
        _leftTitle.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _leftTitle;
}

- (UILabel *)rightTitle
{
    if (!_rightTitle)
    {
        _rightTitle = [KitFactory label];
        _rightTitle.textColor = RGB(178, 178, 178);
        _rightTitle.font = [UIFont systemFontOfSize:[UIFont adjustFontFromFontSize:14]];
        _rightTitle.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _rightTitle;
}

- (UIImageView *)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [KitFactory imageView];
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
