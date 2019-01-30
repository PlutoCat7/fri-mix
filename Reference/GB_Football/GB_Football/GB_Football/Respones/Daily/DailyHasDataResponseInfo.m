//
//  DailyHasDataResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "DailyHasDataResponseInfo.h"

@implementation DailyHasDataInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"hasDate":@"is_has_data"};
}

@end

@implementation DailyHasDataResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"DailyHasDataInfo"};
}

@end
