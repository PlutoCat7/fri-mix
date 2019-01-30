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
    self = [super initWithDictionary:dict];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *aps = [dict objectForKey:@"aps"];
            if (aps) {
                self.title = [aps objectForKey:@"alert"];
            }
            
            self.type = (PushType)[[dict objectForKey:@"message_type"] integerValue];
            //比赛数据
            self.msgId = [[dict objectForKey:@"match_id"] integerValue];
            //内外部wen推送
            self.param_url = [dict objectForKey:@"param_url"];
            self.param_id = [[dict objectForKey:@"param_id"] integerValue];
            self.param_uri = [dict objectForKey:@"param_uri"];
            self.content = [dict objectForKey:@"content"];
        }
    }
    return self;
}

@end
