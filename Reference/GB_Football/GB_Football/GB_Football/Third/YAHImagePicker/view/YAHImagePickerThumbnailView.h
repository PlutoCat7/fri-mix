//
//  YHImagePickerThumbnailView.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/2.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YAHAlbumModel;
@class YAHPhotoModel;

@interface YAHImagePickerThumbnailView : UIView

/**
 *    相册，用以多图模式或者单图模式，时间轴上取当前时间往前的若干张图片
 */
@property (nonatomic, strong) YAHAlbumModel *assetsGroup;

/**
 *    照片信息，用以单图模式
 */
@property (nonatomic, strong) YAHPhotoModel *asset;

@end
