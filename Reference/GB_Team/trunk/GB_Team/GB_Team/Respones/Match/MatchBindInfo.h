//
//  MatchBindInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/27.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchInfo.h"
#import "PlayerResponseInfo.h"
#import "BindWristbandListResponeInfo.h"

typedef NS_ENUM(NSUInteger, STAR_SEARCH_STATE)
{
    STAR_SEARCH_STATE_HIDDEN  = 0, // 隐藏
    STAR_SEARCH_STATE_IDLE,        // 待加速，未开始，加速搜星
    STAR_SEARCH_STATE_ING,         // 正在下载，写入星历
    STAR_SEARCH_STATE_FINISH,      // 已加速
    STAR_SEARCH_STATE_FAILED,      // 加速失败，重新加速
    STAR_SEARCH_STATE_COMPLETE,    // 搜星成功
};

@interface WristbandInfo (Player)

@property (nonatomic, assign) STAR_SEARCH_STATE searchStartState;

@property (nonatomic, strong) NSTimer *timeoutTimer;

@end

@interface PlayerBindInfo : YAHActiveObject

@property (nonatomic, strong) PlayerInfo *playerInfo;
@property (nonatomic, strong) WristbandInfo *wristbandInfo;

@end

@interface MatchBindInfo : MatchInfo

@property (nonatomic, strong) NSArray<PlayerBindInfo *> *playerBindArray;

@end
