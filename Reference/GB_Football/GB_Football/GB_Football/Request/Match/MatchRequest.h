//
//  MatchRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "MatchResponseInfo.h"
#import "MatchNearByListResponseInfo.h"
#import "MatchTimeDivisionResponseInfo.h"
#import "MatchPlayerBehaviourResponseInfo.h"
#import "MatchDoingResponseInfo.h"
#import "MatchDoingFriendResponseInfo.h"
#import "LineUpModel.h"
#import "LineUpPlayerModel.h"
#import "MatchUploadPhotoResponse.h"
#import "MatchDetailPhotoResponse.h"

@interface MatchRequest : BaseNetworkRequest

//创建比赛
+ (void)addMatch:(MatchInfo *)matchObj friendList:(NSArray<NSNumber *> *)friendList tractics:(TracticsType)tracticsType tracticsPlayerList:(NSArray<NSArray<LineUpPlayerModel *> *> *)tracticsPlayerList handler:(RequestCompleteHandler)handler;

// 查看附近比赛
+ (void)getNearByMatch:(CLLocationCoordinate2D)location handler:(RequestCompleteHandler)handler;

// 完成比赛信息
+ (void)commitMatchComplete:(MatchDoingInfo *)matchObj handler:(RequestCompleteHandler)handler;

// 参与者完成比赛信息
+ (void)guestCommitMatchComplete:(MatchDoingInfo *)matchObj handler:(RequestCompleteHandler)handler;

// 完成分时比赛信息
+ (void)commitTimeDivisionMatchComplete:(MatchDoingInfo *)matchObj handler:(RequestCompleteHandler)handler;

//上传比赛图片
+ (void)uploadMatchPhoto:(id)image handler:(RequestCompleteHandler)handler;

//上传比赛视频
+ (void)uploadMatchVideo:(NSData *)data handler:(RequestCompleteHandler)handler;

// 查看比赛数据
+ (void)getMatchData:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler;

// 查看比赛图片
+ (void)getMatchData:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

/**
 获取比赛的分时数据

 @param handler 比赛id
 @param handler 请求完成回调
 */
+ (void)getMatchTimeDivesionWithMatchId:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler;

/**
 获取比赛球员表现
 
 @param handler 比赛id
 @param handler 请求完成回调
 */
+ (void)getMatchPlayerBehaviourWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;


// 删除比赛数据
+ (void)deleteMatchData:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

// 删除比赛
+ (void)deleteMatch:(NSInteger)matchId isCreator:(BOOL)isCreator handler:(RequestCompleteHandler)handler;

// 同步比赛数据
+ (void)syncMatchData:(NSInteger)matchId data:(NSData *)data isCreateror:(BOOL)isCreateror handler:(RequestCompleteHandler)handler;

// 同步比赛原始数据
+ (void)syncMatchSourceData:(NSInteger)matchId data:(NSData *)data handler:(RequestCompleteHandler)handler;

//获取待完成比赛信息
+ (void)getMatchDoingInfoWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

//获取待完成比赛邀请的好友状态
+ (void)getMatchDoingFriendListWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

// 将好友从比赛中剔除
+ (void)kickedOutFriend:(NSInteger)friendId matchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

/**
 invite friend join match game

 @param friendIdList friend id list
 @param matchId match game id
 @param handler call back
 */
+ (void)inviteFriends:(NSArray<NSNumber *> *)friendIdList matchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;


/**
 invited friend join match game

 @param matchId match id
 @param handler call back
 */
+ (void)joinMatchWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

/**
 获取球队比赛邀请列表
 
 */
+ (void)getTeamGameInviteList:(RequestCompleteHandler)handler;

@end
