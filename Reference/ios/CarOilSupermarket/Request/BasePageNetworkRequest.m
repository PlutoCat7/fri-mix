//
//  BasePageNetworkRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BasePageNetworkRequest.h"

@interface BasePageNetworkRequest ()

@property (nonatomic, strong) __kindof COSPageResponseInfo *responseInfo;

@property (nonatomic, assign, getter=isNoMoreData) BOOL noMoreData;

//请求
@property (nonatomic, strong) NSURLSessionTask *requestTask;
@property (nonatomic, assign) NSInteger requestPage;

@end

@implementation BasePageNetworkRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _responseInfo = [[COSPageResponseInfo alloc] init];
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
    
    return (self.responseInfo.pageIndex > [self.responseInfo totalPageCount]);
}

#pragma mark - BasePageNetworkRequestDataSource

- (Class)responseClass {
    
    NSAssert(0, @"子类需重写");
    return nil;
}

- (NSDictionary *)parameters {
    
    return nil;
}

#pragma mark - Private

- (void)loadPageWithHandler:(RequestCompleteHandler)handler {
    
    if (self.requestTask.state == NSURLSessionTaskStateRunning) {
        [self.requestTask cancel];
    }
    self.requestPage = self.responseInfo.pageIndex;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:[self parameters]];
    [parameters setValuesForKeysWithDictionary:@{@"page":@(self.responseInfo.pageIndex)}];
    self.requestTask = [BaseNetworkRequest POSTWithParameters:[parameters copy] responseClass:self.responseClass handler:^(id result, NSError *error) {
        
        if (error) {
            if (error.code == NSURLErrorCancelled) {
                return;
            }
            BLOCK_EXEC(handler, nil, error);
        }else {
            if ([[parameters objectForKey:@"page"] integerValue] != self.requestPage) {//非最新请求
                return ;
            }
            //页数+1
            self.responseInfo.pageIndex +=1;
            
            //保留原先列表
            NSMutableArray *items = [NSMutableArray arrayWithArray:self.responseInfo.items];
            NSInteger pageIndex = self.responseInfo.pageIndex;
            self.responseInfo = result;
            NSArray *newData = [self.responseInfo onePageData];
            [items addObjectsFromArray:newData];
            self.responseInfo.items = [items copy];
            self.responseInfo.pageIndex = pageIndex;
            
            BLOCK_EXEC(handler, result, nil);
        }
    }];
}

@end
