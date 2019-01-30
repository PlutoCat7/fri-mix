//
//  SearchPageRequest.m
//  GB_Video
//
//  Created by gxd on 2018/2/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "SearchPageRequest.h"

@implementation SearchPageRequest

- (Class)responseClass {
    return [TopicVideoListResponse class];
}

- (NSString *)requestAction {
    
    return @"video/getSearchList";
}

- (NSDictionary *)parameters {
    return @{@"keyword":self.keyword};
}

@end
