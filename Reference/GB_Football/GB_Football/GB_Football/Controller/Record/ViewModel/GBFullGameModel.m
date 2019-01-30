//
//  GBFullGameModel.m
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBFullGameModel.h"

@implementation GBFullGameModel

- (NSArray<NSString *> *)currentRateInfo {
    
    if (self.coverAreaStyle >= self.rateList.count) {
        return nil;
    }
    return [self.rateList objectAtIndex:self.coverAreaStyle];
}

- (NSArray<NSString *> *)currentTimeInfo {
    if (self.coverAreaStyle >= self.timeList.count) {
        return nil;
    }
    return [self.timeList objectAtIndex:self.coverAreaStyle];
}

- (void)swipeRateList {
    
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *rates in _rateList) {
        NSArray *newRates = [[rates reverseObjectEnumerator] allObjects];
        [tmp addObject:newRates];
    }
    
    self.rateList = [tmp copy];
    
    NSMutableArray *tmpTime = [NSMutableArray arrayWithCapacity:1];
    for (NSArray *rates in _timeList) {
        NSArray *newRates = [[rates reverseObjectEnumerator] allObjects];
        [tmpTime addObject:newRates];
    }
    
    self.timeList = [tmpTime copy];
}


@end
