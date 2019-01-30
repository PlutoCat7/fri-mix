//
//  TeamActivityListResponeInfo.m
//  GB_Football
//
//  Created by gxd on 2017/10/13.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamActivityListResponeInfo.h"

@implementation TeamActivityInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    return @{@"activityId":@"id",
             @"imageUrl":@"banner_url",
             @"endStatus":@"end_status",
             @"operateType":@"operate_type",
             @"paramUrl":@"param_url"};
}

@end

@implementation TeamActivityListResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"TeamActivityInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
