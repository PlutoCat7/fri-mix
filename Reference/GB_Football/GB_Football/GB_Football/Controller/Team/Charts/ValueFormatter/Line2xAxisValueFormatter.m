//
//  Line2xAxisValueFormatter.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "Line2xAxisValueFormatter.h"

@interface Line2xAxisValueFormatter ()

@property (nonatomic, strong) NSArray<NSString *> *values;

@end

@implementation Line2xAxisValueFormatter

- (instancetype)initWithValues:(NSArray<NSString *> *)values {
    
    self = [super init];
    if (self) {
        _values = values;
        __block NSString *findMaxlengthString = @"";
        [values enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length>findMaxlengthString.length) {
                findMaxlengthString = obj;
            }
        }];
        NSMutableString *tmpString = [NSMutableString stringWithString:@""];
        for(NSInteger i=0; i<findMaxlengthString.length*1.5; i++){
            [tmpString appendString:@" "];
        }

    }
    
    return self;
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    @try {
        NSInteger index  = (NSInteger)value;
        if (index ==0 || index==self.values.count+1) { //去掉头尾
            return @"";
        }
        index--;
        if (index<0) {
            index=0;
        }else if (index>=self.values.count) {
            index = self.values.count-1;
        }
        NSString *str = self.values[index];
        
        return str;
    } @catch (NSException *exception) {
        return @"";
    }
    
}

@end
