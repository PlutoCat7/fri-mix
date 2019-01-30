//
//  TimeDivisionRecordInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface TimeDivisionRecordInfo : GBResponseInfo

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;

@end
