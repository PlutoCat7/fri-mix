//
//  UserRequest.h
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"

#import "UserResponseInfo.h"

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
+ (void)userRegister:(NSString *)loginId password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

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
+ (void)modifyUserPhone:(NSString *)phone password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

/**
 * 获取验证码
 * @param loginId 帐号
 */
+ (void)pushVerificationCode:(NSString *)loginId handler:(RequestCompleteHandler)handler;

@end
