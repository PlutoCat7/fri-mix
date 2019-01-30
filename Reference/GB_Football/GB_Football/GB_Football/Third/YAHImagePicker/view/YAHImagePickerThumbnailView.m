//
//  YHImagePickerThumbnailView.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHImagePickerThumbnailView.h"
#import "YAHAlbumModel.h"
#import "YAHPhotoModel.h"
#import "YAHPhotoTools.h"

@interface YAHImagePickerThumbnailView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YAHImagePickerThumbnailView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setAssetsGroup:(YAHAlbumModel *)assetsGroup {
    
    if (!assetsGroup) {
        return;
    }
    
    _assetsGroup = assetsGroup;
    YAHPhotoModel *model = [[YAHPhotoModel alloc] init];
    model.asset = assetsGroup.result.lastObject;
    self.asset = model;
}

- (void)setAsset:(YAHPhotoModel *)asset {
    
    if (!asset) {
        return;
    }
    _asset = asset;
    
    if (asset.thumbImage) {
        self.imageView.image = asset.thumbImage;
    }else {
        __weak __typeof(self)weakSelf = self;
        [YAHPhotoTools getPhotoForPHAsset:asset.asset size:CGSizeMake(self.imageView.frame.size.width*1.4, self.imageView.frame.size.height*1.4) completion:^(UIImage *image, NSDictionary *info) {
            
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.imageView.image = image;
        }];
    }
}

@end
