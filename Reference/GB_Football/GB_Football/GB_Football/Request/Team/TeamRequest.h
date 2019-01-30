//
//  TeamRequest.h
//  GB_Football
//
//  Created by gxd on 17/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "TeamResponseInfo.h"
#import "TeamHomeResponeInfo.h"
#import "TeamNewTeammateResponseInfo.h"
#import "TeamLineUpResponseInfo.h"
#import "TeamMatchRecordDataResponseInfo.h"
#import "TeamDataResponseInfo.h"
#import "TeamRankResponseInfo.h"

#import "TacticsJsonModel.h"

@interface TeamRequest : BaseNetworkRequest

/**
 * 添加球队
 */
+ (void)createTeamInfo:(TeamInfo *)teamInfo handler:(RequestCompleteHandler)handler;

/**
 * 修改球队
 */
+ (void)modifyTeamInfo:(TeamInfo *)teamInfo handler:(RequestCompleteHandler)handler;

/**
 * 解散球队
 */
+ (void)disbandTeam:(RequestCompleteHandler)handler;

/**
 * 退出球队
 */
+ (void)quitTeam:(RequestCompleteHandler)handler;

/**
 * 球队队徽上传
 */
+ (void)uploadTeamLogo:(UIImage *)image handler:(RequestCompleteHandler)handler;

/**
 * 获取球队信息
 */
+ (void)getTeamInfo:(NSInteger)teamId handler:(RequestCompleteHandler)handler;

/**
 * 推荐球队
 */
+ (void)recommendTeamList:(NSArray *)phoneArray handler:(RequestCompleteHandler)handler;

/**
 处理加入球队申请

 @param userId 申请者id
 @param agree 是否同意
 */
+ (void)disposeUserInvite:(NSInteger)userId agree:(BOOL)agree handler:(RequestCompleteHandler)handler;

/**
 * 获取新队员信息
 */
+ (void)getTeamNewTeammateInfoWithHandler:(RequestCompleteHandler)handler;

/**
 邀请新队员

 @param userId 新队员user id
 */
+ (void)inviteNewTeammate:(NSInteger)userId handler:(RequestCompleteHandler)handler;

/**
 用户接受球队邀请，加入球队

 @param teamId 球队id
 */
+ (void)acceptTeamInviteWithTeamId:(NSInteger)teamId handler:(RequestCompleteHandler)handler;

/**
 用户申请加入球队

 @param teamId 球队id
 */
+ (void)applyTeamJoinWithTeamId:(NSInteger)teamId handler:(RequestCompleteHandler)handler;

/**
 踢出队员
 
 @param userId 队员的user Id
 */
+ (void)kickedOutTeammate:(NSInteger)userId handler:(RequestCompleteHandler)handler;

/**
 任命和解除副队长
 
 @param userId 队员的user Id
 @param isAppoint  yes:任命   no:解除
 */
+ (void)appointViceCaptain:(NSInteger)userId isAppoint:(BOOL)isAppoint handler:(RequestCompleteHandler)handler;

/**
 任命为队长
 
 @param userId 队员的user Id
 */
+ (void)appointCaptain:(NSInteger)userId handler:(RequestCompleteHandler)handler;

/**
 保存阵型

 @param tracticsId 阵型id
 @param context 阵型内容
 */
+ (void)savaLineUpWithId:(NSInteger)tracticsId context:(NSDictionary *)context handler:(RequestCompleteHandler)handler;

/**
 获取阵型详情
 
 @param tracticsId 阵型id
 */
+ (void)getLineUpInfoWithId:(NSInteger)tracticsId handler:(RequestCompleteHandler)handler;

/**
 添加战术

 @param tacticsName 战术名称
 @param playerNum 球员个数
 @param jsonDataString 战术数据json string
 */
+ (void)addTacticsWithName:(NSString *)tacticsName playerNum:(NSInteger)playerNum jsonDataString:(NSString *)jsonDataString handler:(RequestCompleteHandler)handler;

/**
 修改战术
 
 @param tacticsId 战术id
 @param tactics_name 战术名称
 @param playerNum 球员个数
 @param jsonDataString 战术数据json string
 */
+ (void)modifyTacticsWithId:(NSInteger)tacticsId tacticsName:(NSString *)tacticsName playerNum:(NSInteger)playerNum jsonDataString:(NSString *)jsonDataString handler:(RequestCompleteHandler)handler;

/**
 删除战术

 @param tacticsId 战术id
 */
+ (void)deleteTacticsWithId:(NSInteger)tacticsId handler:(RequestCompleteHandler)handler;

/**
 战术数据下载

 @param tacticsUrl 战术数据url
 @param handler 返回回调， 成功返回TacticsJsonModel 对象
 */
+ (void)downloadTacticsDataWithUrl:(NSString *)tacticsUrl handler:(RequestCompleteHandler)handler;

/**
 获取球队单场比赛数据
 
 @param matchId 比赛id
 */
+ (void)getTeamMatchPlayerDataWithId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

/**
 获取球队数据
 
 @param teamId 球队id
 */
+ (void)getTeamDataWithId:(NSInteger)teamId handler:(RequestCompleteHandler)handler;


/**
 删除比赛记录
 
 @param matchId 比赛id
 */
+ (void)deleteTeamMatchWithId:(NSInteger)matchId handler:(RequestCompleteHandler)handler;

/**
 获取球队排行列表
 
 */
+ (void)getTeamRankList:(RequestCompleteHandler)handler;

@end
