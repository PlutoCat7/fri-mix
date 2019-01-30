//
//  MyPointsPageResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/15.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "MyPointsPageResponse.h"

@implementation MyPointsInfo

@end

@implementation MyPointsPageInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"MyPointsInfo"};
}

@end

@implementation MyPointsPageResponse

- (NSArray *)onePageData {
    
    return self.data.list;
}

- (NSInteger)totalPageCount {
    
    return self.data.pages;
}

@end
