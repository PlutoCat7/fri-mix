//
//  UserRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/16.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "UserResponseInfo.h"
#import "AddressListResponse.h"
#import "AreaDataResponse.h"
#import "AttachmentResponse.h"
#import "AttendanceSituationResponse.h"

@interface UserRequest : BaseNetworkRequest

/**
 * 用户登录
 * @param loginId 帐号
 * @param code 验证码
 */
+ (void)userLogin:(NSString *)loginId code:(NSString *)code handler:(RequestCompleteHandler)handler;

/**
 * 用户注册
 */
+ (void)userRegister:(NSString *)loginId code:(NSString *)code registerType:(NSString *)registerType fromMobile:(NSString *)fromMobile handler:(RequestCompleteHandler)handler;

/**
 更新用户信息

 */
+ (void)refreshUserInfoWithHandler:(RequestCompleteHandler)handler;

/**
 * 用户补充
 */
+ (void)userSupplement:(NSString *)cer_corp cer_no:(NSString *)cer_no cer_person:(NSString *)cer_person cer_addr:(NSString *)cer_addr cer_pic1_id:(NSString *)cer_pic1_id handler:(RequestCompleteHandler)handler;

/**
 设置用户昵称

 @param nick 昵称
 */
+ (void)saveUserNick:(NSString *)nick handler:(RequestCompleteHandler)handler;

/**
 设置用户头像

 @param avatorId 头像id
 */
+ (void)saveUserAvatorId:(NSString *)avatorId handler:(RequestCompleteHandler)handler;

/**
 上次图片文件
 
 @param image 图片
 */
+ (void)uploadImageWithImage:(UIImage *)image handler:(RequestCompleteHandler)handler;

/**
 获取收货地址列表
 */
+ (void)getAddressListWithHandler:(RequestCompleteHandler)handler;

+ (void)setDefaultAddressWithAddressId:(NSString *)addresId handler:(RequestCompleteHandler)handler;

+ (void)deleteAddressWithAddressId:(NSString *)addresId handler:(RequestCompleteHandler)handler;

+ (void)saveAddressWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address province:(NSString *)province city:(NSString *)city area:(NSString *)area addressId:(NSString *)addressId handler:(RequestCompleteHandler)handler;

+ (void)getAreaDataWithHandler:(RequestCompleteHandler)handler;

#pragma mark - 签到

/**
 获取当前月签到信息

 */
+ (void)getAttendanceDataWithHandler:(RequestCompleteHandler)handler;

/**
 对今天进行签到
 
 */
+ (void)doAttendanceWithHandler:(RequestCompleteHandler)handler;

@end
