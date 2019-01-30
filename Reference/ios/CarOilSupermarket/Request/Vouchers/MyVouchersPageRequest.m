//
//  MyVouchersPageRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MyVouchersPageRequest.h"

@implementation MyVouchersPageRequest

- (Class)responseClass {
    
    return [MyVouchersPageResponse class];
}

- (NSDictionary *)parameters {
    
    return @{@"act":@"list",
             @"do":@"quan",
             @"mid":[RawCacheManager sharedRawCacheManager].userId};
}

@end
