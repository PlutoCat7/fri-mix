//
//  BalanceDetailsPageResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/18.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "BalanceDetailsPageResponse.h"

@implementation BalanceDetailsInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"balanceDetailsId":@"id"};
}

@end

@implementation BalanceDetailsPageInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"BalanceDetailsInfo"};
}

@end

@implementation BalanceDetailsPageResponse

- (NSArray *)onePageData {
    
    return self.data.list;
}

- (NSInteger)totalPageCount {
    
    return self.data.pages;
}

@end
