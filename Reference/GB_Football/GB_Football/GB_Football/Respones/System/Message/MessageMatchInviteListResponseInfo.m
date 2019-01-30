//
//  MessageMatchInviteListResponseInfo.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MessageMatchInviteListResponseInfo.h"

@implementation MessageMatchInviteInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"matchState":@"tm_stat",
             @"matchMyState":@"stat"};
}

@end

@implementation MessageMatchInviteListResponseInfo

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"data":@"MessageMatchInviteInfo"};
}

- (NSArray *)onePageData {
    
    return self.data;
}


@end
