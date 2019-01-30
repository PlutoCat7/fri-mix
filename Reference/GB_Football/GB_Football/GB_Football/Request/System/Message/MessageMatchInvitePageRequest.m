//
//  MessageMatchInvitePageRequest.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "MessageMatchInvitePageRequest.h"

@implementation MessageMatchInvitePageRequest

- (Class)responseClass {
    
    return [MessageMatchInviteListResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"match_manage_controller/getuserinvitelist";
}

@end
