//
//  PlayerRequest.m
//  GB_Team
//
//  Created by weilai on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PlayerRequest.h"

@implementation PlayerRequest

// 获取球员列表
+ (void)getPlayerList:(RequestCompleteHandler)handler {
    NSString *urlString = @"player/getlist";
    
    [self GET:urlString parameters:nil responseClass:[PlayerResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            PlayerResponseInfo *info = (PlayerResponseInfo *)result;
            BLOCK_EXEC(handler, info.data, nil);
        }
    }];
}

// 添加球员
+ (void)addPlayer:(PlayerInfo *)playerInfo handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"player/addplayer";
    NSDictionary *parameters = @{@"player_name":playerInfo.playerName == nil ? @"" : playerInfo.playerName,
                                 @"phone":playerInfo.phone == nil ? @"" : playerInfo.phone,
                                 @"sex":@(playerInfo.sexType),
                                 @"birthday":@(playerInfo.playerBirthday),
                                 @"clothes_no":@(playerInfo.playerNum),
                                 @"position":playerInfo.position == nil ? @"" : playerInfo.position,
                                 @"weight":@(playerInfo.weight),
                                 @"height":@(playerInfo.height)};
    
    [self POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (playerInfo.image) {
            NSData *imageData = UIImageJPEGRepresentation(playerInfo.image, 0.8);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/png"];
        }
    } progress:nil responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
    
}

// 编辑球员
+ (void)editPlayer:(PlayerInfo *)playerInfo handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"player/upplayer";
    NSDictionary *parameters = @{@"id":@(playerInfo.playerId),
                                 @"player_name":playerInfo.playerName == nil ? @"" : playerInfo.playerName,
                                 @"phone":playerInfo.phone == nil ? @"" : playerInfo.phone,
                                 @"sex":@(playerInfo.sexType),
                                 @"birthday":@(playerInfo.playerBirthday),
                                 @"clothes_no":@(playerInfo.playerNum),
                                 @"position":playerInfo.position == nil ? @"" : playerInfo.position,
                                 @"weight":@(playerInfo.weight),
                                 @"height":@(playerInfo.height)};
    
    [self POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (playerInfo.image) {
            NSData *imageData = UIImageJPEGRepresentation(playerInfo.image, 0.8);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"file" mimeType:@"image/png"];
        }
    } progress:nil responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

// 删除球员
+ (void)deletePlayer:(NSInteger)playerId handler:(RequestCompleteHandler)handler {
    NSString *urlString = @"player/delplayer";
    NSDictionary *parameters = @{@"id":@(playerId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
    
}

@end
