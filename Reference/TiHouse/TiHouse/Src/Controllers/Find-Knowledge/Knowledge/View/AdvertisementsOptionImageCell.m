//
//  AdvertisementsOptionImageCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AdvertisementsOptionImageCell.h"
#import "AdvertisementsOptionImageViewModel.h"

@interface  AdvertisementsOptionImageCell ()

@property (nonatomic, strong) AdvertisementsOptionImageViewModel *viewModel;
@property (nonatomic, strong) UIImageView     *topImage;

@end

@implementation AdvertisementsOptionImageCell

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
    [self.contentView addSubview:self.largeImage];
    [self.largeImage addSubview:self.topImage];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_largeImage]-12-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeImage)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_largeImage]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeImage)]];
     
    [self.largeImage addConstraint:[NSLayoutConstraint constraintWithItem:self.topImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.largeImage attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.largeImage addConstraint:[NSLayoutConstraint constraintWithItem:self.topImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.largeImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

- (void)resetCellWithViewModel:(AdvertisementsOptionImageViewModel *)model
{
    [super resetCellWithViewModel:model];
    
    self.viewModel = model;
    [self.largeImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:model.placeHolderImage];
    
    if (model.hasBoarder)
    {
        self.largeImage.layer.borderColor = RGB(153, 153, 153).CGColor;
        self.largeImage.layer.borderWidth = kLineHeight;
    }
    
    self.topImage.hidden = model.topImage == nil;
    self.topImage.image = model.topImage;
    
    self.backgroundColor = model.cellBackgroundColor;
  
}

- (WebImageView *)largeImage
{
    if (!_largeImage)
    {
        _largeImage = [[WebImageView alloc] init];
        _largeImage.translatesAutoresizingMaskIntoConstraints = NO;
        _largeImage.backgroundColor = [UIColor clearColor];
        _largeImage.layer.masksToBounds = YES;
        _largeImage.tag = 101;
        _largeImage.userInteractionEnabled = YES;
        _largeImage.contentMode = UIViewContentModeScaleAspectFill;
        _largeImage.clipsToBounds = YES;
    }
    return _largeImage;
}

- (UIImageView *)topImage
{
    if (!_topImage)
    {
        _topImage = [[UIImageView alloc] init];
        _topImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _topImage;
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
