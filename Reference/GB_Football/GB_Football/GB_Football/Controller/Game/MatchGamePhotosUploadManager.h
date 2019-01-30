//
//  MatchGamePhotosUploadManager.h
//  GB_Football
//
//  Created by yahua on 2017/12/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface MatchGamePhotoUploadObject : NSObject

@property (nonatomic, assign) NSInteger type;  //0图片  1视频

@property (nonatomic, strong) UIImage *largeImage;  //高清图片
@property (nonatomic, strong) UIImage *thumImage;
@property (nonatomic, strong) PHAsset *photoAsset;

@property (nonatomic, copy) NSURL *videoUrl;

- (void)getUploadDataWithBlock:(void(^)(NSData *data))block;

@end

@interface MatchGamePhotosUploadManager : NSObject

- (instancetype)initWithUploadObjectList:(NSArray<MatchGamePhotoUploadObject *> *)list;

- (void)addPhotoUploadObjectList:(NSArray<MatchGamePhotoUploadObject *> *)list;

- (void)startUploadWithBlock:(void(^)(MatchGamePhotoUploadObject *uploadObject, BOOL isSucess, NSString *successUri))block;

@end
