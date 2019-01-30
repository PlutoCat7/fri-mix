//
//  UserRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"

#import "UserResponseInfo.h"
#import "PlayerStarResponeInfo.h"
#import "UserImageUploadResponeInfo.h"
#import "DailyRankResponeInfo.h"
#import "HistoryRankResponeInfo.h"
#import "MatchRankResponeInfo.h"
#import "PlayerRankResponeInfo.h"

@interface UserRequest : BaseNetworkRequest

/**
 * 用户登录
 * @param loginId 帐号
 * @param password 密码
 */
+ (void)userLogin:(NSString *)loginId password:(NSString *)password handler:(RequestCompleteHandler)handler;

/**
 * 用户注册
 * @param loginId 帐号
 * @param password 新密码
 * @param verificationCode 验证码
 */
+ (void)userRegister:(NSString *)loginId areaType:(AreaType)areaType password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

/**
 * 获取用户信息
 */
+ (void)getUserInfoWithHandler:(RequestCompleteHandler)handler;

/**
 * 忘记密码
 * @param loginId：帐号
 * @param newPassword 新密码
 * @param verificationCode 验证码
 */
+ (void)resetLoginPassword:(NSString *)loginId newPassword:(NSString *)newPassword verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

/**
 *  修改密码
 *  @param  oldPassword   旧密码
 *  @param  newPassword   新密码
 */
+ (void)updateLoginPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword handler:(RequestCompleteHandler)handler;

/**
 * 帐号修改
 * @param phone：帐号
 * @param password：密码
 * @param verificationCode：验证码
 */
+ (void)modifyUserPhone:(NSString *)phone areaType:(AreaType)areaType password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

/**
 * 昵称检查
 * @param nickName 昵称
 */
+ (void)checkUserNickName:(NSString *)nickName handler:(RequestCompleteHandler)handler;

/**
 * 用户信息更新
 */
+ (void)updateUserInfo:(UserInfo *)userObj handler:(RequestCompleteHandler)handler;

/**
 * 用户配置信息更新
 * @param distance 步数
 */
+ (void)updateUserConfig:(NSInteger)distance handler:(RequestCompleteHandler)handler;

/**
 * 用户配置信息更新
 * @param matchAddDaily 比赛步数是否加入到日常
 */
+ (void)updateUserConfigMatchAddDaily:(NSInteger)matchAddDaily handler:(RequestCompleteHandler)handler;

/**
 * 获取验证码
 * @param loginId 帐号
 */
+ (void)pushVerificationCode:(NSString *)loginId areaType:(AreaType)areaType handler:(RequestCompleteHandler)handler;

/**
 * 获取球星卡信息
 * @param userId 球星id
 */
+ (void)getPlayerStarInfo:(NSInteger)userId handler:(RequestCompleteHandler)handler;

/**
 * 用户头像上传
 */
+ (void)uploadUserPhoto:(UIImage *)image handler:(RequestCompleteHandler)handler;

/**
 * 获取用户日常排行
 * @param type （long）1.距离降序 2.体能排序 3.步数降序
 * @param grouptype （long）1.按周分组 2.按月分组 3.按日分组
 */
+ (void)getDailyChartObj:(DailyRank)type gtype:(DailyGroup)groupType handle:(RequestCompleteHandler)handler;

/**
 * 历史之最排行
 * @param type 1 单场移动距离,2 单场体能消耗 3 单场最高速度
 */
+ (void)getHistoryChartObj:(MatchRank)type handle:(RequestCompleteHandler)handler;

/**
 * 本轮排行
 * @param type 1 单场移动距离,2 单场体能消耗 3 单场最高速度
 */
+ (void)getMatchChartObj:(MatchRank)type handle:(RequestCompleteHandler)handler;

/**
 * 球员数据排行
 * @param type
 */
+ (void)getPlayerChartObj:(PlayerRank)type handle:(RequestCompleteHandler)handler;
    
@end
