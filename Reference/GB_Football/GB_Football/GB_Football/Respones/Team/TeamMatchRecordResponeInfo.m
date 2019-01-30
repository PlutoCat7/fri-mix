//
//  TeamMatchRecordResponeInfo.m
//  GB_Football
//
//  Created by gxd on 17/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamMatchRecordResponeInfo.h"

@implementation TeamMatchInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    return @{@"matchId":@"id",
             @"homeScore":@"home_score",
             @"guestScore":@"guest_score",
             @"matchName":@"match_name",
             @"matchDate":@"match_date",
             @"tracticsType":@"form_id",
             @"matchInterval":@"time_count",
             @"homeTeam":@"host_team",
             @"guestTeam":@"follow_team",
             @"courtName":@"court_name",
             @"cityName":@"city_name"};
}

@end

@implementation TeamMatchRecordResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"TeamMatchInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
