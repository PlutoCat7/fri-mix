//
//  VideoRequest.m
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "VideoRequest.h"

@implementation VideoRequest

+ (void)praiseVideo:(NSInteger)videoId isPraise:(BOOL)isPraise handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = isPraise?@"video/doAction":@"video/cancelAction";
    NSDictionary *parameters = @{@"videoId":@(videoId),
                                 @"type":@(1)
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {

        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)collectVideo:(NSInteger)videoId isCollect:(BOOL)isCollect handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = isCollect?@"video/doAction":@"video/cancelAction";
    NSDictionary *parameters = @{@"videoId":@(videoId),
                                 @"type":@(2)
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)commentVideo:(NSInteger)videoId content:(NSString *)content handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"video/comment";
    NSDictionary *parameters = @{@"video_id":@(videoId),
                                 @"content":content
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)getVideoInfo:(NSInteger)videoId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"video/getInfo";
    NSDictionary *parameters = @{@"video_id":@(videoId)
                                 };
    [self POST:urlString parameters:parameters responseClass:[VideoDetailResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            VideoDetailResponse *info = (VideoDetailResponse *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)watchVideo:(NSInteger)videoId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"video/count";
    NSDictionary *parameters = @{@"video_id":@(videoId)
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

@end
