//
//  FindWaterfallStore.h
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindWaterfallModel.h"

@class FindAssemarcInfo;
@interface FindWaterfallStore : NSObject

@property (nonatomic, strong, readonly) NSArray<FindWaterfallModel *> *cellModels;

@property (nonatomic, copy) NSString *searchName;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;
- (BOOL)isLoadEnd;

- (FindAssemarcInfo *)assemarcInfoWithIndexPath:(NSIndexPath *)indexPath;

//点赞
- (void)likeArticleWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler;

@end
