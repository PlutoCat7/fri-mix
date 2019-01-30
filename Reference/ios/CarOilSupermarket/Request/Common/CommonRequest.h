//
//  CommonRequest.h
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/16.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "SMSVerificationCodeResponse.h"
#import "CaptchaResponse.h"
#import "COSConfigResponse.h"

@interface CommonRequest : BaseNetworkRequest

//获取注册的手机验证码
+ (void)getRegisterSMSCodeWithMobile:(NSString *)mobile captcha:(CaptchaInfo *)captchaInfo handler:(RequestCompleteHandler)handler;

//获取登录的手机验证码
+ (void)getLoginSMSCodeWithMobile:(NSString *)mobile captcha:(CaptchaInfo *)captchaInfo handler:(RequestCompleteHandler)handler;

//获取注册的图形验证码
+ (void)getRegisterImageCodeWithHandler:(RequestCompleteHandler)handler;

//获取登录的图形验证码
+ (void)getLoginImageCodeWithHandler:(RequestCompleteHandler)handler;

//获取配置信息
+ (void)getConfigWithHandler:(RequestCompleteHandler)handler;

@end
