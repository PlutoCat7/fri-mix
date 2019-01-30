//
//  VideoCommentListRequest.m
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "VideoCommentListRequest.h"

@implementation VideoCommentListRequest

- (Class)responseClass {
    
    return [VideoCommentListResponse class];
}

- (NSString *)requestAction {
    
    return @"video/getCommentList";
}

- (NSDictionary *)parameters {
    
    return @{@"video_id":@(self.videoId)};
}

@end
