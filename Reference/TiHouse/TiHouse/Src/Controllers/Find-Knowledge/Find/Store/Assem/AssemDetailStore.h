//
//  AssemDetailStore.h
//  TiHouse
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindWaterfallModel.h"
#import "FindAssemActivityInfo.h"

@class FindAssemarcInfo;
@interface AssemDetailStore : NSObject

@property (nonatomic, assign) NSInteger type; 
@property (nonatomic, assign) BOOL isEmptyData;
@property (nonatomic, strong, readonly) NSArray<FindWaterfallModel *> *cellModels;

- (instancetype)initWithAssemId:(long)assemId;
- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;
- (BOOL)isLoadEnd;

- (void)getAssemActivityInfoWithHandler:(void(^)(NSError *error, FindAssemActivityInfo *assemInfo))handler;

- (FindAssemarcInfo *)assemarcInfoWithIndexPath:(NSIndexPath *)indexPath;

@end
