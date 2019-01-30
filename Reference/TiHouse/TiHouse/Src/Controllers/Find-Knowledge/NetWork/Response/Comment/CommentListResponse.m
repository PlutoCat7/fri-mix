//
//  CommentListResponse.m
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommentListResponse.h"

@implementation CommentInfo

- (NSString *)knowcommname {
    return _knowcommname ? [_knowcommname URLDecoding] : @"";
}

- (NSString *)knowcommnameon {
    return _knowcommnameon ? [_knowcommnameon URLDecoding] : @"";
}

@end

@implementation CommentListResponse

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":[CommentInfo class]};
}


- (NSArray *)onePageData {
    
    return self.data;
}

@end
