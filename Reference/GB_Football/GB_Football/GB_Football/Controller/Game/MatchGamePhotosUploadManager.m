//
//  MatchGamePhotosUploadManager.m
//  GB_Football
//
//  Created by yahua on 2017/12/29.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MatchGamePhotosUploadManager.h"
#import "YAHPhotoTools.h"
#import "MatchRequest.h"

@interface MatchGamePhotoUploadObject ()



@end

@implementation MatchGamePhotoUploadObject

- (void)getUploadDataWithBlock:(void(^)(NSData *data))block {
    
    if (self.type == 0) {
        if (self.largeImage) {
            NSData *data = UIImageJPEGRepresentation(self.largeImage, 0.5);
            BLOCK_EXEC(block, data);
        }else {
            @weakify(self)
            [YAHPhotoTools getHighQualityFormatPhoto:self.photoAsset size:CGSizeMake(self.photoAsset.pixelWidth, self.photoAsset.pixelHeight) startRequestIcloud:nil progressHandler:nil completion:^(UIImage *image) {
                
                NSData *data = UIImageJPEGRepresentation(image, 0.5);
                BLOCK_EXEC(block, data);
                
            } failed:^(NSDictionary *info) { //获取高清图片失败， 上传缩略图
                GBLog(@"获取高清图片失败，%@", info);
                @strongify(self)
                NSData *data = UIImageJPEGRepresentation(self.thumImage, 0.5);
                BLOCK_EXEC(block, data);
            }];
        }
    }else {
        NSData *data = [[NSData alloc]initWithContentsOfURL:self.videoUrl];
        BLOCK_EXEC(block, data);
    }
}

@end

@interface MatchGamePhotosUploadManager ()

@property (nonatomic, strong) NSMutableArray<MatchGamePhotoUploadObject *> *uploadList;

@end

@implementation MatchGamePhotosUploadManager

- (instancetype)initWithUploadObjectList:(NSArray<MatchGamePhotoUploadObject *> *)list;
{
    self = [super init];
    if (self) {
        _uploadList = [NSMutableArray arrayWithArray:list];
    }
    return self;
}

- (void)addPhotoUploadObjectList:(NSArray<MatchGamePhotoUploadObject *> *)list {
    
    [_uploadList addObjectsFromArray:list];
}

- (void)startUploadWithBlock:(void(^)(MatchGamePhotoUploadObject *uploadObject, BOOL isSucess, NSString *successUri))block {
    
    MatchGamePhotoUploadObject *object = self.uploadList.firstObject;
    if (!object) {
        return;
    }
    [object getUploadDataWithBlock:^(NSData *data) {
        
        if (object.type == 0) {
            [MatchRequest uploadMatchPhoto:data handler:^(id result, NSError *error) {
                if (!error) {
                    BLOCK_EXEC(block, object, YES, result);
                }else {
                    BLOCK_EXEC(block, object, NO, nil);
                }
                [self.uploadList removeObjectAtIndex:0];
                [self startUploadWithBlock:block];
            }];
        }else {
            [MatchRequest uploadMatchVideo:data handler:^(id result, NSError *error) {
                if (!error) {
                    BLOCK_EXEC(block, object, YES, result);
                }else {
                    BLOCK_EXEC(block, object, NO, nil);
                }
                [self.uploadList removeObjectAtIndex:0];
                [self startUploadWithBlock:block];
            }];
        }
    }];
}

@end
