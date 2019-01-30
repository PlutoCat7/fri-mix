//
//  FriendRequest.m
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "FriendRequest.h"
#import <AddressBook/AddressBook.h>

@implementation FriendRequest

+ (void)getFriendListWithHandler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"friend_list_controller/dolist";
    [self POST:urlString parameters:nil responseClass:[FriendListResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            FriendListResponseInfo *responeInfo = (FriendListResponseInfo *)result;
            BLOCK_EXEC(handler, responeInfo.data, nil);
        }
    }];
}

+ (void)getAddressBookFriendList:(NSArray *)phoneArray handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"friend_address_book_controller/dolist";
    NSString *phones = @"";
    for (int index = 0; phoneArray && index < [phoneArray count]; index++) {
        NSString *phone = phoneArray[index];
        phones = [phones stringByAppendingString:phone];
        if (index != [phoneArray count] - 1) {
            phones = [phones stringByAppendingString:@","];
        }
    }
    NSDictionary *parameters = @{@"addr_phones":phones};
    
    [self POST:urlString parameters:parameters responseClass:[FriendListResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            FriendListResponseInfo *responeInfo = (FriendListResponseInfo *)result;
            BLOCK_EXEC(handler, responeInfo.data, nil);
        }
    }];
}

+ (void)addFriend:(NSInteger)userId handler:(RequestCompleteHandler)handler {

    NSString *urlString = @"friend_apply_controller/doapply";
    NSDictionary *parameters = @{@"user_id":@(userId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)deleteFriend:(NSInteger)userId handler:(RequestCompleteHandler)handler {
    
    NSString *urlString = @"friend_ope_controller/dodel";
    NSDictionary *parameters = @{@"friend_id":@(userId)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)disposeFriendInvite:(NSInteger)userId agree:(BOOL)agree handler:(RequestCompleteHandler)handler {

    NSInteger is_agree = agree?1:2;
    NSString *urlString = @"friend_apply_done_controller/doapplydone";
    NSDictionary *parameters = @{@"user_id":@(userId),
                                 @"is_agree":@(is_agree)};
    
    [self POST:urlString parameters:parameters responseClass:[GBResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            BLOCK_EXEC(handler, nil, nil);
        }
    }];
}

+ (void)getInviteMatchFriendListHandler:(RequestCompleteHandler)handler {

    NSString *urlString = @"match_manage_controller/dogetfriendlist";
    [self POST:urlString parameters:nil responseClass:[FriendInviteMatchListResponseInfo class] handler:^(id result, NSError *error) {
        if (error) {
            BLOCK_EXEC(handler, nil, error);
        }else {
            FriendInviteMatchListResponseInfo *responeInfo = (FriendInviteMatchListResponseInfo *)result;
            BLOCK_EXEC(handler, responeInfo.data, nil);
        }
    }];
}

@end
