//
//  UserRequest.m
//  GB_Team
//
//  Created by weilai on 16/9/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UserRequest.h"

@implementation UserRequest


+ (void)userLogin:(NSString *)loginId password:(NSString *)password handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/login";
    NSDictionary *parameters = @{@"phone":loginId,
                                 @"password":[password MD5]};
    
    [self POST:urlString parameters:parameters responseClass:[UserResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponseInfo *userResponseInfo = (UserResponseInfo *)result;
            [RawCacheManager sharedRawCacheManager].userInfo = userResponseInfo.data;
            BLOCK_EXEC(handler, userResponseInfo.data, nil);
        }
    }];
}

+ (void)userRegister:(NSString *)loginId password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/register";
    NSDictionary *parameters = @{@"phone":loginId,
                                 @"password":[password MD5],
                                 @"verify_code":verificationCode};
    
    [self POST:urlString parameters:parameters responseClass:[UserResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponseInfo *userResponseInfo = (UserResponseInfo *)result;
            [RawCacheManager sharedRawCacheManager].userInfo = userResponseInfo.data;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)resetLoginPassword:(NSString *)loginId newPassword:(NSString *)newPassword verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/forgetpd";
    NSDictionary *parameters = @{@"phone":loginId,
                                 @"password":[newPassword MD5],
                                 @"verify_code":verificationCode};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)updateLoginPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/uppass";
    NSDictionary *parameters = @{@"password":[oldPassword MD5],
                                 @"new_password":[newPassword MD5]};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)modifyUserPhone:(NSString *)phone password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/upphone";
    NSDictionary *parameters = @{@"ch_phone":phone,
                                 @"password":[password MD5],
                                 @"verify_code":verificationCode};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].lastAccount = phone;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)pushVerificationCode:(NSString *)loginId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"verify_code/verify";
    NSDictionary *parameters = @{@"phone":loginId};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

@end
