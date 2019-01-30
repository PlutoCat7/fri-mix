//
//  YAHPhotoTools.m
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/7.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import "YAHPhotoTools.h"

@implementation YAHPhotoTools

+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    return [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        
        if (downloadFinined && completion && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result,info);
            });
        }
    }];
}

+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset size:(CGSize)size startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(UIImage *image))completion failed:(void(^)(NSDictionary *info))failed {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = NO;
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(result);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                option.networkAccessAllowed = YES;
                option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(result);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
    return requestID;
}

/**
 相册名称转换
 */
+ (NSString *)transFormPhotoTitle:(NSString *)englishName {
    NSString *photoName = englishName;
//    if ([englishName isEqualToString:@"Bursts"]) {
//        photoName = @"连拍快照";
//    }else if([englishName isEqualToString:@"Recently Added"]){
//        photoName = @"最近添加";
//    }else if([englishName isEqualToString:@"Screenshots"]){
//        photoName = @"屏幕快照";
//    }else if([englishName isEqualToString:@"Camera Roll"]){
//        photoName = @"相机胶卷";
//    }else if([englishName isEqualToString:@"Selfies"]){
//        photoName = @"自拍";
//    }else if([englishName isEqualToString:@"My Photo Stream"]){
//        photoName = @"我的照片流";
//    }else if([englishName isEqualToString:@"Videos"]){
//        photoName = @"视频";
//    }else if([englishName isEqualToString:@"All Photos"]){
//        photoName = @"所有照片";
//    }else if([englishName isEqualToString:@"Slo-mo"]){
//        photoName = @"慢动作";
//    }else if([englishName isEqualToString:@"Recently Deleted"]){
//        photoName = @"最近删除";
//    }else if([englishName isEqualToString:@"Favorites"]){
//        photoName = @"个人收藏";
//    }else if([englishName isEqualToString:@"Panoramas"]){
//        photoName = @"全景照片";
//    }else {
//        photoName = englishName;
//    }
    return photoName;
}

+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)paAsset progressHandler:(void (^)(PHAsset *asset, double progress))progressHandler completion:(void(^)(PHAsset *asset, AVAsset *avasset))completion failed:(void(^)(PHAsset *asset, NSDictionary *info))failed {
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
    options.networkAccessAllowed = NO;
    PHImageRequestID requestId = 0;
    requestId = [[PHImageManager defaultManager] requestAVAssetForVideo:paAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(paAsset,asset);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]) {
                PHImageRequestID cloudRequestId = 0;
                PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
                cloudOptions.networkAccessAllowed = YES;
                cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(paAsset,progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestAVAssetForVideo:paAsset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(paAsset,asset);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                                //model.iCloudDownloading = NO;
                            }
                            if (failed) {
                                failed(paAsset,info);
                            }
                        });
                    }
                }];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    model.iCloudRequestID = cloudRequestId;
//                    if (startRequestIcloud) {
//                        startRequestIcloud(model,cloudRequestId);
//                    }
//                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![[info objectForKey:PHImageCancelledKey] boolValue]) {
                        //model.iCloudDownloading = NO;
                    }
                    if (failed) {
                        failed(paAsset,info);
                    }
                });
            }
        }
    }];
    return requestId;
}

+(UIImage *)getCoverImage:(NSURL *)outMovieURL atTime:(CGFloat)time isKeyImage:(BOOL)isKeyImage{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outMovieURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    __block CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    
    //  通常开发者认为时间的呈现格式应该是浮点数据，我们一般使用NSTimeInterval，实际上它是简单的双精度double类型，只是typedef了一下，但是由于浮点型数据计算很容易导致精度的丢失，在一些要求高精度的应用场景显然不适合，于是苹果在Core Media框架中定义了CMTime数据类型作为时间的格式,
    //  typedef struct{
    //
    //  CMTimeValue    value;
    //  CMTimeScale    timescale;
    //  CMTimeFlags    flags;
    //  CMTimeEpoch    epoch;
    //  } CMTime;
    //  显然，CMTime定义是一个C语言的结构体，CMTime是以分数的形式表示时间，value表示分子，timescale表示分母，flags是位掩码，表示时间的指定状态。CMTimeMake(3, 1)结果为3。
    
    
    //tips:下面7行代码控制取图的时间点是否为关键帧，系统为了性能是默认取关键帧图片的
    CMTime myTime = CMTimeMake(time, 1);
    if (!isKeyImage) {
        assetImageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        assetImageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        CMTime duration = asset.duration;
        myTime = CMTimeMake(time*30,30);
    }
    
    NSError *error;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:myTime actualTime:NULL error:&error];
    
    if (!thumbnailImageRef){
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    //    return [UIImage imageNamed:@"icomImg"];
    return thumbnailImage;
    
}

+ (AVAssetExportSession *)compressedVideoWithMediumQualityWriteToTemp:(id)obj progress:(void (^)(float progress))progress success:(void (^)(NSURL *url))success failure:(void (^)(void))failure {
    AVAsset *avAsset;
    if ([obj isKindOfClass:[AVAsset class]]) {
        avAsset = obj;
    }else {
        avAsset = [AVURLAsset URLAssetWithURL:obj options:nil];
    }
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSString *fileName = [[self uploadFileName] stringByAppendingString:@".mp4"];
        NSString *fullPathToFile = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSURL *videoURL = [NSURL fileURLWithPath:fullPathToFile];
        exportSession.outputURL = videoURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                if (success) {
                    success(videoURL);
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusFailed){
                if (failure) {
                    failure();
                }
            }else if ([exportSession status] == AVAssetExportSessionStatusCancelled) {
                if (failure) {
                    failure();
                }
            }
        }];
        return exportSession;
    }else {
        if (failure) {
            failure();
        }
        return nil;
    }
}

#pragma mark - Private

+ (NSString *)uploadFileName {
    NSString *fileName = @"";
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
    
    NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
    
    fileName = [fileName stringByAppendingString:@"hx"];
    fileName = [fileName stringByAppendingString:dateStr];
    fileName = [fileName stringByAppendingString:numStr];
    return fileName;
}


@end
