//
//  OrderRecordRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/12.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderRecordRequest.h"

@implementation OrderRecordRequest

- (Class)responseClass {
    
    return [OrderRecordPageResponse class];
}

- (NSDictionary *)parameters {
    
    return @{@"act":@"list",
             @"do":@"order",
             @"status":@(self.type),
             @"mid":[RawCacheManager sharedRawCacheManager].userId};
}

@end
