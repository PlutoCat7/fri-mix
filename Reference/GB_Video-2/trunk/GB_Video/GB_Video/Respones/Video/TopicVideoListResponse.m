//
//  TopicVideoListResponse.m
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "TopicVideoListResponse.h"

@implementation TopicVideoListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[VideoDetailInfo class]};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
