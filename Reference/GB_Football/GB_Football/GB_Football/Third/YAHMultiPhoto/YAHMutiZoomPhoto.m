//
//  ZoomPhoto.m
//  YHMultiPhotoViewController
//
//  Created by wangshiwen on 15/9/14.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHMutiZoomPhoto.h"
#import "SDWebImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YAHPhotoTools.h"

@interface YAHMutiZoomPhoto ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSURL *photoUrl;
@property (nonatomic, strong) PHAsset *photoAsset;
@property (nonatomic, copy) NSURL *videoUrl;

@property (nonatomic, strong) SDWebImageDownloadToken *webImageOperation;

@property (nonatomic, assign) BOOL loading;

@end

@implementation YAHMutiZoomPhoto

+ (YAHMutiZoomPhoto *)photoWithImage:(UIImage *)image {
    
    return [[YAHMutiZoomPhoto alloc] initWithImage:image];
}

+ (YAHMutiZoomPhoto *)photoWithPhotoUrl:(NSURL *)url {
    
    return [[YAHMutiZoomPhoto alloc] initWithPhotoURL:url];
}

+ (YAHMutiZoomPhoto *)photoWithPhotoAsset:(PHAsset *)asset {
    
    return [[YAHMutiZoomPhoto alloc] initWithPhotoAsset:asset];
}

+ (YAHMutiZoomPhoto *)photoWithVideoUrl:(NSURL *)url {
    
    return [[YAHMutiZoomPhoto alloc] initWithVideoURL:url];
}

- (void)dealloc
{
    [self cancelAnyLoading];
}

- (id)initWithImage:(UIImage *)image {
    
    if ((self = [super init])) {
        _image = image;
    }
    return self;
}

- (id)initWithPhotoURL:(NSURL *)url {
    
    if ((self = [super init])) {
        _photoUrl = [url copy];
    }
    return self;
}

- (id)initWithPhotoAsset:(PHAsset *)asset {
    
    if ((self = [super init])) {
        _photoAsset = asset;
    }
    return self;
}

- (id)initWithVideoURL:(NSURL *)url {
    
    if ((self = [super init])) {
        _videoUrl = [url copy];
    }
    return self;
}

#pragma mark - Public

- (UIImage *)displayImage {
    
    return _displayImage;
}

- (void)downLoadDisplayImage {
    
    if (_loading) {
        return;
    }
    if (self.displayImage) {
        [self imageLoadingComplete];
    }else {
        if (_image) {
            self.displayImage = _image;
            [self imageLoadingComplete];
        }else {
            if (_photoAsset) {
                
                _loading = YES;
                [YAHPhotoTools getHighQualityFormatPhoto:self.photoAsset size:CGSizeMake(self.photoAsset.pixelWidth, self.photoAsset.pixelHeight) startRequestIcloud:nil progressHandler:^(double progress) {
                    
                    NSDictionary* dict = @{@"progress":[NSNumber numberWithFloat:progress],
                                           @"photo":self};
                    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_PROGRESS_NOTIFICATION object:dict];
                } completion:^(UIImage *image) {
                    
                    self.displayImage = image;
                    [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                    
                } failed:^(NSDictionary *info) {
                    self.displayImage = nil;
                    //MWLog(@"Photo from asset library error: %@",error);
                    [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                }];
                return;
            }
            if (!_photoUrl) {
                
                // Failed - no source
                [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_FAIl_NOTIFICATION object:nil];
                return;
            }
            _loading = YES;
            
            if ([[[_photoUrl scheme] lowercaseString] isEqualToString:@"assets-library"]) {
                
                // Load from asset library async
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @autoreleasepool {
                        @try {
                            ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                            [assetslibrary assetForURL:_photoUrl
                                           resultBlock:^(ALAsset *asset){
                                               ALAssetRepresentation *rep = [asset defaultRepresentation];
                                               CGImageRef iref = [rep fullScreenImage];
                                               if (iref) {
                                                   self.displayImage = [UIImage imageWithCGImage:iref];
                                               }
                                               [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                                           }
                                          failureBlock:^(NSError *error) {
                                              self.displayImage = nil;
                                              //MWLog(@"Photo from asset library error: %@",error);
                                              [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                                          }];
                        } @catch (NSException *e) {
                            //MWLog(@"Photo from asset library error: %@", e);
                            [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                        }
                    }
                });
                
            } else if ([_photoUrl isFileReferenceURL]) {
                
                // Load from local file async
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @autoreleasepool {
                        @try {
                            self.displayImage = [UIImage imageWithContentsOfFile:_photoUrl.path];
                        } @finally {
                            [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                        }
                    }
                });
                
            } else {
                
                // Load async from web (using SDWebImage)
                @try {
                    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
                    _webImageOperation = [manager downloadImageWithURL:_photoUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                        if (expectedSize > 0) {
                            float progress = receivedSize / (float)expectedSize;
                            NSDictionary* dict = @{@"progress":[NSNumber numberWithFloat:progress],
                                                   @"photo":self};
                            [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_PROGRESS_NOTIFICATION object:dict];
                        }
                    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        if (error) {
                            NSLog(@"SDWebImage failed to download image: %@", error);
                        }
                        _webImageOperation = nil;
                        self.displayImage = image;
                        [self imageLoadingComplete];
                    }];
                } @catch (NSException *e) {
                    //MWLog(@"Photo from web: %@", e);
                    _webImageOperation = nil;
                    [self imageLoadingComplete];
                }
                
            }
        }
    }
}

#pragma mark - Private

- (void)imageLoadingComplete {
    
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loading = NO;
    // Notify on next run loop
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

- (void)cancelAnyLoading {
    if (_webImageOperation) {
        [[SDWebImageDownloader sharedDownloader] cancel:_webImageOperation];
        _loading = NO;
    }
}

@end
