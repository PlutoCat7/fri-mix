//
//  YHPreSelectAssetCell.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHPreSelectAssetCell.h"
#import "YAHPhotoTools.h"

@interface YAHPreSelectAssetCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YAHPreSelectAssetCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Create a image view
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

#pragma mark - setter
- (void)setAsset:(YAHPhotoModel *)asset {
    
    if (_asset != asset) {
        _asset = asset;
        
        // Update view
        if (asset.thumbImage) {
            self.imageView.image = asset.thumbImage;
        }else {
            [YAHPhotoTools getPhotoForPHAsset:asset.asset size:CGSizeMake(YHPreSelectAssetCellWidth*1.4, YHPreSelectAssetCellWidth*1.4) completion:^(UIImage *image, NSDictionary *info) {
                self.imageView.image = image;
            }];
        }
    }
}

@end
