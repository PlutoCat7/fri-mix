//
//  FriendSearchRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "FriendSearchRequest.h"

@implementation FriendSearchRequest

- (Class)responseClass {
    
    return [FriendSearchResponseInfo class];
}

- (NSString *)requestAction {
    
    return @"friend_find_no_fd_controller/dofind";
}

- (NSDictionary *)parameters {
    
    return @{@"search_key":self.searchPhone};
}

@end
