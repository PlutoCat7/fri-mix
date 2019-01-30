//
//  CoverAreaInfo.m
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "CoverAreaInfo.h"

@implementation CoverAreaItemInfo

- (void)setCover_rate:(CGFloat)cover_rate {
    
    _cover_rate = cover_rate;
    self.roundCoverRate = (NSInteger)round(cover_rate);
}

@end

@implementation CoverAreaInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"ceil3":@"CoverAreaItemInfo",
             @"ceil6":@"CoverAreaItemInfo",
             @"ceil9":@"CoverAreaItemInfo"};
}

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"ceil3":@"3ceil",
             @"ceil6":@"6ceil",
             @"ceil9":@"9ceil"};
}

@end
