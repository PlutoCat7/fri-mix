//
//  FindRootStore.h
//  TiHouse
//
//  Created by yahua on 2018/2/4.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FindAssemarcInfo;
@class FindPhotoPreviewModel;
@interface FindRootStore : NSObject

@property (nonatomic, assign) NSInteger type;  //0：动态 1:关注
@property (nonatomic, strong, readonly) NSArray<FindAssemarcInfo *> *cellModels;
@property (nonatomic, strong) NSMutableDictionary *cacheCellHeightDictionary;  //文章id为key  高度为值

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;
- (BOOL)isLoadEnd;

- (FindAssemarcInfo *)assemarcInfoWithIndexPath:(NSIndexPath *)indexPath;

//图片预览数据结构
- (NSArray<FindPhotoPreviewModel *> *)photoPreviewModelsWithIndexPath:(NSIndexPath *)indexPath;

//点赞
- (void)likeArticleWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler;

//收藏
- (void)favorArticleWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler;

//关注
- (void)attentionWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(BOOL isSuccess))handler;

@end
