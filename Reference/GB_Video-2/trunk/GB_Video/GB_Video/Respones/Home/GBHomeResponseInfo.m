//
//  GBHomeResponseInfo.m
//  GB_Video
//
//  Created by gxd on 2018/2/5.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBHomeResponseInfo.h"

@implementation BannerInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"bannerId":@"id"};
}

@end

@implementation TopicInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"topicId":@"id"};
}

@end

@implementation HomeHeaderInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"banner_list":[BannerInfo class],
             @"topic_list":[TopicInfo class]
             };
}

@end

@implementation GBHomeResponseInfo

@end
