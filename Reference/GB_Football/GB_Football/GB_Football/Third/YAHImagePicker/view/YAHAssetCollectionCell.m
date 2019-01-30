//
//  YAHAssetCollectionCell.m
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/8.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import "YAHAssetCollectionCell.h"
#import "YAHGradientView.h"
#import "YAHPhotoTools.h"
#import "NSDate+YAHTimeInterval.h"

@interface YAHAssetCollectionCell ()

@property (weak, nonatomic) IBOutlet YAHGradientView *videoDetailView;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *hasSelectedView;

@end

@implementation YAHAssetCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.hasSelectedView.hidden = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.hasSelectedView.hidden = !selected;
}

#pragma mark - Public

- (void)bind:(YAHPhotoModel *)asset {
    
    if (asset.thumbImage) {
        self.imageView.image = asset.thumbImage;
    }else {
        __weak __typeof(self)weakSelf = self;
        [YAHPhotoTools getPhotoForPHAsset:asset.asset size:CGSizeMake(kThumbnailLength*1.4, kThumbnailLength*1.4) completion:^(UIImage *image, NSDictionary *info) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.imageView.image = image;
        }];
    }
    if (asset.asset.mediaType == PHAssetMediaTypeVideo) {
        
        self.videoDetailView.hidden = NO;
        self.videoTimeLabel.text = [NSDate timeDescriptionOfTimeInterval:asset.asset.duration];
    }else {
        self.videoDetailView.hidden = YES;
    }
}

@end
