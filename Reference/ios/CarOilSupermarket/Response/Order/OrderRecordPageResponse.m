//
//  OrderRecordPageResponse.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/12.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderRecordPageResponse.h"

@implementation OrderRecordGoodsInfo



@end

@implementation OrderRecordInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"orderId":@"id"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"goods":@"OrderRecordGoodsInfo"};
}

@end

@implementation OrderRecordPageInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"list":@"OrderRecordInfo"};
}

@end

@implementation OrderRecordPageResponse

- (NSArray *)onePageData {
    
    return self.data.list;
}

- (NSInteger)totalPageCount {
    
    return self.data.pages;
}

@end
