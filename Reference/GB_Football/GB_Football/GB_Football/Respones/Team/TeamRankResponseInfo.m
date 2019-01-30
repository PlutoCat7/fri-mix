//
//  TeamRankResponseInfo.m
//  GB_Football
//
//  Created by gxd on 17/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamRankResponseInfo.h"

@implementation TeamRankInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"teamId":@"team_id",
             @"teamName":@"team_name",
             @"teamIcon":@"team_icon",
             @"isTeamMatch":@"is_team_match",
             @"provinceId":@"province_id",
             @"cityId":@"city_id"};
}

@end

@implementation TeamRankRespone

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"team_list":@"TeamRankInfo"};
}

@end

@implementation TeamRankResponseInfo

@end
