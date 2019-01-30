//
//  DailySummaryResponeInfo.h
//  GB_Football
//
//  Created by gxd on 17/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"

@interface DailySummaryInfo : YAHActiveObject

@property (nonatomic, strong) DailyInfo *day;
@property (nonatomic, strong) DailyInfo *week;
@property (nonatomic, strong) DailyInfo *month;

@end

@interface DailySummaryResponeInfo : GBResponseInfo

@property (nonatomic, strong) DailySummaryInfo *data;

@end
