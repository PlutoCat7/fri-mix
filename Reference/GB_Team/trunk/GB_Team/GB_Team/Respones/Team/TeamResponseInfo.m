//
//  TeamResponseInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "TeamResponseInfo.h"

@implementation TeamInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"teamId":@"id",
             @"teamName":@"team_name",
             @"cocahId":@"coach_id"};
}

@end


@implementation TeamResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"TeamInfo"};
}

@end
