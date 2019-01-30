//
//  YHImagePickerGroupCell.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePickerGroupCell.h"
#import "YAHImagePickerThumbnailView.h"
#import "YAHImagePickerDefines.h"
#import "YAHAlbumModel.h"

@interface YAHImagePickerGroupCell ()

@property (nonatomic, strong) YAHImagePickerThumbnailView *thumbnailView;	// 相册缩略图
@property (nonatomic, strong) UILabel *nameLabel;		// 相簿名
@property (nonatomic, strong) UILabel *countLabel;		// 相簿媒体个数

@end

@implementation YAHImagePickerGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    if (self) {
        // Cell settings
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Create thumbnail view
        CGFloat top = 10;
        YAHImagePickerThumbnailView *thumbnailView = [[YAHImagePickerThumbnailView alloc] initWithFrame:CGRectMake(24, top, YHImagePickerGroupCellHeight-2*top, YHImagePickerGroupCellHeight-2*top)];
        thumbnailView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:thumbnailView];
        self.thumbnailView = thumbnailView;
        
        // Create name label
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(24 + 60 + 18, (YHImagePickerGroupCellHeight-20)/2, 180, 20)];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [UIColor colorWithWhite:0 alpha:0.87];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // Create count label
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(24 + 60 + 18 + 15, (YHImagePickerGroupCellHeight-20)/2, 180, 20)];
        countLabel.font = [UIFont systemFontOfSize:16];
        countLabel.textColor = [UIColor colorWithWhite:0 alpha:0.54];
        countLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:countLabel];
        self.countLabel = countLabel;
        
    }
    
    return self;
}

#pragma mark - Custom Accessors

- (void)setAssetsGroup:(YAHAlbumModel *)assetsGroup {
    _assetsGroup = assetsGroup;
    
    // Update thumbnail view
    self.thumbnailView.assetsGroup = self.assetsGroup;
    
    // Update label
    self.nameLabel.text = self.assetsGroup.albumName;
    CGSize size = [self sizeWithFont:self.nameLabel.font byHeight:CGRectGetHeight(self.nameLabel.frame) string:self.nameLabel.text];
    
    CGRect rect = self.countLabel.frame;
    rect.origin.x = CGRectGetMinX(self.nameLabel.frame) + size.width + 15;
    self.countLabel.frame = rect;
    self.countLabel.text = [NSString stringWithFormat:@"( %td )", self.assetsGroup.count];
    
    [self setNeedsDisplay];
}

#pragma mark - Private

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height string:(NSString *)string
{
    return [string sizeWithFont:font
              constrainedToSize:CGSizeMake(999999.0f, height)
                  lineBreakMode:UILineBreakModeWordWrap];
}

@end
