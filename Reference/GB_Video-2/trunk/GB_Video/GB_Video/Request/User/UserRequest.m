//
//  UserRequest.m
//  GB_Video
//
//  Created by yahua on 2018/1/29.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "UserRequest.h"
#import "GBResponseInfo.h"

@implementation UserRequest

+ (void)userRegister:(NSString *)phone password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/register";
    NSDictionary *parameters = @{@"phone":phone,
                                 @"password":[password MD5],
                                 @"verify_code":verificationCode};
    
    [self POST:urlString parameters:parameters responseClass:[UserResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponse *userResponseInfo = (UserResponse *)result;
            [RawCacheManager sharedRawCacheManager].userInfo = userResponseInfo.data;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)userLogin:(NSString *)phone password:(NSString *)password handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/loginByPassword";
    NSDictionary *parameters = @{@"phone":phone,
                                 @"password":[password MD5]};
    
    [self POST:urlString parameters:parameters responseClass:[UserResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponse *userResponseInfo = (UserResponse *)result;
            [RawCacheManager sharedRawCacheManager].userInfo = userResponseInfo.data;
            BLOCK_EXEC(handler, userResponseInfo.data, nil);
        }
    }];
}

+ (void)getUserInfoWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/getInfo";
    
    [self POST:urlString parameters:nil responseClass:[UserResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserResponse *userResponseInfo = (UserResponse *)result;
            [RawCacheManager sharedRawCacheManager].userInfo = userResponseInfo.data;
            BLOCK_EXEC(handler, userResponseInfo.data, nil);
        }
    }];
}

+ (void)updateUserInfo:(UserInfo *)userObj handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/updateInfo";
    NSDictionary *parameters = @{@"sex":@(userObj.sexType),
                                 @"nick_name":userObj.nick == nil ? @"" : userObj.nick,
                                 @"image_url":userObj.imageUrl == nil ? @"" : userObj.imageUrl,
                                 @"province_id":@(userObj.provinceId),
                                 @"city_id":@(userObj.cityId),
                                 @"region_id":@(userObj.regionId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo = userObj;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)resetUserPassword:(NSString *)phone newPassword:(NSString *)newPassword verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/forgetPassword";
    NSDictionary *parameters = @{@"phone":phone,
                                 @"password":[newPassword MD5],
                                 @"verify_code":verificationCode};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].lastAccount = phone;
            [RawCacheManager sharedRawCacheManager].lastPassword = nil;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)modifyUserPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/modifyPassword";
    NSDictionary *parameters = @{@"password":[oldPassword MD5],
                                 @"new_password":[newPassword MD5]};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            //更新密码
            [RawCacheManager sharedRawCacheManager].lastPassword = newPassword;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)modifyUserPhone:(NSString *)phone password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user/modifyPhone";
    NSDictionary *parameters = @{@"phone":phone,
                                 @"password":[password MD5],
                                 @"verify_code":verificationCode};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].lastAccount = phone;
            
            UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
            userInfo.phone = phone;
            [RawCacheManager sharedRawCacheManager].userInfo = userInfo;
            
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getVerificationCodeWithPhone:(NSString *)phone handler:(RequestCompleteHandler)handler; {
    
    NSString *urlString = @"common/getVerifyCode";
    NSDictionary *parameters = @{@"phone":phone};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

@end
