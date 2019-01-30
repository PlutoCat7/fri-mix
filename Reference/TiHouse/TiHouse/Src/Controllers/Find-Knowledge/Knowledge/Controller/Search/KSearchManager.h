//
//  KSearchManager.h
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "GBResponseInfo.h"
#import "KnowLabelResponse.h"

#define MAX_SAVE_HISTORY 50
#define KEY_SEARCH_HISTORY @"Search_History"

typedef enum
{
    SearchType_All = 0,
    SearchType_Size = 1,//尺寸宝典
    SearchType_Arrange = 2,//风水
    SearchType_Find = 3,//发现
} SearchType;

@interface KSearchManager : GBResponseInfo

- (instancetype)initWithType:(SearchType)searchType;

- (void)insertHistory:(KnowLabelInfo *)str;
- (void)clearAllHistory;
- (void)clearHistoryFromIndex:(NSInteger)index;
- (NSMutableArray<KnowLabelInfo *> *)getHistory;

@end
