//
//  RecordLogic.h
//  GB_Football
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoverAreaInfo.h"
#import "TimeRateInfo.h"

@interface RecordLogic : NSObject

+ (NSInteger)totalRateWithCoverRate:(CGFloat)coverRate;

+ (NSArray<NSArray<NSString *> *> *)rateDetailWithCoverAreaInfo:(CoverAreaInfo *)info vertical:(BOOL)vertical  total:(CGFloat)total;


+ (NSArray<NSArray<NSString *> *> *)rateDetailWithTimeRateInfo:(TimeRateInfo *)info correct:(CoverAreaInfo *)areaInfo vertical:(BOOL)vertical total:(NSInteger)total;

@end
