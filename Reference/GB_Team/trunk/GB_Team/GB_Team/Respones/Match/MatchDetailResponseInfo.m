//
//  MatchResponseInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchDetailResponseInfo.h"

@implementation MatchHeatMapInfo


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

@implementation MatchPlayerInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"walkSpeed":@"walk",
             @"runSpeed":@"run",
             @"sprintSpeed":@"sprint"};
}

@end

@implementation MatchMessInfo

@end

@implementation MatchDetailInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"playerList":@"player_data_list",
             @"matchMess":@"match_mess"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"playerList":@"MatchPlayerInfo"};
}

@end

@implementation MatchDetailResponseInfo

@end
