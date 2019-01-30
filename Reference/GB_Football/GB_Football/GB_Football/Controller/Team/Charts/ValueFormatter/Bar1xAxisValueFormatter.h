//
//  Bar1xAxisValueFormatter.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/10.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAHCharts-Swift.h"

@interface Bar1xAxisValueFormatter : NSObject <IChartAxisValueFormatter>

- (instancetype)initWithValues:(NSArray<NSString *> *)values;

@end
