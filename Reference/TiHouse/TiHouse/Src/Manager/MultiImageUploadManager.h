//
//  MultiImageUploadManager.h
//  TiHouse
//
//  Created by AlienJunX on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^UploadSuccessBlock)(id responseObject);
typedef void (^UploadFailureBlock)(NSError *error);
typedef void (^UploadProgressBlock)(CGFloat progressValue);

@interface MultiImageUploadManager : NSObject

/**
 *  多个图片上传
 *
 *  @param files 数组 UIImage
 */
- (void)uploadImages:(NSArray *)files
                path:(NSString *)path
        successBlock:(UploadSuccessBlock)success
        failureBlock:(UploadFailureBlock)failure
       progerssBlock:(UploadProgressBlock)progress;

@end
