//
//  ZoomPhoto.h
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

// Notifications
#define MWPHOTO_LOADING_DID_END_NOTIFICATION @"MWPHOTO_LOADING_DID_END_NOTIFICATION"
#define MWPHOTO_PROGRESS_NOTIFICATION @"MWPHOTO_PROGRESS_NOTIFICATION"
#define MWPHOTO_FAIl_NOTIFICATION @"MWPHOTO_FAIl_NOTIFICATION"

@interface YAHMutiZoomPhoto : NSObject

@property (nonatomic, assign) NSInteger state; //0:image  1:video

//图片
@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, copy, readonly) NSURL *photoUrl;

//视频
@property (nonatomic, copy, readonly) NSURL *videoUrl;

+ (YAHMutiZoomPhoto *)photoWithImage:(UIImage *)image;
+ (YAHMutiZoomPhoto *)photoWithPhotoUrl:(NSURL *)url;
+ (YAHMutiZoomPhoto *)photoWithPhotoAsset:(PHAsset *)asset;
+ (YAHMutiZoomPhoto *)photoWithVideoUrl:(NSURL *)url;

- (id)initWithImage:(UIImage *)image;
- (id)initWithPhotoURL:(NSURL *)url;
- (id)initWithPhotoAsset:(PHAsset *)asset;
- (id)initWithVideoURL:(NSURL *)url;

- (void)downLoadDisplayImage;

@end
