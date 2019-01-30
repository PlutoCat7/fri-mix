//
//  MultiImageUploadManager.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "MultiImageUploadManager.h"

@interface MultiImageUploadManager()

@property (nonatomic, strong) NSMutableArray *uploadQueue; //准备队列
@property (nonatomic, strong) NSMutableArray *runningUploadQueue; //正在上传队列
@property (nonatomic, strong) NSMutableArray *responseInfoQueue; //响应的信息队列
@property (nonatomic) NSInteger uploadCount; //需要上传的文件个数
@property (nonatomic) long long totalBytes; //文件总大小
@property (nonatomic, copy) UploadSuccessBlock uploadFinishedBlock;
@property (nonatomic, copy) UploadFailureBlock uploadFailureBlock;
@property (nonatomic, copy) UploadProgressBlock uploadProgressBlock;
@property (nonatomic, strong) NSString *uploadPath;

@end

@implementation MultiImageUploadManager

- (void)uploadImages:(NSArray *)files
                path:(NSString *)path
        successBlock:(UploadSuccessBlock)success
        failureBlock:(UploadFailureBlock)failure
       progerssBlock:(UploadProgressBlock)progress {
    self.uploadProgressBlock = progress;
    self.uploadFinishedBlock = success;
    self.uploadFailureBlock = failure;
    self.uploadCount = files.count;
    self.uploadPath = path;
    for (UIImage *img in files) {
        NSData *data = UIImagePNGRepresentation(img);
        self.totalBytes += data.length;
        [self addUploadObject:img];
    }
    
}

#pragma mark - upload queue method
- (void)addUploadObject:(UIImage *)uploadObject {
    [self.uploadQueue addObject:uploadObject];
    [self startNextOperation];
}

- (void)startNextOperation {
    if (![self hasOperationInProgress]) {
        if ([self hasOperationready]) {
            UIImage *image = [self.uploadQueue objectAtIndex:0];
            
            WEAKSELF
            // upload
            [[TiHouseNetAPIClient sharedJsonClient] uploadImage:image path:self.uploadPath name:@"tallyDetailImage" successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
                [weakSelf.responseInfoQueue addObject:responseObject];
                [weakSelf.runningUploadQueue removeAllObjects];
                [weakSelf startNextOperation];
                NSLog(@"上传成功");
                if (--weakSelf.uploadCount == 0) {
                    if (self.uploadFinishedBlock) {
                        NSLog(@"全部上传成功");
                        self.uploadFinishedBlock(weakSelf.responseInfoQueue);
                    }
                }
            } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
                [weakSelf.runningUploadQueue removeAllObjects];
                [weakSelf startNextOperation];
                NSLog(@"上传失败 ");
                if (--weakSelf.uploadCount || --weakSelf.uploadCount == 0) {
                    weakSelf.uploadCount = -1;
                    if (weakSelf.uploadFailureBlock) {
                        NSLog(@"全部上传失败");
                        weakSelf.uploadFailureBlock(error);
                    }
                }
            } progerssBlock:^(CGFloat progressValue) {
                if (weakSelf.uploadProgressBlock) {
                    weakSelf.uploadProgressBlock(progressValue);
                }
            }];
            
            
            [self.uploadQueue removeObjectAtIndex:0];
            [self.runningUploadQueue addObject:image];
        }
    }
}

- (BOOL)hasOperationInProgress {
    return self.runningUploadQueue.count > 0;
}

- (BOOL)hasOperationready {
    return self.uploadQueue.count > 0;
}

#pragma mark - getter/setter
- (NSMutableArray *)uploadQueue {
    if (!_uploadQueue) {
        _uploadQueue = [NSMutableArray array];
    }
    return _uploadQueue;
}

- (NSMutableArray *)runningUploadQueue {
    if (!_runningUploadQueue) {
        _runningUploadQueue = [NSMutableArray array];
    }
    return _runningUploadQueue;
}

- (NSMutableArray *)responseInfoQueue {
    if (!_responseInfoQueue) {
        _responseInfoQueue = [NSMutableArray array];
    }
    return _responseInfoQueue;
}

@end
