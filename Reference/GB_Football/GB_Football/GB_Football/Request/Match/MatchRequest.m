//
//  MatchRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchRequest.h"
#import "TeamMatchInviteResponseInfo.h"

@implementation MatchRequest

+ (void)addMatch:(MatchInfo *)matchObj friendList:(NSArray<NSNumber *> *)friendList tractics:(TracticsType)tracticsType tracticsPlayerList:(NSArray<NSArray<LineUpPlayerModel *> *> *)tracticsPlayerList handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"match_manage_controller/docreate";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"court_id":@(matchObj.courtId),
                                                                                      @"match_name":matchObj.matchName == nil ? @"" : matchObj.matchName,
                                                                                      @"type":@(matchObj.gameType)}];
    NSMutableString *listString = [NSMutableString string];
    for (NSNumber *idNumber in friendList) {
        if ([NSString stringIsNullOrEmpty:listString]) {
            [listString appendString:idNumber.stringValue];
        } else {
            [listString appendFormat:@",%@", idNumber.stringValue];
        }
    }
    if (![NSString stringIsNullOrEmpty:listString]) {
        [parameters setObject:[listString copy] forKey:@"invite_list"];
    }
    if (matchObj.gameType == GameType_Team) {
        [parameters setObject:@(tracticsType) forKey:@"form_id"];
        
        if (tracticsPlayerList && tracticsPlayerList.count > 0) {
            NSMutableDictionary *context = [NSMutableDictionary dictionaryWithCapacity:1];
            [tracticsPlayerList enumerateObjectsUsingBlock:^(NSArray<LineUpPlayerModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj enumerateObjectsUsingBlock:^(LineUpPlayerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.playerInfo) {
                        [context setObject:@(obj.posIndex) forKey:@(obj.playerInfo.user_id).stringValue];
                    }
                }];
            }];
            
            if (context && context.count > 0) {
                NSData *parseData = [NSJSONSerialization dataWithJSONObject:context options:0 error:nil];
                NSString *dataString = [[NSString alloc] initWithData:parseData encoding:NSUTF8StringEncoding];
                [parameters setObject:dataString forKey:@"form_json"];
            }
        }
        
    }
    
    [self POST:urlString parameters:parameters responseClass:[MatchResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchResponseInfo *info = (MatchResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getNearByMatch:(CLLocationCoordinate2D)location handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_near_query_controller/donearquery";
    
    LocationCoordinateInfo *locationInfo = [[LocationCoordinateInfo alloc] initWithLon:location.longitude lat:location.latitude];
    NSDictionary *parameters = @{@"location":locationInfo.locationString};
    
    [self POST:urlString parameters:parameters responseClass:[MatchNearByListResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchNearByListResponseInfo *info = (MatchNearByListResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)commitMatchComplete:(MatchDoingInfo *)matchObj handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_complete_controller/docomplete";
    NSDictionary *parameters = @{@"match_id":@(matchObj.match_id),
                                 @"match_time_a":@(matchObj.firstStartTime),
                                 @"match_time_b":@(matchObj.firstEndTime),
                                 @"match_time_c":@(matchObj.secondStartTime),
                                 @"match_time_d":@(matchObj.secondEndTime),
                                 @"home_score":@(matchObj.homeScore),
                                 @"guest_score":@(matchObj.guestScore),
                                 @"host_team":matchObj.host_team,
                                 @"follow_team":matchObj.follow_team};
    NSMutableDictionary *mutiParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *baseImageKey = @"img_uri_";
    for (NSInteger index=0; index<matchObj.uriList.count; index++) {
        [mutiParameters setObject:[matchObj.uriList objectAtIndex:index] forKey:[NSString stringWithFormat:@"%@%td", baseImageKey, index+1]];
    }
    if (matchObj.videoUriList.count>0) {
        [mutiParameters setObject:matchObj.videoUriList.firstObject forKey:@"video_uri"];
    }
    
    [self POST:urlString parameters:[mutiParameters copy] responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 参与者完成比赛信息
+ (void)guestCommitMatchComplete:(MatchDoingInfo *)matchObj handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/setmatchedMess";
    NSDictionary *parameters = @{@"match_id":@(matchObj.match_id),
                                 @"match_data_time_a":@(matchObj.firstStartTime),
                                 @"match_data_time_b":@(matchObj.firstEndTime),
                                 @"match_data_time_c":@(matchObj.secondStartTime),
                                 @"match_data_time_d":@(matchObj.secondEndTime)};
    NSMutableDictionary *mutiParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *baseImageKey = @"img_uri_";
    for (NSInteger index=0; index<matchObj.uriList.count; index++) {
        [mutiParameters setObject:[matchObj.uriList objectAtIndex:index] forKey:[NSString stringWithFormat:@"%@%td", baseImageKey, index+1]];
    }
    if (matchObj.videoUriList.count>0) {
        [mutiParameters setObject:matchObj.videoUriList.firstObject forKey:@"video_uri"];
    }
    
    [self POST:urlString parameters:[mutiParameters copy] responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)commitTimeDivisionMatchComplete:(MatchDoingInfo *)matchObj handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/docomplete";
    NSNumber *one_start_time = @(0);
    NSNumber *one_end_time = @(0);
    NSNumber *two_start_time = @(0);
    NSNumber *two_end_time = @(0);
    NSNumber *three_start_time = @(0);
    NSNumber *three_end_time = @(0);
    NSNumber *four_start_time = @(0);
    NSNumber *four_end_time = @(0);
    NSNumber *five_start_time = @(0);
    NSNumber *five_end_time = @(0);
    for (NSInteger index=0; index<matchObj.timeDivisionRecordList.count; index++) {
        TimeDivisionRecordInfo *info = matchObj.timeDivisionRecordList[index];
        switch (index) {
            case 0:
                one_start_time = @(info.beginDate.timeIntervalSince1970);
                one_end_time = @(info.endDate.timeIntervalSince1970);
                break;
            case 1:
                two_start_time = @(info.beginDate.timeIntervalSince1970);
                two_end_time = @(info.endDate.timeIntervalSince1970);
                break;
            case 2:
                three_start_time = @(info.beginDate.timeIntervalSince1970);
                three_end_time = @(info.endDate.timeIntervalSince1970);
                break;
            case 3:
                four_start_time = @(info.beginDate.timeIntervalSince1970);
                four_end_time = @(info.endDate.timeIntervalSince1970);
                break;
            case 4:
                five_start_time = @(info.beginDate.timeIntervalSince1970);
                five_end_time = @(info.endDate.timeIntervalSince1970);
                break;
                
            default:
                break;
        }
    }
    NSDictionary *parameters = @{@"match_id":@(matchObj.match_id),
                                 @"one_start_time":one_start_time,
                                 @"one_end_time":one_end_time,
                                 @"two_start_time":two_start_time,
                                 @"two_end_time":two_end_time,
                                 @"three_start_time":three_start_time,
                                 @"three_end_time":three_end_time,
                                 @"four_start_time":four_start_time,
                                 @"four_end_time":four_end_time,
                                 @"five_start_time":five_start_time,
                                 @"five_end_time":five_end_time,
                                 @"home_score":@(matchObj.homeScore),
                                 @"guest_score":@(matchObj.guestScore),
                                 @"host_team":matchObj.host_team,
                                 @"follow_team":matchObj.follow_team};
    NSMutableDictionary *mutiParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *baseImageKey = @"img_uri_";
    for (NSInteger index=0; index<matchObj.uriList.count; index++) {
        [mutiParameters setObject:[matchObj.uriList objectAtIndex:index] forKey:[NSString stringWithFormat:@"%@%td", baseImageKey, index+1]];
    }
    if (matchObj.videoUriList.count>0) {
        [mutiParameters setObject:matchObj.videoUriList.firstObject forKey:@"video_uri"];
    }
    
    [self POST:urlString parameters:[mutiParameters copy] responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

//上传比赛图片
+ (void)uploadMatchPhoto:(id)image handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/uploadImgtooss";
    
    [self POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = image;
        if ([[image class] isKindOfClass:[UIImage class]]) {
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/png"];
    } progress:nil responseClass:[MatchUploadPhotoResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchUploadPhotoResponse *info = (MatchUploadPhotoResponse *)result;
            BLOCK_EXEC(handler, info.data.image_uri, nil);
        }
    }];
}

+ (void)uploadMatchVideo:(NSData *)data handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/uploadImgtooss";
    
    [self POST:urlString parameters:@{@"type":@"1"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"video/mp4"];
    } progress:nil responseClass:[MatchUploadPhotoResponse class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchUploadPhotoResponse *info = (MatchUploadPhotoResponse *)result;
            BLOCK_EXEC(handler, info.data.image_uri, nil);
        }
    }];
}

+ (void)getMatchData:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_info_query_controller/doquery";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"match_id":@(matchId)}];
    if (playerId != 0) {
        [parameters setObject:@(playerId) forKey:@"other_id"];
    }
    
    [self POST:urlString parameters:parameters responseClass:[MatchResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchResponseInfo *info = (MatchResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getMatchData:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/dogetmatchimgvilist";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"match_id":@(matchId)}];
    
    [self POST:urlString parameters:parameters responseClass:[MatchDetailPhotoResponse class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchDetailPhotoResponse *info = (MatchDetailPhotoResponse *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)getMatchTimeDivesionWithMatchId:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"match_time_division_controller/domatchtimedivision";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"match_id":@(matchId)}];
    if (playerId != 0) {
        [parameters setObject:@(playerId) forKey:@"other_id"];
    }
    
    [self POST:urlString parameters:parameters responseClass:[MatchTimeDivisionResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchTimeDivisionResponseInfo *info = (MatchTimeDivisionResponseInfo *)result;
            BLOCK_EXEC(handler, info, nil);
        }
    }];
}

+ (void)getMatchPlayerBehaviourWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/dogetinvitematchdata";
    
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[MatchPlayerBehaviourResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchPlayerBehaviourResponseInfo *info = (MatchPlayerBehaviourResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 删除比赛数据
+ (void)deleteMatchData:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_completed_del_controller/dodelcompleted";
    
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 删除比赛
+ (void)deleteMatch:(NSInteger)matchId isCreator:(BOOL)isCreator handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"";
    if (isCreator) {
        urlString = @"match_del_controller/dodel";
    }else {
        urlString = @"match_manage_controller/myremoveuserinvite";
    }
    
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 同步比赛数据
+ (void)syncMatchData:(NSInteger)matchId data:(NSData *)data isCreateror:(BOOL)isCreateror handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"user_data_sync_controller/dodatasync";
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"match_id":@(matchId),
                                 @"data":dataString
                                 };
    NSMutableDictionary *multiParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (!isCreateror) {
        [multiParameters setObject:@"1" forKey:@"matched_flag"];
    }
    
    [self POST:urlString parameters:[multiParameters copy] responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 同步比赛原始数据
+ (void)syncMatchSourceData:(NSInteger)matchId data:(NSData *)data handler:(RequestCompleteHandler)handler {
    
    if (!data) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
        const unsigned char *szBuffer = [data bytes];
        for (NSInteger i=0; i < [data length]; ++i) {
            [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        }
        
        NSDictionary *parameters = @{@"match_id":@(matchId),
                                     @"data":[strTemp copy]};
        NSString *urlString = @"user_origin_sync_controller/dooriginsync";
        [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    BLOCK_EXEC(handler, nil, error);
                }else {
                    BLOCK_EXEC(handler, nil, nil);
                }
            });
        }];
    });
}

+ (void)getMatchDoingInfoWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/getmatchmess";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[MatchDoingResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchDoingResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data.match_mess, nil);
        }
    }];
}

+ (void)getMatchDoingFriendListWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/getFriStaList";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[MatchDoingFriendResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchDoingFriendResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)kickedOutFriend:(NSInteger)friendId matchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/removeuserinvite";
    NSDictionary *parameters = @{@"match_id":@(matchId),
                                 @"friend_id":@(friendId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)inviteFriends:(NSArray<NSNumber *> *)friendIdList matchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSMutableString *listString = [NSMutableString string];
    for (NSNumber *idNumber in friendIdList) {
        if ([NSString stringIsNullOrEmpty:listString]) {
            [listString appendString:idNumber.stringValue];
        } else {
            [listString appendFormat:@",%@", idNumber.stringValue];
        }
    }

    NSString *urlString = @"match_manage_controller/addinvite";
    NSDictionary *parameters = @{@"match_id":@(matchId),
                                 @"invite_list":[listString copy]};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)joinMatchWithMatchId:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match_manage_controller/doaddrelation";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        BLOCK_EXEC(handler, nil, error);
    }];
}

+ (void)getTeamGameInviteList:(RequestCompleteHandler)handler {
    NSString *urlString = @"match_manage_controller/dogetteamfriendlist";
    
    [self POST:urlString parameters:nil responseClass:[TeamMatchInviteResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamMatchInviteResponseInfo *info = result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}
@end
