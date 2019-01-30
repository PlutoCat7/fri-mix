//
//  GBResponsePageInfo.m
//  GB_Football
//
//  Created by weilai on 16/7/7.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

@implementation PageInfo

- (instancetype) init {
    if (self = [super init]) {
        self.pi = 0;
        self.ps = 20;
        self.pn = -1;
        self.rn = 0;
    }
    return self;
}

@end

@implementation GBResponsePageInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"page":@"pinfo"};
}

- (instancetype) init {
    
    if (self = [super init]) {
        _page = [[PageInfo alloc] init];
    }
    return self;
}

- (void)resetResponseInfo {
    
    [super resetResponseInfo];
    self.page = [[PageInfo alloc] init];
    self.items = @[];
}

- (NSArray *)onePageData {
    
    NSAssert(0, @"子类需重写");
    return nil;
}

@end
