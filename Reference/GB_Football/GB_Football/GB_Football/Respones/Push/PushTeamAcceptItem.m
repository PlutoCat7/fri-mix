//
//  PushTeamAcceptItem.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PushTeamAcceptItem.h"

@implementation PushTeamAcceptItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.team_id = [[dict objectForKey:@"team_id"] integerValue];
        }
    }
    return self;
}

@end
