//
//  FriendListResponseInfo.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "FriendListResponseInfo.h"

@implementation FriendInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"userId":@"id",
             @"nickName":@"nick_name",
             @"imageUrl":@"image_url",
             @"inviteStatus":@"stat"};
}

@end


@implementation FriendListDataInfo

+ (NSDictionary *)bridgePropertyAndJSON {
    
    return @{@"addressBookList":@"address_list",
             @"friendApplyList":@"friend_apply_list",
             @"friendList":@"friend_list"};
}

+ (NSDictionary *)bridgeClassAndArray {
    
    return @{@"addressBookList":@"FriendInfo",
             @"friendApplyList":@"FriendInfo",
             @"friendList":@"FriendInfo"};
}

@end


@implementation FriendListResponseInfo

@end
