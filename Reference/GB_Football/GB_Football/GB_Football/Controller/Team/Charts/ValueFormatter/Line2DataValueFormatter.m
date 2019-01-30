//
//  Line2DataValueFormatter.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "Line2DataValueFormatter.h"

@implementation Line2DataValueFormatter

- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler {
    
    return [NSString stringWithFormat:@"%.1f", value];
}

@end
