//
//  MatchBindResponseInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchBindResponseInfo.h"

@implementation PendingMatchHeadInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"matchId":@"match_id",
             @"matchName":@"match_name",
             @"courtName":@"court_name",
             @"createTime":@"create_time"};
}

@end

@implementation PendingMatchPlayerListInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"playerId":@"player_id",
             @"orderId":@"order_id",
             @"playerName":@"player_name",
             @"orderName":@"order_name"};
}

@end

@implementation PendingMatchInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"matchHeadInfo":@"match_head",
             @"matchPlayerList":@"match_player_list"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"matchPlayerList":@"PendingMatchPlayerListInfo"};
}

@end


@implementation MatchBindResponseInfo

@end
