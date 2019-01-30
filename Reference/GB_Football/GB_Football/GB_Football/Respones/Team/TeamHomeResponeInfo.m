//
//  TeamHomeResponeInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamHomeResponeInfo.h"

@implementation TeamPalyerInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"roleType":@"role_id",
             @"inviteStatus":@"stat"};
}

@end

@implementation TeamHomeRespone

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"players":@"TeamPalyerInfo"};
}

@end

@implementation TeamHomeResponeInfo

@end
