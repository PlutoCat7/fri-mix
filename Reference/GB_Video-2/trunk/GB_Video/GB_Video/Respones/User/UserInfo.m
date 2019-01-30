//
//  UserInfo.m
//  GB_Video
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"userId":@"id",
             @"nick":@"nick_name",
             @"sexType":@"sex",
             @"cityId":@"city_id",
             @"provinceId":@"province_id",
             @"regionId":@"region_id"};
}

- (NSString *)getCacheKey {
    
    NSString *key = [super getCacheKey];
    key = [NSString stringWithFormat:@"%@_%@", key, [RawCacheManager getLastLoginAccount]];
    return key;
}

@end
