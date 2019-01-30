//
//  YAHPhotoTools.h
//  ImagePickerDemo
//
//  Created by yahua on 2017/12/7.
//  Copyright © 2017年 wangsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface YAHPhotoTools : NSObject

/**
 相册名称转换
 */
+ (NSString *)transFormPhotoTitle:(NSString *)englishName;

/**
 根据PHAsset对象获取照片信息   此方法会回调多次
 */
+ (PHImageRequestID)getPhotoForPHAsset:(PHAsset *)asset size:(CGSize)size completion:(void(^)(UIImage *image,NSDictionary *info))completion;

/**
 根据PHAsset对象获取照片信息   此方法会回调1次
 */
+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset size:(CGSize)size startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(UIImage *image))completion failed:(void(^)(NSDictionary *info))failed;

/**
 根据PHAsset对象获取视频信息   
 */
+ (PHImageRequestID)getAVAssetWithPHAsset:(PHAsset *)asset progressHandler:(void (^)(PHAsset *asset, double progress))progressHandler completion:(void(^)(PHAsset *asset, AVAsset *avasset))completion failed:(void(^)(PHAsset *asset, NSDictionary *info))failed;

/**
 获取传入时间节点的帧图片（可控制是否为关键帧）
 */
+(UIImage *)getCoverImage:(NSURL *)outMovieURL atTime:(CGFloat)time isKeyImage:(BOOL)isKeyImage;

//压缩视频
+ (AVAssetExportSession *)compressedVideoWithMediumQualityWriteToTemp:(id)obj progress:(void (^)(float progress))progress success:(void (^)(NSURL *url))success failure:(void (^)())failure;

@end
