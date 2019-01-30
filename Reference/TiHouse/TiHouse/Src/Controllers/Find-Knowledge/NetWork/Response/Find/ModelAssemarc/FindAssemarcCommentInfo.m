//
//  FindAssemarcCommentInfo.m
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindAssemarcCommentInfo.h"

@implementation FindAssemarcCommentInfo

- (NSString *)assemarccommname {
    return _assemarccommname ? [_assemarccommname URLDecoding] : @"";
}

- (NSString *)assemarccommnameon {
    return _assemarccommnameon ? [_assemarccommnameon URLDecoding] : @"";
}

@end
