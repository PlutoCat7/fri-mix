//
//  MessageListResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "MessageListResponseInfo.h"

@implementation MessageInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"messageId":@"id",
             @"createTime":@"release_time"};
}

- (void)setType:(MessageType)type {
    
    _type = type;
    [[UpdateManager shareInstance] checkAppUpdateWithMessageType:type];
}

@end

@implementation MessageListResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"MessageInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}

@end
