//
//  TeamResponseInfo.m
//  GB_Football
//
//  Created by gxd on 17/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamResponseInfo.h"

@implementation TeamInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    return @{@"teamId":@"team_id",
             @"teamName":@"team_name",
             @"teamIcon":@"team_icon",
             @"foundTime":@"create_team_time",
             @"provinceId":@"province_id",
             @"cityId":@"city_id",
             @"teamInstr":@"team_mess",
             @"leaderId":@"leader_id"};
}

- (BOOL)isMineTeam {
    
    return _leaderId==[RawCacheManager sharedRawCacheManager].userInfo.userId;
}

@end

@implementation TeamResponseInfo

@end
