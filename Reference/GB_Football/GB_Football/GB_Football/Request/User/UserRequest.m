//
//  UserRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UserRequest.h"


@implementation UserRequest

+ (void)userLogin:(NSString *)loginId password:(NSString *)password handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_login_controller/dologin";
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

+ (void)userRegister:(NSString *)loginId areaType:(AreaType)areaType password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_register_controller/doregister";
    NSDictionary *parameters = @{@"phone":loginId,
                                 @"region_code":@(areaType),
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

+ (void)getUserInfoWithHandler:(RequestCompleteHandler)handler {

    NSString *urlString = @"user_info_controller/doinfo";
    
    [self POST:urlString parameters:nil responseClass:[UserResponseInfo class] handler:^(id result, NSError *error) {
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
    
    NSString *urlString = @"user_forget_pwd_controller/domodify";
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
    
    NSString *urlString = @"user_password_modify_controller/domodify";
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

+ (void)modifyUserPhone:(NSString *)phone areaType:(AreaType)areaType password:(NSString *)password verificationCode:(NSString *)verificationCode handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"user_phone_update_controller/domodify";
    NSDictionary *parameters = @{@"ch_phone":phone,
                                 @"region_code":@(areaType),
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

+ (void)checkUserNickName:(NSString *)nickName handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"user_nick_name_controller/donickname";
    NSDictionary *parameters = @{@"nick_name":nickName};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo.nick = nickName;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)updateUserInfo:(UserInfo *)userObj handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_update_controller/doupdate";
    NSDictionary *parameters = @{@"sex":@(userObj.sexType),
                                 @"birthday":@(userObj.birthday),
                                 @"weight":@(userObj.weight),
                                 @"height":@(userObj.height),
                                 @"team_no":@(userObj.teamNo),
                                 @"province_id":@(userObj.provinceId),
                                 @"city_id":@(userObj.cityId),
                                 @"region_id":@(userObj.regionId),
                                 @"position":userObj.position == nil ? @"" : userObj.position};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo = userObj;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)updateUserConfig:(NSInteger)distance handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_up_config_controller/doupdate";
    NSDictionary *configs = @{@"step_number_goal":@(distance),
                              @"match_add_dail":@([RawCacheManager sharedRawCacheManager].userInfo.config.match_add_dail)};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configs options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"cfg":!jsonString?@"":jsonString};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}
+ (void)updateUserConfigMatchAddDaily:(NSInteger)matchAddDaily handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_up_config_controller/doupdate";
    NSDictionary *configs = @{@"step_number_goal":@([RawCacheManager sharedRawCacheManager].userInfo.config.stepNumberGoal),
                              @"match_add_dail":@(matchAddDaily)};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configs options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"cfg":!jsonString?@"":jsonString};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo.config.match_add_dail = matchAddDaily;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)pushVerificationCode:(NSString *)loginId areaType:(AreaType)areaType handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"verify_code_controller/doverify";
    NSDictionary *parameters = @{@"phone":loginId,
                                 @"region_code":@(areaType)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getPlayerStarInfo:(NSInteger)userId handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"user_extend_data_controller/doextenddata";
    NSDictionary *parameters = @{@"user_id":@(userId)};
    
    [self POST:urlString parameters:parameters responseClass:[PlayerStarResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            PlayerStarResponeInfo *info = (PlayerStarResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)uploadUserPhoto:(UIImage *)image handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"user_img_upload_controller/up";
    
    [self POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/png"];
    } progress:nil responseClass:[UserImageUploadResponeInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            UserImageUploadResponeInfo *info = (UserImageUploadResponeInfo *)result;
            [RawCacheManager sharedRawCacheManager].userInfo.imageUrl = info.data.imageUrl;
            BLOCK_EXEC(handler, info.data.imageUrl, nil);
        }
    }];
}

+ (void)getDailyChartObj:(DailyRank)type gtype:(DailyGroup)groupType handle:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"user_daily_rank_list_controller/dodailyranklist";
    NSDictionary *parameters = @{@"type":@(type),
                                 @"group_type":@(groupType)};
    
    [self POST:urlString parameters:parameters responseClass:[DailyRankResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            DailyRankResponeInfo *info = (DailyRankResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getHistoryChartObj:(MatchRank)type handle:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"history_most_rank_list_controller/dohistorylist";
    NSDictionary *parameters = @{@"type":@(type)};
    
    [self POST:urlString parameters:parameters responseClass:[HistoryRankResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            HistoryRankResponeInfo *info = (HistoryRankResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}


+ (void)getMatchChartObj:(MatchRank)type handle:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"last_match_rank_list_controller/dolastmatchranklist";
    NSDictionary *parameters = @{@"type":@(type)};
    
    [self POST:urlString parameters:parameters responseClass:[MatchRankResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchRankResponeInfo *info = (MatchRankResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
        
    }];
}
    
+ (void)getPlayerChartObj:(PlayerRank)type handle:(RequestCompleteHandler)handler {
    NSString *urlString = @"user_extend_rank_controller/doranklist";
    NSDictionary *parameters = @{@"type":@(type)};
    
    [self POST:urlString parameters:parameters responseClass:[PlayerRankResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            PlayerRankResponeInfo *info = (PlayerRankResponeInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
        
    }];
}

@end
