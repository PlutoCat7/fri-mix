//
//  HistoryRankResponeInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "HistoryRankResponeInfo.h"

@implementation HistoryRankInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"nickName":@"nick_name",
             @"photoImageUrl":@"image_url",
             @"pc":@"single_max_pc",
             @"teamName":@"team_name",
             @"teamNo":@"team_no",
             @"userId":@"user_id",
             @"distance":@"single_max_move_distance",
             @"avgSpeed":@"single_max_avg_speed",
             @"maxSpeed":@"single_max_high_speed"};
}

@end

@implementation HistoryRankResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"HistoryRankInfo"};
}

@end
