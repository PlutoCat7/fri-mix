//
//  DailyHasDataResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface DailyHasDataInfo : YAHActiveObject

@property (nonatomic, assign) long date;
@property (nonatomic, assign) BOOL hasData;

@end

@interface DailyHasDataResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<DailyHasDataInfo *> *data;

@end
