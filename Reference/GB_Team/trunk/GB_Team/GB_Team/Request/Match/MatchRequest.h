//
//  MatchRequest.h
//  GB_Team
//
//  Created by weilai on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "MatchBindInfo.h"
#import "MatchDetailResponseInfo.h"
#import "MatchBindResponseInfo.h"
#import "MatchCreateResponseInfo.h"
#import "MatchLocationResponseInfo.h"

@interface MatchRequest : BaseNetworkRequest

// 上传用户的比赛绑定信息
+ (void)uploadMatchBindInfo:(MatchBindInfo *)matchBindInfo handler:(RequestCompleteHandler)handler;

// 获取用户的比赛绑定信息
+ (void)getMatchBindInfo:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

/**
 同步比赛数据

 @param matchId 比赛id
 @param playerId 球员id
 @param originData 原始数据
 @param data 处理后的数据
 */
+ (void)syncMatchDataWithMatchId:(NSInteger)matchId palyerId:(NSInteger)playerId originData:(NSData *)originData handleData:(NSData *)handleData handler:(RequestCompleteHandler)handler;

// 删除用户的比赛绑定信息
+ (void)delMatchBindInfo:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

// 完成比赛信息
+ (void)commitMatchComplete:(MatchInfo *)matchBindInfo handler:(RequestCompleteHandler)handler;

// 删除比赛记录
+ (void)delMatch:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

// 获取详细比赛数据
+ (void)getMatchInfo:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

// 获取比赛的坐标数据
+ (void)getMatchLocData:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler;

// 发送短信,playerId为0表示发全场球员短信
+ (void)sendMatchShortMessage:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler;

@end
