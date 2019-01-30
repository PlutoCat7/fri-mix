//
//  KSearchManager.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "KSearchManager.h"

@interface KSearchManager()

@property (assign, nonatomic) SearchType searchType;
@property (nonatomic,strong) NSMutableArray<KnowLabelInfo *> *searchHistoryList;

@end

@implementation KSearchManager

- (instancetype)initWithType:(SearchType)searchType {
    if (self = [super init]) {
        _searchType = searchType;
    }
    return self;
}

- (void)insertHistory:(KnowLabelInfo *)info
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

- (NSArray<KnowLabelInfo *> *)getHistory
{
    return [self.searchHistoryList copy];
}

#pragma mark - Private
// 去除重复
- (void)removeRepeatWord:(KnowLabelInfo *)info
{
    NSArray *tmpList = [self.searchHistoryList copy];
    for (KnowLabelInfo *tmpInfo in tmpList) {
        if ([tmpInfo.lableknowname isEqualToString:info.lableknowname]) {
            [self.searchHistoryList removeObject:tmpInfo];
        }
    }
}

#pragma mark Setter

-(NSString *)getCacheKey {
    return [NSString stringWithFormat:@"%@_%d", KEY_SEARCH_HISTORY, self.searchType];
}

- (NSMutableArray *)searchHistoryList{
    
    if (!_searchHistoryList) {
        KSearchManager *manager = [KSearchManager loadCacheWithKey:[self getCacheKey]];
        _searchHistoryList = manager.searchHistoryList;
        if (!_searchHistoryList) {
            _searchHistoryList = [NSMutableArray arrayWithCapacity:1];
        }
    }
    
    return _searchHistoryList;
}

@end
