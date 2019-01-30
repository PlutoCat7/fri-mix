//
//  PushBaseItem.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/31.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PushBaseItem.h"

@implementation PushBaseItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            _pushDict = dict;
            NSDictionary *aps = [dict objectForKey:@"aps"];
            if (aps) {
                self.title = [aps objectForKey:@"alert"];
            }
            
            self.type = (PushType)[[dict objectForKey:@"message_type"] integerValue];
            self.content = [dict objectForKey:@"content"];
        }
    }
    return self;
}


@end
