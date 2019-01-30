//
//  Bar1xAxisValueFormatter.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "Bar1xAxisValueFormatter.h"

@interface Bar1xAxisValueFormatter ()

@property (nonatomic, strong) NSArray<NSString *> *values;

@end

@implementation Bar1xAxisValueFormatter

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
        if (index<0) {
            return @"";
        }else if (index>=self.values.count) {
            return @"";
        }
        //补充空格， 才能完全显示
        NSString *str = self.values[index];
        return str;
    } @catch (NSException *exception) {
        return @"";
    }
    
}



@end
