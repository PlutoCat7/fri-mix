//
//  VideoDetailInfo.h
//  GB_Video
//
//  Created by yahua on 2018/2/2.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBResponseInfo.h"

//视频的用户行为
@interface VideoUserActionInfo : YAHActiveObject

@property (nonatomic, assign) BOOL is_collect;  //是否收藏
@property (nonatomic, assign) BOOL is_like;     //是否点赞

@end

@interface VideoDetailInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoFirstFrameUrl;  //视频第一帧图片
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *game_id_name;   //赛区
@property (nonatomic, copy) NSString *team_id_name;   //球队
@property (nonatomic, copy) NSString *player_id_name; //球员
@property (nonatomic, assign) CGFloat duration;    //时长
@property (nonatomic, assign) NSInteger playCount; //播放次数
@property (nonatomic, strong) VideoUserActionInfo *action_info;

@end

@interface VideoDetailResponse : GBResponseInfo

@property (nonatomic, strong) VideoDetailInfo *data;

@end
