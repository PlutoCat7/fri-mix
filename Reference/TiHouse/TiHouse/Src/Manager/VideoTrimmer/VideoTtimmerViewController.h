//
//  VideoTtimmerViewController.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/19.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "BaseViewController.h"
#import "HXPhotoPicker.h"
@class VideoTtimmerViewController;
@protocol VideoTtimmerViewControllerDelegate <NSObject>

- (void)videoViewController:(VideoTtimmerViewController *)videoViewController didCropToURL:(NSURL *)url videoTime:(NSTimeInterval)videoTime assest:(PHAsset *)assest;

@end

@interface VideoTtimmerViewController : BaseViewController

+ (instancetype)sharedInstance;
- (void)destorySharedInstance;
@property (nonatomic, retain) HXPhotoModel *model;
@property (nonatomic, weak) id<VideoTtimmerViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL againEdit;

@end

