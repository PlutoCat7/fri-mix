//
//  MatchInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchInfo.h"


@implementation MatchInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"matchTime":@"matchDate",
             @"firstStartTime":@"matchTimeA",
             @"firstEndTime":@"matchTimeB",
             @"secondStartTime":@"matchTimeC",
             @"secondEndTime":@"matchTimeD"};
}

- (NSString *)getCacheKey {
    
    NSString *key = [super getCacheKey];
    key = [NSString stringWithFormat:@"%@_%td", key, [RawCacheManager sharedRawCacheManager].userInfo.userId];
    return key;
}

@end
