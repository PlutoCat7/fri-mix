//
//  PlayerRequest.h
//  GB_Team
//
//  Created by weilai on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "PlayerResponseInfo.h"

@interface PlayerRequest : BaseNetworkRequest

/**
 获取球员列表
 
 */
+ (void)getPlayerList:(RequestCompleteHandler)handler;

/**
 添加球员
 
 */
+ (void)addPlayer:(PlayerInfo *)playerInfo handler:(RequestCompleteHandler)handler;

/**
 编辑球员信息
 
 */
+ (void)editPlayer:(PlayerInfo *)playerInfo handler:(RequestCompleteHandler)handler;

/**
 删除球员
 
 */
+ (void)deletePlayer:(NSInteger)playerId handler:(RequestCompleteHandler)handler;

@end
