//
//  PushTeamItem.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/31.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PushTeamItem.h"

@implementation PushTeamItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.nick_name = [dict objectForKey:@"nick_name"];
        }
    }
    return self;
}

@end
