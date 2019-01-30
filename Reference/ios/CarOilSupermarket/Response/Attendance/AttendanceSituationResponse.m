//
//  AttendanceSituationResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "AttendanceSituationResponse.h"

@implementation AttendanceDateInfo

@end

@implementation AttendanceSituationInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"AttendanceDateInfo"};
}

- (NSDate *)serverDate {
    
    if (_serverDate) {
        return _serverDate;
    }
    
    NSArray *list = [self.serverTime componentsSeparatedByString:@" "];
    if (list.count != 2) {
        return nil;
    }
    NSArray *firstList = [list[0] componentsSeparatedByString:@"-"];
    NSArray *secondList = [list[1] componentsSeparatedByString:@":"];
    if (firstList.count == 3 &&
        secondList.count == 3) {
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        comps.year = [firstList[0] integerValue];
        comps.month = [firstList[1] integerValue];
        comps.day = [firstList[2] integerValue];
        comps.hour = [secondList[0] integerValue];
        comps.minute = [secondList[1] integerValue];
        comps.second = [secondList[2] integerValue];
        
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        _serverDate = [gregorian dateFromComponents:comps];
        return _serverDate;
    }
    return nil;
}

@end

@implementation AttendanceSituationResponse

@end
