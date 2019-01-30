//
//  TableviewListIsEmptyCell.m
//  YouSuHuoPinPoint
//
//  Created by Teen Ma on 2017/12/1.
//  Copyright © 2017年 Teen Ma. All rights reserved.
//

#import "TableviewListIsEmptyCell.h"
#import "TableviewListIsEmptyViewModel.h"

@interface TableviewListIsEmptyCell ()

@property (nonatomic, strong) UIImageView *emptyImage;

@end

@implementation TableviewListIsEmptyCell

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
    [self.contentView addSubview:self.emptyImage];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.emptyImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)resetCellWithViewModel:(TableviewListIsEmptyViewModel *)model
{
    self.emptyImage.image = model.emptyImage;
}

- (UIImageView *)emptyImage
{
    if (!_emptyImage)
    {
        _emptyImage = [KitFactory imageView];
        _emptyImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _emptyImage;
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
