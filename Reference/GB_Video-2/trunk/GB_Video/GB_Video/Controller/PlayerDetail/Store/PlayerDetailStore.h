//
//  PlayerDetailStore.h
//  GB_Video
//
//  Created by yahua on 2018/1/24.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLVideoModel;
@class PlayerDetailHeaderModel;
@class PlayerDetailCommentCellModel;
@class VideoDetailInfo;

@interface PlayerDetailStore : NSObject

@property (nonatomic, strong, readonly) CLVideoModel *videoModel;
@property (nonatomic, strong, readonly) PlayerDetailHeaderModel *headerModel;
@property (nonatomic, strong, readonly) NSArray<PlayerDetailCommentCellModel *> *cellModels;

@property (nonatomic, assign, readonly) NSInteger commentLength;  //评论字数限制

- (instancetype)initWithVideoId:(NSInteger)videoId videoInfo:(VideoDetailInfo *)videoInfo;


- (void)loadVideoInfoWithHandle:(void(^)(NSError *error))handle;

- (void)getFirstPageDataWithHandler:(void(^)(NSError *error))handler;
- (void)getNextPageDataWithHandler:(void(^)(NSError *error))handler;
- (BOOL)isLoadEnd;

- (void)praiseWithHandler:(void(^)(NSError *error))handler;
- (void)collectWithHandler:(void(^)(NSError *error))handler;
- (void)watchVideo;
- (void)commentWithContent:(NSString *)content handler:(void(^)(NSError *error))handler;

@end
