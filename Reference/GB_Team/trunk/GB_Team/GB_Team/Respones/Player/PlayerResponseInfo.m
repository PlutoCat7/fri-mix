//
//  PlayerResponseInfo.m
//  GB_Team
//
//  Created by weilai on 16/9/20.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PlayerResponseInfo.h"

@implementation PlayerInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"playerId":@"id",
             @"coachId":@"coach_id",
             @"playerName":@"player_name",
             @"playerBirthday":@"birthday",
             @"playerNum":@"clothes_no",
             @"imageUrl":@"image_url",
             @"sexType":@"sex"};
}

- (void)setPlayerBirthday:(NSInteger)playerBirthday {
    
    _playerBirthday = playerBirthday;
    
    NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:playerBirthday];
    self.playerAge = [NSDate date].year - birthDate.year;
}

@end

@implementation PlayerResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"PlayerInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
