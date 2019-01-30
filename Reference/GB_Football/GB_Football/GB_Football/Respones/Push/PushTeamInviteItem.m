//
//  PushTeamInviteItem.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PushTeamInviteItem.h"

@implementation PushTeamInviteItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.image_url = [dict objectForKey:@"image_url"];
            self.teamId = [[dict objectForKey:@"team_id"] integerValue];
            self.teamName = [dict objectForKey:@"team_name"];
        }
    }
    return self;
}

@end
