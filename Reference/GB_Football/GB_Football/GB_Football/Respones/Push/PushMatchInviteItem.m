//
//  PushMatchInviteItem.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PushMatchInviteItem.h"

@implementation PushMatchInviteItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.inviteType = [[dict objectForKey:@"type"] integerValue];
            self.creatorImageUrl = [dict objectForKey:@"image_url"];
            self.creatorName = [dict objectForKey:@"nick_name"];
            self.matchName = [dict objectForKey:@"match_name"];
            self.courtName = [dict objectForKey:@"court_address"];
            self.matchId = [[dict objectForKey:@"match_id"] integerValue];
            self.creatorId = [[dict objectForKey:@"creator_id"] integerValue];
        }
    }
    return self;
}



@end
