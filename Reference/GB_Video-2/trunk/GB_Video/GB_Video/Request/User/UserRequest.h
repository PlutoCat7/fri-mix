//
//  UserRequest.h
//  GB_Video
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "UserResponse.h"

@interface UserRequest : BaseNetworkRequest

/**
 * 用户注册
 * @param phone 帐号
 * @param password 密码
 * @param verificationCode 验证码
 */
+ (void)userRegister:(NSString *)phone password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

/**
 * 用户登录
 */
+ (void)userLogin:(NSString *)phone password:(NSString *)password handler:(RequestCompleteHandler)handler;

/**
 * 获取用户信息
 */
+ (void)getUserInfoWithHandler:(RequestCompleteHandler)handler;

/**
 * 用户信息更新
 */
+ (void)updateUserInfo:(UserInfo *)userObj handler:(RequestCompleteHandler)handler;

/**
 * 忘记密码
 * @param phone 帐号
 * @param newPassword 新密码
 * @param verificationCode 验证码
 */
+ (void)resetUserPassword:(NSString *)phone newPassword:(NSString *)newPassword verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

/**
 *  修改密码
 *  @param  oldPassword   旧密码
 *  @param  newPassword   新密码
 */
+ (void)modifyUserPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword handler:(RequestCompleteHandler)handler;

/**
 * 帐号修改
 * @param phone 帐号
 * @param password 密码
 * @param verificationCode 验证码
 */
+ (void)modifyUserPhone:(NSString *)phone password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler;

/**
 获取短信验证码
 */
+ (void)getVerificationCodeWithPhone:(NSString *)phone handler:(RequestCompleteHandler)handler;

@end
