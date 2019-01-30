//
//  PlayerStarResponeInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PlayerStarResponeInfo.h"

@implementation PlayerStarExtendInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"userId":@"user_id",
             @"avgMove":@"avg_move_distance",
             @"avgHighSpeed":@"avg_high_speed",
             @"avgSpeed":@"avg_speed",
             @"avgMatchMinute":@"avg_match_duration",
             @"avgPC":@"avg_pc",
             @"singleMaxMove":@"single_max_move_distance",
             @"singleMaxHighSpeed":@"single_max_high_speed",
             @"singleMaxAvgSpeed":@"single_max_avg_speed",
             @"singleMaxMatchMinute":@"single_max_match_duration",
             @"singleMaxPC":@"single_max_pc",
             @"matchCount":@"match_count"};
}

@end

@implementation PlayerStarUserInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"nick":@"nick_name",
             @"sexType":@"sex",
             @"teamName":@"team_name",
             @"teamNo":@"team_no",
             @"provinceId":@"province_id",
             @"cityId":@"city_id",
             @"regionId":@"region_id",
             @"imageUrl":@"image_url"};
}


@end

@implementation PlayerStarInfo

+ (PlayerStarInfo *)playerStarInfoWithUserInfo:(UserInfo *)userInfo {
    
    PlayerStarInfo *info = [[PlayerStarInfo alloc] init];
    info.user_data = [[PlayerStarUserInfo alloc] init];
    info.extend_data = [[PlayerStarExtendInfo alloc] init];
    info.isFriend = YES;
    
    info.extend_data.userId = userInfo.userId;
    info.user_data.nick = userInfo.nick;
    info.user_data.sexType = userInfo.sexType;
    info.user_data.phone = userInfo.phone;
    info.user_data.birthday = userInfo.birthday;
    info.user_data.weight = userInfo.weight;
    info.user_data.height = userInfo.height;
    info.user_data.teamName = userInfo.teamName;
    info.user_data.teamNo = userInfo.teamNo;
    info.user_data.position = userInfo.position;
    info.user_data.provinceId = userInfo.provinceId;
    info.user_data.cityId = userInfo.cityId;
    info.user_data.regionId = userInfo.regionId;
    info.user_data.imageUrl = userInfo.imageUrl;
    
    return info;
}

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"isFriend":@"is_friend"};
}

@end

@implementation PlayerStarResponeInfo

@end
