//
//  TeamRequest.h
//  GB_Team
//
//  Created by weilai on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"

#import "TeamResponseInfo.h"
#import "TeamAddResponeInfo.h"

@interface TeamRequest : BaseNetworkRequest

// 球队列表
+ (void)getTeamListWithHandler:(RequestCompleteHandler)handler;

// 添加球队
+ (void)addTeam:(NSString *)teamName handler:(RequestCompleteHandler)handler;

// 删除球队
+ (void)deleteTeam:(NSInteger)teamId handler:(RequestCompleteHandler)handler;

// 球队球员列表
+ (void)getTeamMemberWithTeamId:(NSInteger)teamId handler:(RequestCompleteHandler)handler;

// 添加球员到球队
+ (void)addPlayerToTeam:(NSInteger)teamId playerList:(NSArray *)playerList handler:(RequestCompleteHandler)handler;

// 从球队删除球员
+ (void)deletePlayerFromTeam:(NSInteger)teamId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler;

@end
