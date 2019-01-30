//
//  GBResponsePageInfo.m
//  GB_Football
//
//  Created by weilai on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"


@implementation GBResponsePageInfo

- (instancetype) init {
    
    if (self = [super init]) {
        [self resetResponseInfo];
    }
    return self;
}

- (void)resetResponseInfo {
    
    [super resetResponseInfo];
    self.start = 0;
    self.limit = 20;
    self.items = @[];
}

- (NSArray *)onePageData {
    
    NSAssert(0, @"子类需重写");
    return nil;
}

- (BOOL)isLoadEnd {
    
    return self.allCount <= self.items.count;
}

@end
