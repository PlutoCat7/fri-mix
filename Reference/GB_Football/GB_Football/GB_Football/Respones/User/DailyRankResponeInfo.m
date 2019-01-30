//
//  DailyRankResponeInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "DailyRankResponeInfo.h"

@implementation DailyRankInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"nickName":@"nick_name",
             @"photoImageUrl":@"image_url",
             @"teamName":@"team_name",
             @"teamNo":@"team_no",
             @"userId":@"user_id",
             @"stepNumber":@"step_number"};
}

@end

@implementation DailyRankResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"DailyRankInfo"};
}


@end
