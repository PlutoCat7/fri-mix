//
//  OnePictureCell.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/11.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "OnePictureCell.h"
#import "OnePictureViewModel.h"

@interface OnePictureCell ()

@property (nonatomic, strong  ) OnePictureViewModel *viewModel;
@property (nonatomic, strong  ) UIImageView         *topRightIcon;

@end

@implementation OnePictureCell

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
    
    [self.contentView addSubview:self.largeImage];
    [self.contentView addSubview:self.topRightIcon];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_largeImage]-10-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeImage)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_largeImage]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_largeImage)]];
     
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_topRightIcon]-20-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topRightIcon)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_topRightIcon]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_topRightIcon)]];
     
}

- (void)resetCellWithViewModel:(OnePictureViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.largeImage sd_setImageWithURL:[NSURL URLWithString:viewModel.imgUrl] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    
    self.topRightIcon.image = viewModel.topRightIcon;
    self.topRightIcon.hidden = !viewModel.hasTopRightIcon;
}

- (void)respondsToLargeImage:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onePictureCell:clickPhotoWithViewModel:)])
    {
        [self.delegate onePictureCell:self clickPhotoWithViewModel:self.viewModel];
    }
}

- (WebImageView *)largeImage
{
    if (!_largeImage)
    {
        _largeImage = [KitFactory imageView];
        _largeImage.translatesAutoresizingMaskIntoConstraints = NO;
        _largeImage.userInteractionEnabled = YES;
        [_largeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLargeImage:)]];
    }
    return _largeImage;
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
