//
//  BindWristbandListRespone.m
//  GB_Team
//
//  Created by 王时温 on 2016/11/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BindWristbandListResponeInfo.h"

@implementation WristbandInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"wristId":@"order_id",
             @"coachId":@"coach_id",
             @"name":@"order_name"};
}

@end

@implementation BindWristbandListResponeInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"WristbandInfo"};
}

@end
