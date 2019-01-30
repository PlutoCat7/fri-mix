//
//  PlayerDetailStore.m
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "PlayerDetailStore.h"
#import "CLVideoModel.h"
#import "PlayerDetailHeaderModel.h"
#import "PlayerDetailCommentCellModel.h"
#import "VideoRequest.h"
#import "VideoCommentListRequest.h"

@interface PlayerDetailStore ()

@property (nonatomic, strong) CLVideoModel *videoModel;
@property (nonatomic, strong) PlayerDetailHeaderModel *headerModel;
@property (nonatomic, strong) NSArray<PlayerDetailCommentCellModel *> *cellModels;
@property (nonatomic, assign) NSInteger commentLength;  //评论字数限制

@property (nonatomic, strong) VideoDetailInfo *videoInfo;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, strong) VideoCommentListRequest *pageRequest;


@end

@implementation PlayerDetailStore

- (instancetype)initWithVideoId:(NSInteger)videoId videoInfo:(VideoDetailInfo *)videoInfo
{
    self = [super init];
    if (self) {
        _videoId = videoId;
        _videoInfo = videoInfo;
        _pageRequest = [[VideoCommentListRequest alloc] init];
        _pageRequest.videoId = _videoId;
        [self parseVideoInfo];
    }
    return self;
}

- (void)loadVideoInfoWithHandle:(void(^)(NSError *error))handle {
    
    if (self.videoInfo) {
        [self parseVideoInfo];
        BLOCK_EXEC(handle, nil);
        return;
    }
    [VideoRequest getVideoInfo:self.videoId handler:^(id result, NSError *error) {
        
        if (!error) {
            self.videoInfo = result;
            [self parseVideoInfo];
        }
        BLOCK_EXEC(handle, error);
    }];
}

- (void)praiseWithHandler:(void(^)(NSError *error))handler {
    
    BOOL praise = !self.videoInfo.action_info.is_like;
    [VideoRequest praiseVideo:self.videoInfo.videoId isPraise:praise handler:^(id result, NSError *error) {
        if (!error) {
            self.videoInfo.action_info.is_like = praise;
            self.headerModel.isPraise = praise;
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)collectWithHandler:(void(^)(NSError *error))handler {
    
    BOOL collect = !self.videoInfo.action_info.is_collect;
    [VideoRequest praiseVideo:self.videoInfo.videoId isPraise:collect handler:^(id result, NSError *error) {
        if (!error) {
            self.videoInfo.action_info.is_collect = collect;
            self.headerModel.isCollection = collect;
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (void)watchVideo {
    
    [VideoRequest watchVideo:self.videoId handler:nil];
}

- (void)commentWithContent:(NSString *)content handler:(void(^)(NSError *error))handler {
    
    [VideoRequest commentVideo:self.videoId content:content handler:^(id result, NSError *error) {
        
        if (!error) {//刷新评论列表
            [self getFirstPageDataWithHandler:nil];
        }
        BLOCK_EXEC(handler, error);
    }];
}

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

#pragma mark - Private

- (void)parseVideoInfo {
    
    if (self.videoInfo) {
        CLVideoModel *model = [[CLVideoModel alloc] init];
        model.videoName = self.videoInfo.videoName;
        model.videoUrl = [NSURL URLWithString:self.videoInfo.videoUrl];
        model.currentSecond = 0;
        model.videoDuration = self.videoInfo.duration;
        self.videoModel = model;
    }
    
    PlayerDetailHeaderModel *headerModel = [[PlayerDetailHeaderModel alloc] init];
    headerModel.videoName = self.videoInfo.videoName;
    headerModel.watchCount = self.videoInfo.playCount;
    headerModel.isPraise = self.videoInfo.action_info.is_like;
    headerModel.isCollection = self.videoInfo.action_info.is_collect;
    self.headerModel = headerModel;
}

- (void)handlerNetworkData:(NSArray<VideoCommentInfo *> *)infoList {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:infoList.count];
    for (VideoCommentInfo *info in infoList) {
        PlayerDetailCommentCellModel *cellModel = [[PlayerDetailCommentCellModel alloc] init];
        cellModel.userImageUrl = info.image_url;
        cellModel.userName = info.nick_name;
        cellModel.timeString = [self timeStringWithTimeIntervalSince1970:info.update_time];
        cellModel.commentString = info.content;
        [result addObject:cellModel];
    }
    self.cellModels = [result copy];
}

- (NSString *)timeStringWithTimeIntervalSince1970:(NSTimeInterval)secs {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSString *dateString = [NSString stringWithFormat:@"%td-%02td-%02td", date.year, date.month, date.day];
    if ([date isToday]) {
        dateString = [NSString stringWithFormat:@"%02td:%02td", date.hour, date.minute];
    }
    return dateString;
}

@end
