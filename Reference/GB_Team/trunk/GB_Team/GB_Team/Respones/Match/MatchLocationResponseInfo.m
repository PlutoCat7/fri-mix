//
//  MatchLocationResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchLocationResponseInfo.h"

@implementation MatchLocationInfo

@end

@implementation MatchLocationDataInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"firstData":@"first_data",
             @"secondData":@"second_data"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"firstData":@"MatchLocationInfo",
             @"secondData":@"MatchLocationInfo"};
}

@end


@implementation MatchLocationResponseInfo

@end
