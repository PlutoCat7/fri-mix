//
//  GBSeachManager.m
//  GB_TransferMarket
//
//  Created by Pizza on 2017/2/10.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBSearchManager.h"

@interface GBSearchManager()
@property (nonatomic,strong) NSMutableArray<NSString *> *searchHistoryList;
@end

@implementation GBSearchManager


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)insertHistory:(NSString *)info
{
    if (!info) {
        return;
    }
    [self removeRepeatWord:info];
    [self.searchHistoryList insertObject:info atIndex:0];
    if ([self.searchHistoryList count] > MAX_SAVE_HISTORY) {
        [self.searchHistoryList removeLastObject];
    }
    
    [self saveCache];
}

- (void)clearAllHistory
{
    [self.searchHistoryList removeAllObjects];
    [self saveCache];
}

- (void)clearHistoryFromIndex:(NSInteger)index
{
    [self.searchHistoryList removeObjectAtIndex:index];
    [self saveCache];
}

- (NSArray<NSString *> *)getHistory
{
   return [self.searchHistoryList copy];
}

#pragma mark - Private
// 去除重复
- (void)removeRepeatWord:(NSString *)info
{
    NSArray *tmpList = [self.searchHistoryList copy];
    for (NSString *tmpInfo in tmpList) {
        if ([tmpInfo isEqualToString:info]) {
            [self.searchHistoryList removeObject:tmpInfo];
        }
    }
}

#pragma mark Setter

- (NSMutableArray *)searchHistoryList{

    if (!_searchHistoryList) {
        GBSearchManager *manager = [GBSearchManager loadCacheWithKey:[self getCacheKey]];
        _searchHistoryList = manager.searchHistoryList;
        if (!_searchHistoryList) {
            _searchHistoryList = [NSMutableArray arrayWithCapacity:1];
        }
    }
    
    return _searchHistoryList;
}

@end
