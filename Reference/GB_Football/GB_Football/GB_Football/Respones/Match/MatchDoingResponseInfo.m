//
//  MatchDoingResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MatchDoingResponseInfo.h"

@implementation MatchDoingInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"joinedCount":@"num",
             @"creatorId":@"creator_id"};
}

- (NSString *)getCacheKey {
    
    NSString *key = [super getCacheKey];
    key = [NSString stringWithFormat:@"%@_%td", key, [RawCacheManager sharedRawCacheManager].userInfo.userId];
    return key;
}

- (void)loadDefaultLocalData {
    
    MatchDoingInfo *cache = [MatchDoingInfo loadCache];
    self.timeDivisionRecordList = cache.timeDivisionRecordList;
    self.host_team = [RawCacheManager sharedRawCacheManager].userInfo.teamName;
    self.follow_team = @"";
}

@end

@implementation MatchDoingMessInfo


@end

@implementation MatchDoingResponseInfo

@end
