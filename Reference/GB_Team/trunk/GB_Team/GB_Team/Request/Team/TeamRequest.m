//
//  TeamRequest.m
//  GB_Team
//
//  Created by weilai on 16/9/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "TeamRequest.h"
#import "PlayerResponseInfo.h"

@implementation TeamRequest

+ (void)getTeamListWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team/getlist";
    
    [self POST:urlString parameters:nil responseClass:[TeamResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamResponseInfo *info = (TeamResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 添加球队
+ (void)addTeam:(NSString *)teamName handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team/addteam";
    NSDictionary *parameters = @{@"team_name":teamName == nil ? @"" : teamName};
    
    [self POST:urlString parameters:parameters responseClass:[TeamAddResponeInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            TeamAddResponeInfo *info = result;
            BLOCK_EXEC(handler, @(info.data.teamId), nil);
        }
    }];
}

// 删除球队
+ (void)deleteTeam:(NSInteger)teamId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team/delteam";
    NSDictionary *parameters = @{@"id":@(teamId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getTeamMemberWithTeamId:(NSInteger)teamId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"team_player/getlist";
    NSDictionary *parameters = @{@"team_id":@(teamId)};
    [self POST:urlString parameters:parameters responseClass:[PlayerResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            PlayerResponseInfo *info = (PlayerResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 添加球员到球队
+ (void)addPlayerToTeam:(NSInteger)teamId playerList:(NSArray *)playerList handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_player/addplayer";
    
    NSString *playerIds = @"";
    for (NSNumber *playerId in playerList) {
        if ([NSString stringIsNullOrEmpty:playerIds]) {
            playerIds = [NSString stringWithFormat:@"%@", playerId];
        } else {
            playerIds = [NSString stringWithFormat:@"%@,%@", playerIds, playerId];
        }
    }
    
    NSDictionary *parameters = @{@"team_id":@(teamId),
                                 @"player_ids":playerIds};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 从球队删除球员
+ (void)deletePlayerFromTeam:(NSInteger)teamId playerId:(NSInteger)playerId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"team_player/delplayer";
    
    NSDictionary *parameters = @{@"team_id":@(teamId),
                                 @"player_id":@(playerId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

@end
