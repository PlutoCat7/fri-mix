//
//  TopicVideoListRequest.m
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "TopicVideoListRequest.h"

@implementation TopicVideoListRequest

- (Class)responseClass {
    
    return [TopicVideoListResponse class];
}

- (NSString *)requestAction {
    
    return @"topic/getTopicDetail";
}

- (NSDictionary *)parameters {
    
    return @{@"topic_id":@(self.topicId)};
}

@end
