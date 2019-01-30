//
//  LogicManager.h
//  GB_Football
//
//  Created by wsw on 16/8/5.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LogicManager : NSObject

+ (BOOL)checkIsOpenCamera;
+ (BOOL)checkIsOpenAblum;

/**
 验证手机号是否有效  手机号规则：1开头的11位纯数字
 
 */
+ (BOOL)isPhoneBumber:(NSString *)phone;

/**
 验证码是否有效  大于1位小于10位

 */
+ (BOOL)isValidInputCode:(NSString *)code;

/**
 用户是否登录了， 未登录弹出提示框

 */
+ (BOOL)isUserLogined;

+ (void)pushLoginViewControllerWithNav:(UINavigationController *)nav;

@end
