//
//  YAHAssetCollectionCell.h
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/8.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YAHPhotoModel.h"
#import "YAHImagePickerDefines.h"

#define kThumbnailNumber  (KOrientationMaskPortrait?3:6)
#define kThumbnailLength  ((SCREEN_WIDTH-2*(kThumbnailNumber-1))/kThumbnailNumber)

@interface YAHAssetCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)bind:(YAHPhotoModel *)asset;

@end
