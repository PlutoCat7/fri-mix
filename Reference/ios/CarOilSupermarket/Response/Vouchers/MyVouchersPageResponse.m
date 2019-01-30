//
//  MyVouchersPageResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/14.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MyVouchersPageResponse.h"

@implementation MyVouchersInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"vouchersId":@"id"};
}

@end

@implementation MyVouchersPageInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"MyVouchersInfo"};
}

@end

@implementation MyVouchersPageResponse

- (NSArray *)onePageData {
    
    return self.data.list;
}

- (NSInteger)totalPageCount {
    
    return self.data.pages;
}

@end
