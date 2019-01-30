//
//  PushTeamApplyItem.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PushTeamApplyItem.h"

@implementation PushTeamApplyItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.image_url = [dict objectForKey:@"image_url"];
            self.ope_user_id = [[dict objectForKey:@"ope_user_id"] integerValue];
        }
    }
    return self;
}

@end
