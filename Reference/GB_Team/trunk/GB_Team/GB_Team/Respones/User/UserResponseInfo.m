//
//  UserResponseInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UserResponseInfo.h"

@implementation UserInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"userId":@"id",
             @"sid":@"token",
             @"matchId":@"match_id"};
}

@end

@implementation UserResponseInfo

@end
