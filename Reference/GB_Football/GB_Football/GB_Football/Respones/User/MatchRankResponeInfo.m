//
//  MatchRankResponeInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchRankResponeInfo.h"

@implementation MatchRankInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"nickName":@"nick_name",
             @"photoImageUrl":@"image_url",
             @"teamName":@"team_name",
             @"teamNo":@"team_no",
             @"userId":@"user_id",
             @"matchId":@"match_id",
             @"distance":@"move_distance",
             @"avgSpeed":@"avg_speed",
             @"maxSpeed":@"max_speed"};
}

@end

@implementation MatchRankResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"MatchRankInfo"};
}

@end
