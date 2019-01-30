//
//  GBSeachManager.h
//  GB_TransferMarket
//
//  Created by Pizza on 2017/2/10.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchAssociationsResponseInfo.h"

#define MAX_SAVE_HISTORY 15
#define KEY_SEARCH_HISTORY @"Search_History"

@interface GBSearchManager : GBResponseInfo
- (void)insertHistory:(NSString *)str;
- (void)clearAllHistory;
- (void)clearHistoryFromIndex:(NSInteger)index;
- (NSMutableArray<NSString *> *)getHistory;

@end
