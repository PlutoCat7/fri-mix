//
//  VideoCommentListResponse.m
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "VideoCommentListResponse.h"


@implementation VideoCommentInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"commentId":@"id"};
}

@end

@implementation VideoCommentListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[VideoCommentInfo class]};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
