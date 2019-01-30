//
//  WristbandFilterResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2016/12/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "WristbandFilterResponseInfo.h"

@implementation WristbandFilterInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"name":@"equip_name",
             @"handEquipName":@"hand_equip_name",
             @"nickName":@"nick_name"};
}

- (void)setNumber:(NSString *)number {
    
    _number = number;
    if (number.length<14) {
        _showNumber = number;
    } else {
        _showNumber = [NSString stringWithFormat:@"%@****%@", [number substringWithRange:NSMakeRange(0, 5)], [number substringWithRange:NSMakeRange(9, 5)]];
    }
    
}

@end

@implementation WristbandFilterResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"WristbandFilterInfo"};
}

@end
