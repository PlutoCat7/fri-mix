//
//  ResourceRequest.m
//  GB_TransferMarket
//
//  Created by 王时温 on 2016/12/29.
//  Copyright © 2016年 gxd. All rights reserved.
//

#import "ResourceRequest.h"

@implementation ResourceRequest

+ (void)uploadUserPhoto:(UIImage *)image handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"res/uploadImage";
    
    [self POST:urlString parameters:@{@"dir":@"user_img"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"file" mimeType:@"image/png"];
    } progress:nil responseClass:[UserImageUploadResponeInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserImageUploadResponeInfo *info = (UserImageUploadResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
