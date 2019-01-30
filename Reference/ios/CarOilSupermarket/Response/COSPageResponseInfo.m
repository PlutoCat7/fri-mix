//
//  COSPageResponseInfo.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/15.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "COSPageResponseInfo.h"

@implementation COSPageResponseInfo

- (instancetype) init {
    
    if (self = [super init]) {
        _pageIndex = 1;
    }
    return self;
}

- (void)resetResponseInfo {
    
    [super resetResponseInfo];
    self.pageIndex = 1;
    self.items = @[];
}

- (NSArray *)onePageData {
    
    NSAssert(0, @"子类需重写");
    return nil;
}

- (NSInteger)totalPageCount {
    
    NSAssert(0, @"子类需重写");
    return 0;
}

@end
