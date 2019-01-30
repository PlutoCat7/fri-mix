//
//  VideoListStore.m
//  GB_Video
//
//  Created by yahua on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "VideoListStore.h"
#import "VideoListCellModel.h"
#import "TopicVideoListRequest.h"
#import "VideoRequest.h"

@interface VideoListStore()

@property (nonatomic, strong) NSArray<VideoListCellModel *> *cellModels;
@property (nonatomic, strong) TopicVideoListRequest *pageRequest;

@end

@implementation VideoListStore

- (instancetype)initWithTopicId:(NSInteger)topicId;
{
    self = [super init];
    if (self) {
        _pageRequest = [[TopicVideoListRequest alloc] init];
        _pageRequest.topicId = topicId;
    }
    return self;
}

#pragma mark - Public

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest reloadPageWithHandle:^(id result, NSError *error) {
        
        if (!error) {
            [self handlerNetworkData:self.pageRequest.responseInfo.items];
        }
        BLOCK_EXEC(handler, error);
    }];
}
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler {
    
    [self.pageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        if (!error) {
            [self handlerNetworkData:self.pageRequest.responseInfo.items];
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (BOOL)isLoadEnd {
    
    return self.pageRequest.isLoadEnd;
}

- (VideoDetailInfo *)videoInfoWithIndexPath:(NSIndexPath *)indexPath {
    
    VideoDetailInfo *info = self.pageRequest.responseInfo.items[indexPath.row];
    return info;
}

- (void)praiseWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))handler {
    
    VideoDetailInfo *info = self.pageRequest.responseInfo.items[indexPath.row];
    BOOL praise = !info.action_info.is_collect;
    [VideoRequest praiseVideo:info.videoId isPraise:praise handler:^(id result, NSError *error) {
        if (!error) {
            info.action_info.is_like = praise;
            VideoListCellModel *cellModel = self.cellModels[indexPath.row];
            cellModel.isPraise = praise;
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)collectWithIndexPath:(NSIndexPath *)indexPath handler:(void(^)(NSError *error))handler {
    
    VideoDetailInfo *info = self.pageRequest.responseInfo.items[indexPath.row];
    BOOL collect = !info.action_info.is_collect;
    [VideoRequest collectVideo:info.videoId isCollect:collect handler:^(id result, NSError *error) {
        if (!error) {
            info.action_info.is_like = collect;
            VideoListCellModel *cellModel = self.cellModels[indexPath.row];
            cellModel.isCollection = collect;
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)watchWithIndexPath:(NSIndexPath *)indexPath {
    
    VideoDetailInfo *info = self.pageRequest.responseInfo.items[indexPath.row];
    [VideoRequest watchVideo:info.videoId handler:nil];
}

#pragma mark - Private

- (void)handlerNetworkData:(NSArray<VideoDetailInfo *> *)infoList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infoList.count];
    for (VideoDetailInfo *info in infoList) {
        VideoListCellModel *model = [[VideoListCellModel alloc] init];
        model.videoUrl = [NSURL URLWithString:info.videoUrl];
        model.videoImageUrl = info.videoFirstFrameUrl;
        model.videoName = info.videoName;
        model.videoDuration = info.duration;
        model.watchCount = info.playCount;
        model.isPraise = info.action_info.is_like;
        model.isCollection = info.action_info.is_collect;
        [result addObject:model];
    }
    self.cellModels = [result copy];
}

@end
