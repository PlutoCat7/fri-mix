//
//  FindPhotoPostStore.m
//  TiHouse
//
//  Created by yahua on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoPostStore.h"
#import "TiHouseNetAPIClient.h"
#import "AssemarcRequest.h"
#import "FindPostTool.h"
#import "YAHJSONAdapter.h"
#import "MJExtension.h"
#import "UIImage+Resize.h"

@interface FindPhotoFileUploadStream : YAHActiveObject
@property (nonatomic, copy) NSString *assemarcfileurl;
@property (nonatomic, strong) NSArray *assemarcfiletagJA;
@end
@implementation FindPhotoFileUploadStream
@end

@interface FindPhotoPostStore ()

@property (nonatomic, assign) NSInteger uploadIndex;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

@end

@implementation FindPhotoPostStore


- (instancetype)initWithWithPhotoModelList:(NSMutableArray<FindPhotoHandleModel *> *)list {
    
    self = [super init];
    if (self) {
        _photoModelList = list;
    }
    return self;
}

#pragma mark - Public

- (void)startUploadPhotoWithBlock:(void(^)(BOOL isSucess, BOOL finish))block {
    
    if (self.photoModelList.count == 0) {
        block(YES, YES);
        return;
    }
    _uploadIndex=0;
    [self uploadPhotoWithBlock:block];
}

- (void)postPhotoWithRichContent:(NSString *)content title:(NSString *)title activityId:(long)activityId completeBlock:(void(^)(BOOL isPost))completeBlock {
    
    long assemid = activityId;
    NSMutableArray *fileJAList = [NSMutableArray array];
    for (FindPhotoHandleModel *photoModel in _photoModelList) {
        FindPhotoFileUploadStream *stream = [FindPhotoFileUploadStream new];
        stream.assemarcfileurl = photoModel.photoUploadUrl;
        stream.assemarcfiletagJA = photoModel.labelModelList?photoModel.labelModelList:[NSArray array];
        [fileJAList addObject:[YAHJSONAdapter jsonStringFromObject:stream]];
    }
    NSString *jsonTag = [self objArrayToJSON:fileJAList];
    jsonTag = [jsonTag stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; //https://segmentfault.com/q/1010000000576646

    [AssemarcRequest postPhotosWithAssemid:assemid assemarctitle:content assemarcfileJAstr:jsonTag handler:^(id result, NSError *error) {
        
        if (error != nil) {
            completeBlock(NO);
        }else {
            completeBlock(YES);
        }
    }];
}

//把多个json字符串转为一个json字符串
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

#pragma mark - Private

- (void)uploadPhotoWithBlock:(void(^)(BOOL isSucess, BOOL finish))block {
    
    if (_uploadIndex>=self.photoModelList.count) {
        return;
    }
    FindPhotoHandleModel *object = self.photoModelList[_uploadIndex];
    @weakify(self)
    [object getUploadImageWithBlock:^(UIImage *image) {
        @strongify(self)
        if (self.uploadIndex==0) {
            self.imageHeight = image.size.height;
            self.imageWidth = image.size.width;
        }
        NSData *imageData = UIImageCompress(image);
        [[TiHouse_NetAPIManager sharedManager] request_uploadFilesWithData:imageData completedUsing:^(NSString *data, NSError *error) {
            if (!error)
            {
                object.photoUploadUrl = data.length > 0 ? [NSString stringWithFormat:@"/%@",data]:@"";
                block(YES, (self.uploadIndex==self.photoModelList.count-1));
                self.uploadIndex++;
                [self uploadPhotoWithBlock:block];
                
            }else {
                block(NO, NO);
            }
        }];
    }];
}

@end
