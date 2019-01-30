//
//  VideoDetailInfo.m
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "VideoDetailInfo.h"

@implementation VideoUserActionInfo
@end

@implementation VideoDetailInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"videoId":@"id",
             @"videoUrl":@"url",
             @"videoName":@"name",
             @"videoFirstFrameUrl":@"cover_url",
             @"playCount":@"count",
             };
}
@end

@implementation VideoDetailResponse

@end
