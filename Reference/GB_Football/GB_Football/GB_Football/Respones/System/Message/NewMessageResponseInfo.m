//
//  NewMessageResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "NewMessageResponseInfo.h"

@implementation NewMessageInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"newMessageSystemCount":@"have_anno_num",
             @"newMessageMatchInviteCount":@"have_invite_num",
             @"newMessageTeamCount":@"have_team_mess_num"};
}

@end

@implementation NewMessageResponseInfo

@end
