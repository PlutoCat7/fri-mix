//
//  BalanceDetailsRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BalanceDetailsRequest.h"

@implementation BalanceDetailsRequest

- (Class)responseClass {
    
    return [BalanceDetailsPageResponse class];
}

- (NSDictionary *)parameters {
    
    return @{@"act":@"history",
             @"do":@"balance",
             @"mid":[RawCacheManager sharedRawCacheManager].userId};
}


@end
