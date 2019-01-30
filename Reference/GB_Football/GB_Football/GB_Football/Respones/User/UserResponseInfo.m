//
//  UserResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UserResponseInfo.h"
#import "MatchDoingResponseInfo.h"

@implementation UserMatchInfo

@end

@implementation ConfigInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"stepNumberGoal":@"step_number_goal"};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _match_add_dail = 1;
    }
    return self;
}

@end

@implementation WristbandInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"wristId":@"id",
             @"handEquipName":@"hand_equip_name",
             @"equipName":@"equip_name"};
}

@end

@implementation UserResponseInfo

@end

@implementation UserInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _config = [[ConfigInfo alloc] init];
    }
    return self;
}

- (void)clearMatchInfo {
    
    //clear cache
    MatchDoingInfo *cacheMatchInfo = [MatchDoingInfo loadCache];
    [cacheMatchInfo clearCache];
    
    self.matchInfo = nil;
}

- (BOOL)isCaptainOrViceCaptain {
    return _roleType == TeamPalyerType_Captain || _roleType == TeamPalyerType_ViceCaptain;
}

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"userId":@"id",
             @"nick":@"nick_name",
             @"sexType":@"sex",
             @"cityId":@"city_id",
             @"imageUrl":@"image_url",
             @"provinceId":@"province_id",
             @"regionId":@"region_id",
             @"sid":@"token",
             @"teamName":@"team_name",
             @"teamNo":@"team_no",
             @"wristbandInfo":@"wristband_info",
             @"matchInfo":@"match_invite",
             @"roleType":@"role_id"};
}

- (NSString *)getCacheKey {
    
    NSString *key = [super getCacheKey];
    key = [NSString stringWithFormat:@"%@_%@", key, [RawCacheManager getLastLoginAccount]];
    return key;
}

- (void)setWristbandInfo:(WristbandInfo *)wristbandInfo {
    
    _wristbandInfo = wristbandInfo;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveCache];
    });
}

- (void)setNick:(NSString *)nick {
    
    _nick = nick;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveCache];
    });
}

- (void)setImageUrl:(NSString *)imageUrl {
    
    _imageUrl = imageUrl;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveCache];
    });
}

- (void)setHeight:(NSInteger)height {
    
    _height = height;
}

- (void)setMatchInfo:(UserMatchInfo *)matchInfo {
    
    _matchInfo = matchInfo;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self saveCache];
    });
}

@end
