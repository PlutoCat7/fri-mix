//
//  MatchRequest.m
//  GB_Team
//
//  Created by weilai on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MatchRequest.h"

@implementation MatchRequest

// 上传用户的比赛绑定信息
+ (void)uploadMatchBindInfo:(MatchBindInfo *)matchBindInfo handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match/addmatch";
    
    NSMutableArray *palyerBindArray = [NSMutableArray array];
    for (int i = 0; i < [matchBindInfo.playerBindArray count]; i++) {
        PlayerInfo *playerBindInfo = (matchBindInfo.playerBindArray[i]).playerInfo;
        WristbandInfo *wristbandInfo = (matchBindInfo.playerBindArray[i]).wristbandInfo;
        if (wristbandInfo) {
            [palyerBindArray addObject:@{@"player_id":@(playerBindInfo.playerId),
                                         @"order_id":@(wristbandInfo.wristId)}];
        }
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:palyerBindArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *pair_str = [[NSString alloc] initWithData:jsonData
                                               encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{@"court_id":@(matchBindInfo.courtId),
                                 @"match_name":matchBindInfo.matchName == nil ? @"" : matchBindInfo.matchName,
                                 @"host_team":matchBindInfo.homeTeamName,
                                 @"follow_team":matchBindInfo.guestTeamName,
                                 @"pair_str":pair_str};
    
    [self POST:urlString parameters:parameters responseClass:[MatchCreateResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchCreateResponseInfo *info = (MatchCreateResponseInfo *)result;
            BLOCK_EXEC(handler, @(info.data.matchId), nil);
        }
    }];
}

// 获取用户的比赛绑定信息
+ (void)getMatchBindInfo:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match/getmatchmess";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[MatchBindResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchBindResponseInfo *info = (MatchBindResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

+ (void)syncMatchDataWithMatchId:(NSInteger)matchId palyerId:(NSInteger)playerId originData:(NSData *)originData handleData:(NSData *)handleData handler:(RequestCompleteHandler)handler {
    
    if (!originData || !handleData) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableString *originStr = [NSMutableString stringWithCapacity:[originData length]*2];
        const unsigned char *szBuffer = [originData bytes];
        for (NSInteger i=0; i < [originData length]; ++i) {
            [originStr appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        }
        
        NSDictionary *parameters = @{@"match_id":@(matchId),
                                     @"player_id":@(playerId),
                                     @"data":[[NSString alloc] initWithData:handleData encoding:NSUTF8StringEncoding],
                                     @"data_ori":[originStr copy]};
        NSString *urlString = @"sync/syncmatchdata";
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

// 删除用户的比赛绑定信息
+ (void)delMatchBindInfo:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"match/delmatch";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)commitMatchComplete:(MatchInfo *)matchInfo handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match/completematch";
    
    NSDictionary *parameters = @{@"match_id":@(matchInfo.matchId),
                                 @"match_time_a":@(matchInfo.firstStartTime),
                                 @"match_time_b":@(matchInfo.firstEndTime),
                                 @"match_time_c":@(matchInfo.secondStartTime),
                                 @"match_time_d":@(matchInfo.secondEndTime),
                                 @"home_score":@(matchInfo.homeScore),
                                 @"guest_score":@(matchInfo.guestScore)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 删除球队比赛
+ (void)delMatch:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"match/hidematch";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 获取详细比赛数据
+ (void)getMatchInfo:(NSInteger)matchId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"playerdata/getlistbymatch";
    NSDictionary *parameters = @{@"match_id":@(matchId)};
    
    [self POST:urlString parameters:parameters responseClass:[MatchDetailResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchDetailResponseInfo *info = (MatchDetailResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 获取比赛的坐标数据
+ (void)getMatchLocData:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"playerdata/locallist";
    NSDictionary *parameters = @{@"match_id":@(matchId),
                                 @"player_id":@(playerId)};
    
    [self POST:urlString parameters:parameters responseClass:[MatchLocationResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            MatchLocationResponseInfo *info = (MatchLocationResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 发送短信,playerId为0表示发全场球员短信
+ (void)sendMatchShortMessage:(NSInteger)matchId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"playerdata/sendsms";
    NSDictionary *parameters = @{};
    if (playerId == 0) {
        parameters = @{@"match_id":@(matchId)};
    } else {
        parameters = @{@"match_id":@(matchId),
                       @"player_id":@(playerId)};
    }
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

@end
