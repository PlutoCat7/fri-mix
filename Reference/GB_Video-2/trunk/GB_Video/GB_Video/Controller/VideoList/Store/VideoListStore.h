//
//  VideoListStore.h
//  GB_Video
//
//  Created by yahua on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VideoListCellModel;
@class VideoDetailInfo;

@interface VideoListStore : NSObject

@property (nonatomic, strong, readonly) NSArray<VideoListCellModel *> *cellModels;

- (instancetype)initWithTopicId:(NSInteger)topicId;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;
- (VideoDetailInfo *)videoInfoWithIndexPath:(NSIndexPath *)indexPath;

- (BOOL)isLoadEnd;

- (void)praiseWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))handler;
- (void)collectWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))handler;
- (void)watchWithIndexPath:(NSIndexPath *)indexPath;

@end
