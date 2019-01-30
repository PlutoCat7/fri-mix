//
//  NSArray+Expand.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "NSArray+Expand.h"

@implementation NSArray (Expand)

- (NSArray *)subValueListWithKey:(NSString *)key {
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        id value = [object valueForKey:key];
        if (!value) {
            continue;
        }
        [values addObject:value];
    }
    return [values copy];
}

- (CGFloat)subValueCountWithKey:(NSString *)key {
    
    NSArray *values = [self subValueListWithKey:key];
    CGFloat count = 0;
    for (id value in values) {
        if (![value isKindOfClass:[NSNumber class]]) {
            continue;
        }
        count += [value floatValue];
    }
    return count;
}

- (CGFloat)subValueAvgWithKey:(NSString *)key {
    
    CGFloat count = [self subValueCountWithKey:key];
    return count/self.count;
}

//获取成员某个属性的最大值
- (CGFloat)subValueMaxWithKey:(NSString *)key {
    
    NSArray *values = [self subValueListWithKey:key];
    CGFloat max = 0;
    for (id value in values) {
        if (![value isKindOfClass:[NSNumber class]]) {
            continue;
        }
        if ([value floatValue]>max) {
            max = [value floatValue];
        }
    }
    return max;
}

//获取成员某个属性的最小值
- (CGFloat)subValueMinWithKey:(NSString *)key {
    
    NSArray *values = [self subValueListWithKey:key];
    CGFloat min = 100000;
    for (id value in values) {
        if (![value isKindOfClass:[NSNumber class]]) {
            continue;
        }
        if ([value floatValue]<min) {
            min = [value floatValue];
        }
    }
    return min;
}

- (NSArray *)sortDescWithKey:(NSString *)key {
    
    NSArray *sortArray = [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        id value1 = [obj1 valueForKey:key];
        id value2 = [obj2 valueForKey:key];

        if ([value1 floatValue] > [value2 floatValue]) {
            return NSOrderedAscending;
        }else if ([value1 floatValue] < [value2 floatValue]){
            return NSOrderedDescending;
        }else {
            return NSOrderedSame;
        }
    }];
    
    return sortArray;
}

@end
