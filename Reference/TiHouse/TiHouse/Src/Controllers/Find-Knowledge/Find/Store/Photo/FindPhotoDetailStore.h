//
//  FindPhotoDetailStore.h
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindWaterfallModel.h"

@class FindAssemarcInfo;
@interface FindPhotoDetailStore : NSObject

@property (nonatomic, strong) FindAssemarcInfo *arcInfo;
@property (nonatomic, assign) BOOL isEmptyData;
@property (nonatomic, strong, readonly) NSArray<FindWaterfallModel *> *cellModels;

- (instancetype)initWithAssemarcInfo:(FindAssemarcInfo *)arcInfo;
- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;
- (BOOL)isLoadEnd;

- (FindAssemarcInfo *)assemarcInfoWithIndexPath:(NSIndexPath *)indexPath;

//收藏
- (void)favorArticleWithHandler:(void(^)(BOOL isSuccess))handler;

- (void)zanArticleWithHandler:(void(^)(BOOL isSuccess))handler;

- (void)attentionWithHandler:(void(^)(BOOL isSuccess))handler;

@end
