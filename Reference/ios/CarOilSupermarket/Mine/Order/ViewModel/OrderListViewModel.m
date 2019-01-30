//
//  OrderListModel.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/10/16.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "OrderListViewModel.h"

@interface OrderListViewModel ()

@property (nonatomic, strong) OrderRecordRequest *pageRequest;

@end

@implementation OrderListViewModel

- (instancetype)initWithType:(OrderType)type {
    
    self = [super init];
    if (self) {
        
        _type = type;
        _pageRequest = [[OrderRecordRequest alloc] init];
        _pageRequest.type = type;
    }
    
    return self;
}

#pragma mark - Public

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            self.recordlist = self.pageRequest.responseInfo.items;
        }
        BLOCK_EXEC(handler, error);
    }];
}
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            self.recordlist = self.pageRequest.responseInfo.items;
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (BOOL)isLoadEnd {
    
    return self.pageRequest.isLoadEnd;
}


@end
