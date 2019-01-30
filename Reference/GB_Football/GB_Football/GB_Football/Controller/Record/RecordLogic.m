//
//  RecordLogic.m
//  GB_Football
//
//  Created by yahua on 2017/8/30.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "RecordLogic.h"

@implementation RecordLogic

+ (NSInteger)totalRateWithCoverRate:(CGFloat)coverRate {
    
    return ((NSInteger)round(coverRate));
}

+ (NSArray<NSArray<NSString *> *> *)rateDetailWithCoverAreaInfo:(CoverAreaInfo *)info vertical:(BOOL)vertical  total:(CGFloat)total {
    
    if (!info) {
        return nil;
    }
    info = [info copy];
    if (info.ceil3 &&
        info.ceil6 &&
        info.ceil9) {

        NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:1];
        //三区
        total = [self totalRateWithCoverRate:total];
        [self handleRate:info.ceil3 total:total];
        [tmpList addObject:[self rateStrings:info.ceil3]];
        if (vertical) { //垂直处理方式
            //六区
            NSArray<CoverAreaItemInfo *> *handleItems = @[info.ceil6[0], info.ceil6[1]];
            [self handleRate:handleItems total:info.ceil3[0].roundCoverRate];
            handleItems = @[info.ceil6[2], info.ceil6[3]];
            [self handleRate:handleItems total:info.ceil3[1].roundCoverRate];
            handleItems = @[info.ceil6[4], info.ceil6[5]];
            [self handleRate:handleItems total:info.ceil3[2].roundCoverRate];
            
            //九区
            handleItems = @[info.ceil9[0], info.ceil9[1], info.ceil9[2]];
            [self handleRate:handleItems total:info.ceil3[0].roundCoverRate];
            handleItems = @[info.ceil9[3], info.ceil9[4], info.ceil9[5]];
            [self handleRate:handleItems total:info.ceil3[1].roundCoverRate];
            handleItems = @[info.ceil9[6], info.ceil9[7], info.ceil9[8]];
            [self handleRate:handleItems total:info.ceil3[2].roundCoverRate];
        }else {  //水平处理方式
            //六区
            NSArray<CoverAreaItemInfo *> *handleItems = @[info.ceil6[0], info.ceil6[3]];
            [self handleRate:handleItems total:info.ceil3[0].roundCoverRate];
            handleItems = @[info.ceil6[1], info.ceil6[4]];
            [self handleRate:handleItems total:info.ceil3[1].roundCoverRate];
            handleItems = @[info.ceil6[2], info.ceil6[5]];
            [self handleRate:handleItems total:info.ceil3[2].roundCoverRate];
            
            //九区
            handleItems = @[info.ceil9[0], info.ceil9[3], info.ceil9[6]];
            [self handleRate:handleItems total:info.ceil3[0].roundCoverRate];
            handleItems = @[info.ceil9[1], info.ceil9[4], info.ceil9[7]];
            [self handleRate:handleItems total:info.ceil3[1].roundCoverRate];
            handleItems = @[info.ceil9[2], info.ceil9[5], info.ceil9[8]];
            [self handleRate:handleItems total:info.ceil3[2].roundCoverRate];
        }
        [tmpList addObject:[self rateStrings:info.ceil6]];
        [tmpList addObject:[self rateStrings:info.ceil9]];
        
        return [tmpList copy];
    }
    return nil;
}

+ (NSArray<NSArray<NSString *> *> *)rateDetailWithTimeRateInfo:(TimeRateInfo *)info correct:(CoverAreaInfo *)areaInfo vertical:(BOOL)vertical  total:(NSInteger)total {
    if (!info) {
        return nil;
    }
    info = [info copy];
    if (info.ceil3 &&
        info.ceil6 &&
        info.ceil9) {
        
        NSMutableArray *tmpList = [NSMutableArray arrayWithCapacity:1];
        //三区
        [tmpList addObject:[self timeRateStrings:info.ceil3 correct:areaInfo.ceil3 total:total]];
        //六区
        [tmpList addObject:[self timeRateStrings:info.ceil6 correct:areaInfo.ceil6 total:total]];
        //九区
        [tmpList addObject:[self timeRateStrings:info.ceil9 correct:areaInfo.ceil9 total:total]];
        
        return [tmpList copy];
    }
    return nil;
}

#pragma mark - Private

+ (void)handleRate:(NSArray<CoverAreaItemInfo *> *)list total:(NSInteger)total {
    
    __block NSInteger realTotal = 0;
    [list enumerateObjectsUsingBlock:^(CoverAreaItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        realTotal += obj.roundCoverRate;
    }];
    if (realTotal!=total) {
        __block CoverAreaItemInfo *maxInfo = list.firstObject;
        [list enumerateObjectsUsingBlock:^(CoverAreaItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.roundCoverRate > maxInfo.roundCoverRate) {
                maxInfo = obj;
            }
        }];
        NSInteger dela = total - realTotal;
        NSInteger roundCoverRate =  maxInfo.roundCoverRate + dela;
        if (roundCoverRate <0) {
            roundCoverRate = 0;
        }
        maxInfo.roundCoverRate = roundCoverRate;
    }
}

+ (NSArray<NSString *> *)rateStrings:(NSArray<CoverAreaItemInfo *> *)list {
    
    NSMutableArray<NSNumber *> *tmpList = [NSMutableArray arrayWithCapacity:1];
    for (CoverAreaItemInfo *info in list) {
        [tmpList addObject:@((NSInteger)(info.roundCoverRate))];
    }
    
    
    NSMutableArray<NSString *> *results = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=0; index<tmpList.count; index++) {
        NSNumber *number = tmpList[index];
        if ([number integerValue] == 0 && list[index].cover_rate>0) {
            [results addObject:@"<1%"];
        }else {
            [results addObject:[NSString stringWithFormat:@"%td%%", [number integerValue]]];
        }
    }
    return [results copy];
}

+ (NSArray<NSString *> *)timeRateStrings:(NSArray<NSNumber *> *)list correct:(NSArray<CoverAreaItemInfo *> *)arealist total:(NSInteger)total {
    NSMutableArray<NSNumber *> *tmpList = [NSMutableArray arrayWithArray:list];
    
    NSMutableArray<NSString *> *results = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=0; index<tmpList.count; index++) {
        NSNumber *number = tmpList[index];
        
        NSInteger ceilTime = [number floatValue] * total;
        CoverAreaItemInfo *areaInfo = arealist.count > index ? arealist[index] : nil;
        
        if (ceilTime == 0 && areaInfo && areaInfo.cover_rate > 0) {
            NSInteger value = areaInfo.cover_rate < 1 ? 1 : areaInfo.roundCoverRate;
            NSInteger minute = value / 60;
            NSInteger second = value % 60;
            [results addObject:[NSString stringWithFormat:@"%d'%02d\"", (int)minute, (int)second]];
            
        } else {
            NSInteger minute = ceilTime / 60;
            NSInteger second = ceilTime % 60;
            [results addObject:[NSString stringWithFormat:@"%d'%02d\"", (int)minute, (int)second]];
        }
        
        
    }
    return [results copy];
}

@end
