//
//  TeamRequest.m
//  GB_Football
//
//  Created by gxd on 17/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TeamRequest.h"
#import "TeamLogoUploadResponeInfo.h"
#import "TeamListResponseInfo.h"

@implementation TeamRequest

+ (void)createTeamInfo:(TeamInfo *)teamInfo handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_manage_controller/docreateteam";
    NSDictionary *parameters = @{@"create_team_time":@(teamInfo.foundTime),
                                 @"team_name":teamInfo.teamName == nil ? @"" : teamInfo.teamName,
                                 @"city_id":@(teamInfo.cityId),
                                 @"province_id":@(teamInfo.provinceId),
                                 @"team_mess":teamInfo.teamInstr == nil ? @"" : teamInfo.teamInstr};
    
    [self POST:urlString parameters:parameters responseClass:[TeamResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamResponseInfo *info = result;
            UserInfo *userInfo = [RawCacheManager sharedRawCacheManager].userInfo;
            userInfo.team_mess = [teamInfo copy];
            userInfo.team_mess.teamId = info.data.teamId;
            userInfo.team_mess.leaderId = userInfo.userId;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)modifyTeamInfo:(TeamInfo *)teamInfo handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_manage_controller/upteam";
    NSDictionary *parameters = @{@"create_team_time":@(teamInfo.foundTime),
                                 @"team_name":teamInfo.teamName == nil ? @"" : teamInfo.teamName,
                                 @"city_id":@(teamInfo.cityId),
                                 @"province_id":@(teamInfo.provinceId),
                                 @"team_mess":teamInfo.teamInstr == nil ? @"" : teamInfo.teamInstr};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)disbandTeam:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_manage_controller/removeteam";
    
    [self POST:urlString parameters:nil responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo.team_mess = nil;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)quitTeam:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_manage_controller/outteam";
    
    [self POST:urlString parameters:nil responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            [RawCacheManager sharedRawCacheManager].userInfo.team_mess = nil;
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)uploadTeamLogo:(UIImage *)image handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/dosetteamicon";
    
    [self POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/png"];
    } progress:nil responseClass:[TeamLogoUploadResponeInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamLogoUploadResponeInfo *info = (TeamLogoUploadResponeInfo *)result;
            BLOCK_EXEC(handler, info.data.imageUrl, nil);
        }
    }];
}

+ (void)getTeamInfo:(NSInteger)teamId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/getteamexplain";
    NSDictionary *parameters = @{@"sea_team_id":@(teamId)};
    
    [self POST:urlString parameters:parameters responseClass:[TeamHomeResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamHomeResponeInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)recommendTeamList:(NSArray *)phoneArray handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_manage_controller/getteamlist";
    NSString *phones = @"";
    for (int index = 0; phoneArray && index < [phoneArray count]; index++) {
        NSString *phone = phoneArray[index];
        phones = [phones stringByAppendingString:phone];
        if (index != [phoneArray count] - 1) {
            phones = [phones stringByAppendingString:@","];
        }
    }
    NSDictionary *parameters = @{@"addr_phones":phones};
    
    [self POST:urlString parameters:parameters responseClass:[TeamListResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamListResponseInfo *responeInfo = (TeamListResponseInfo *)result;
            BLOCK_EXEC(handler, responeInfo.data, nil);
        }
    }];
}

+ (void)disposeUserInvite:(NSInteger)userId agree:(BOOL)agree handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/opeapply";
    NSDictionary *parameters = @{@"ope_user_id":@(userId),
                                 @"ope_type":agree?@(1):@(2)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getTeamNewTeammateInfoWithHandler:(RequestCompleteHandler)handler {

    NSString *urlString = @"team_manage_controller/opelist";
    
    [self POST:urlString parameters:nil responseClass:[TeamNewTeammateResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamNewTeammateResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)inviteNewTeammate:(NSInteger)userId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/doinviteplayer";
    NSDictionary *parameters = @{@"ope_user_id":@(userId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)acceptTeamInviteWithTeamId:(NSInteger)teamId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/dopassinvite";
    NSDictionary *parameters = @{@"team_id":@(teamId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)applyTeamJoinWithTeamId:(NSInteger)teamId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/addteamapply";
    NSDictionary *parameters = @{@"team_id":@(teamId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)kickedOutTeammate:(NSInteger)userId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/dismissplayer";
    NSDictionary *parameters = @{@"ope_user_id":@(userId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)appointViceCaptain:(NSInteger)userId isAppoint:(BOOL)isAppoint handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/doappoint";
    NSDictionary *parameters = @{@"ope_user_id":@(userId),
                                 @"type":isAppoint?@(1):@(2)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)appointCaptain:(NSInteger)userId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_manage_controller/dotranleader";
    NSDictionary *parameters = @{@"ope_user_id":@(userId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)savaLineUpWithId:(NSInteger)tracticsId context:(NSDictionary *)context handler:(RequestCompleteHandler)handler{
    
    NSDictionary *parameters = nil;
    if (context.count == 0) {
        parameters = @{@"form_id":@(tracticsId)};
    }else {
        NSData *parseData = [NSJSONSerialization dataWithJSONObject:context options:0 error:nil];
        NSString *dataString = [[NSString alloc] initWithData:parseData encoding:NSUTF8StringEncoding];
        parameters = @{@"form_id":@(tracticsId),
                       @"form_json":dataString};
    }
    
    NSString *urlString = @"team_manage_controller/setformation";
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getLineUpInfoWithId:(NSInteger)tracticsId handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"team_manage_controller/viewFormation";
    NSDictionary *parameters = @{@"form_id":@(tracticsId)};
    
    [self POST:urlString parameters:parameters responseClass:[TeamLineUpResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamLineUpResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)addTacticsWithName:(NSString *)tacticsName playerNum:(NSInteger)playerNum jsonDataString:(NSString *)jsonDataString handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"tactics_manage_controller/doaddtactics";
    NSDictionary *parameters = @{@"tactics_name":tacticsName,
                                 @"people_num":@(playerNum),
                                 @"tactics_mess":jsonDataString
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)modifyTacticsWithId:(NSInteger)tacticsId tacticsName:(NSString *)tacticsName playerNum:(NSInteger)playerNum jsonDataString:(NSString *)jsonDataString handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"tactics_manage_controller/uptactics";
    NSDictionary *parameters = @{@"id":@(tacticsId),
                                 @"tactics_name":tacticsName,
                                 @"people_num":@(playerNum),
                                 @"tactics_mess":jsonDataString
                                 };
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)deleteTacticsWithId:(NSInteger)tacticsId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"tactics_manage_controller/deltactics";
    NSDictionary *parameters = @{@"id":@(tacticsId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)downloadTacticsDataWithUrl:(NSString *)tacticsUrl handler:(RequestCompleteHandler)handler {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tacticsUrl]];
    
    NSURLSessionDownloadTask *downloadTask = [[NetworkManager downloadManager] downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
#warning 下次打开app是否被清除了
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (handler) {
            NSData *data = [[NSData alloc]initWithContentsOfURL:filePath];
            id object = [YAHJSONAdapter objectFromJsonData:data objectClass:[TacticsJsonModel class]];
            
            handler(object, error);
        }
    }];
    
    [downloadTask resume];
}

+ (void)getTeamMatchPlayerDataWithId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"match_manage_controller/dogetteammatchdata";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[TeamMatchRecordDataResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamMatchRecordDataResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getTeamDataWithId:(NSInteger)teamId handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"team_manage_controller/getteamdata";
    NSDictionary *parameters = @{@"team_id":@(teamId)};
    
    [self POST:urlString parameters:parameters responseClass:[TeamDataResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamDataResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)deleteTeamMatchWithId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"match_manage_controller/doDelTeamMatch";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getTeamRankList:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_manage_controller/dotoplistbyscore";
    
    [self POST:urlString parameters:nil responseClass:[TeamRankResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamRankResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}


@end
