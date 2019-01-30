//
//  CommonRequest.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/8/16.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "CommonRequest.h"

@implementation CommonRequest

+ (void)getRegisterSMSCodeWithMobile:(NSString *)mobile captcha:(CaptchaInfo *)captchaInfo handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"sms1",
                                 @"do":@"pub",
                                 @"mobile":mobile,
                                 @"captchaId":@(captchaInfo.captchaId),
                                 @"captchaInput":captchaInfo.imageCode};
    
    [self POSTWithParameters:parameters responseClass:[SMSVerificationCodeResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            SMSVerificationCodeResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getLoginSMSCodeWithMobile:(NSString *)mobile captcha:(CaptchaInfo *)captchaInfo handler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"sms2",
                                 @"do":@"pub",
                                 @"mobile":mobile,
                                 @"captchaId":@(captchaInfo.captchaId),
                                 @"captchaInput":captchaInfo.imageCode};
    
    [self POSTWithParameters:parameters responseClass:[SMSVerificationCodeResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            SMSVerificationCodeResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

//获取注册的图形验证码
+ (void)getRegisterImageCodeWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"captcha",
                                 @"do":@"pub",
                                 @"svc":@(1)};
    
    [self POSTWithParameters:parameters responseClass:[CaptchaResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            CaptchaResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

//获取登录的图形验证码
+ (void)getLoginImageCodeWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"captcha",
                                 @"do":@"pub",
                                 @"svc":@(2)};
    
    [self POSTWithParameters:parameters responseClass:[CaptchaResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            CaptchaResponse *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getConfigWithHandler:(RequestCompleteHandler)handler {
    
    NSDictionary *parameters = @{@"act":@"common",
                                 @"do":@"pub"};
    
    [self POSTWithParameters:parameters responseClass:[COSConfigResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            COSConfigResponse *info = result;
            [info saveCache];
            [RawCacheManager sharedRawCacheManager].config = info.data;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

@end
