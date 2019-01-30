//
//  HomePageRequest.m
//  GB_Video
//
//  Created by gxd on 2018/2/5.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "HomePageRequest.h"

@implementation HomePageRequest

- (Class)responseClass {
    
    return [TopicVideoListResponse class];
}

- (NSString *)requestAction {
    
    return @"video/getMainList";
}

@end
