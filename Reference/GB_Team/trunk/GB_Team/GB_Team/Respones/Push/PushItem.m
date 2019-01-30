//
//  PushItem.m
//  GB_Football
//
//  Created by weilai on 16/3/29.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PushItem.h"

@implementation PushItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *aps = [dict objectForKey:@"aps"];
            if (aps) {
                self.title = [aps objectForKey:@"alert"];
            }
            
            self.type = (PushType)[[dict objectForKey:@"message_type"] integerValue];
            if (self.type == PushType_Friend) {
                // 没有内容
                
            } else if (self.type == PushType_MatchData) {
                self.msgId = [[dict objectForKey:@"match_id"] integerValue];
            }
        }
    }
    return self;
}

@end
