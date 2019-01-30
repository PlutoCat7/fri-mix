//
//  MatchInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchInfo.h"

@implementation MatchConfigInfo

- (NSArray<NSString *> *)imgUrlList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    if (![NSString stringIsNullOrEmpty:self.img_uri_1]) {
        [result addObject:self.img_uri_1];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_2]) {
        [result addObject:self.img_uri_2];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_3]) {
        [result addObject:self.img_uri_3];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_4]) {
        [result addObject:self.img_uri_4];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_5]) {
        [result addObject:self.img_uri_5];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_6]) {
        [result addObject:self.img_uri_6];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_7]) {
        [result addObject:self.img_uri_7];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_8]) {
        [result addObject:self.img_uri_8];
    }
    if (![NSString stringIsNullOrEmpty:self.img_uri_9]) {
        [result addObject:self.img_uri_9];
    }
    return [result copy];
}

- (NSArray<NSString *> *)videoUrlList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    if (![NSString stringIsNullOrEmpty:self.video_url]) {
        [result addObject:self.video_url];
    }
    return [result copy];
}

@end

@implementation MatchSectonInfo

@end

@implementation MatchHeatMapInfo

@end

@implementation MatchAchieveInfo

@end

@implementation MatchReportInfo

@end

@implementation MatchRectInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"maxPointA":@"point_a",
             @"maxPointB":@"point_b",
             @"maxPointC":@"point_c",
             @"maxPointD":@"point_d",
             @"maxWidth":@"width",
             @"maxHeight":@"height",
             @"maxAngle":@"angle"};
}

@end

@implementation SpeedDataInfo


@end

@implementation MatchDataInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"moveDistance":@"move_distance",
             @"avgSpeed":@"avg_speed",
             @"maxSpeed":@"max_speed",
             @"sprintTime":@"sprint_time",
             @"sprintDistance":@"sprint_distance",
             @"consume":@"pc"};
}

@end

@implementation MatchUserInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"nickName":@"nick_name",
             @"teamName":@"team_name",
             @"teamNo":@"team_no",
             @"imageUrl":@"image_url"};
}

@end

@implementation MatchInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"matchId":@"match_id",
             @"courtId":@"court_id",
             @"courtName":@"court_name",
             @"creatorId":@"creator_id",
             @"creatorName":@"creator_name",
             @"matchName":@"match_name",
             @"matchTime":@"match_time",
             @"createMatchDate":@"match_date",
             @"firstStartTime":@"match_time_a",
             @"firstEndTime":@"match_time_b",
             @"secondStartTime":@"match_time_c",
             @"secondEndTime":@"match_time_d",
             @"homeScore":@"home_score",
             @"guestScore":@"guest_score",
             @"location":@"court_location",
             @"locA":@"court_a",
             @"locB":@"court_b",
             @"locC":@"court_c",
             @"locD":@"court_d",
             @"pointA":@"point_a",
             @"pointB":@"point_b",
             @"pointC":@"point_c",
             @"pointD":@"point_d",
             @"globalData":@"global_data",
             @"firstHalfData":@"first_data",
             @"secondHalfData":@"second_data",
             @"walkSpeed":@"walk",
             @"runSpeed":@"run",
             @"sprintSpeed":@"sprint",
             @"rectInfo":@"point_rect",
             @"gameType":@"type",
             @"inviteUserCount":@"rel_num",
             @"tracticsType":@"form_type",
             @"tracticsPlayers":@"form_info",
             @"matchUserInfo":@"user_info",
             @"matchConfig":@"img_urls"
             };
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"split":@"MatchSectonInfo",
             @"inviteFriendList":@"FriendInfo",
             @"tracticsPlayers":[TeamLineUpInfo class],
             @"matchUserInfo":@"MatchUserInfo"};
}

- (BOOL)shouldShowAchieveView {
    
    if (!self.achieve) {
        return NO;
    }
    if (self.achieve.status ==1) {
        return NO;
    }
    if (self.achieve.display_type ==0) {
        return NO;
    }
    
    return YES;
}

- (long)firstStartTime {
    
    if (self.match_data_time_a>0) {
        return self.match_data_time_a;
    }
    return _firstStartTime;
}

- (long)firstEndTime {
    
    if (self.match_data_time_b>0) {
        return self.match_data_time_b;
    }
    return _firstEndTime;
}

- (long)secondStartTime {
    
    if (self.match_data_time_c>0) {
        return self.match_data_time_c;
    }
    return _secondStartTime;
}

- (long)secondEndTime {
    
    if (self.match_data_time_d>0) {
        return self.match_data_time_d;
    }
    return _secondEndTime;
}

@end
