//
//  ChartDataModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "ChartDataModel.h"

@implementation ChartDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nameFont = [UIFont systemFontOfSize:10.0f];
        _nameColor = [UIColor whiteColor];
        
        _valueColor = [UIColor clearColor];
        _valueTextColor = [UIColor whiteColor];
        _valueFont = [UIFont systemFontOfSize:10.0f];
    }
    return self;
}

@end
