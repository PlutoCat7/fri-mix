//
//  Bar2xAxisValueFormatter.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "Bar2xAxisValueFormatter.h"

@interface Bar2xAxisValueFormatter ()

@property (nonatomic, strong) NSArray<NSString *> *values;

@end

@implementation Bar2xAxisValueFormatter

- (instancetype)initWithValues:(NSArray<NSString *> *)values {
    
    self = [super init];
    if (self) {
        _values = values;
    }
    
    return self;
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    @try {
        NSInteger index  = (NSInteger)value-1;
        if (index<0) {
            return @"";
        }else if (index>=self.values.count) {
            return @"";
        }
        return self.values[index];
    } @catch (NSException *exception) {
        return @"";
    }
    
}


@end
