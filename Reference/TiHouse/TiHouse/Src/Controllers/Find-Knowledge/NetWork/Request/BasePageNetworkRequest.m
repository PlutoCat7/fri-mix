//
//  BasePageNetworkRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BasePageNetworkRequest.h"



@interface BasePageNetworkRequest ()

@property (nonatomic, strong) __kindof GBResponsePageInfo *responseInfo;

@property (nonatomic, assign, getter=isNoMoreData) BOOL noMoreData;

@end

@implementation BasePageNetworkRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _responseInfo = [[GBResponsePageInfo alloc] init];
    }
    return self;
}

- (void)reloadPageWithHandle:(RequestCompleteHandler)handler {
    
    //重置
    [self.responseInfo resetResponseInfo];
    
    [self loadPageWithHandler:handler];
}

- (void)loadNextPageWithHandle:(RequestCompleteHandler)handler {
    
    if ([self isLoadEnd]) {
        return;
    }
    
    [self loadPageWithHandler:handler];
}

/**
 * @brief 是否已经全部加载完成
 *
 * @return BOOL
 */
- (BOOL)isLoadEnd {
    
    return self.responseInfo.isLoadEnd;
}

#pragma mark - BasePageNetworkRequestDataSource

- (Class)responseClass {
    
    NSAssert(0, @"子类需重写");
    return nil;
}

- (NSString *)requestAction {
    
    NSAssert(0, @"子类需重写");
    return nil;
}

- (NSDictionary *)parameters {
    
    return nil;
}

#pragma mark - Private

- (void)loadPageWithHandler:(RequestCompleteHandler)handler {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self parameters]];
    [parameters setValuesForKeysWithDictionary:@{@"start":@(self.responseInfo.start)}];
    [parameters setValuesForKeysWithDictionary:@{@"limit":@(self.responseInfo.limit)}];
    
    NSInteger page = self.responseInfo.start;
    [BaseNetworkRequest POST:[self requestAction] parameters:[parameters copy] responseClass:self.responseClass handler:^(id result, NSError *error) {
        
        if (page != self.responseInfo.start) { //防止多次调用
            if (handler) {
                handler(self.responseInfo, nil);
            }
            return;
        }
        if (error) {
            if (handler) {
                handler(nil, error);
            }
        }else {
            //保留原先列表
            NSMutableArray *items = [NSMutableArray arrayWithArray:self.responseInfo.items];
            
            self.responseInfo = result;
            NSArray *newData = [self.responseInfo onePageData];
            [items addObjectsFromArray:newData];
            self.responseInfo.items = [items copy];
            self.responseInfo.start = items.count;
            if (handler) {
                handler(result, nil);
            }
        }
    }];
}

@end
