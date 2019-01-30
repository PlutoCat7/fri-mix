//
//  MyPointsPageRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MyPointsPageRequest.h"

@implementation MyPointsPageRequest

- (Class)responseClass {
    
    return [MyPointsPageResponse class];
}

- (NSDictionary *)parameters {
    
    return @{@"act":@"list",
             @"do":@"point",
             @"mid":[RawCacheManager sharedRawCacheManager].userId};
}


@end
