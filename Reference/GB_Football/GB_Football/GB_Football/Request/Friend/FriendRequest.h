//
//  FriendRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"

#import "FriendListResponseInfo.h"
#import "FriendInviteMatchListResponseInfo.h"

@interface FriendRequest : BaseNetworkRequest

/**
 * 获取好友列表
 */
+ (void)getFriendListWithHandler:(RequestCompleteHandler)handler;

/**
 * 获取通讯录好友
 * @prama phoneArray 通讯电话号码数组
 */
+ (void)getAddressBookFriendList:(NSArray *)phoneArray handler:(RequestCompleteHandler)handler;

/**
 * 添加好友
 * @prama userId 用户id
 */
+ (void)addFriend:(NSInteger)userId handler:(RequestCompleteHandler)handler;

/**
 删除已添加的好友

 @param userId 好友id
 */
+ (void)deleteFriend:(NSInteger)userId handler:(RequestCompleteHandler)handler;

/**
 * 处理好友信息
 * @prama userId 用户id
 * @prama agree  yes:接受  no:拒接
 */
+ (void)disposeFriendInvite:(NSInteger)userId agree:(BOOL)agree handler:(RequestCompleteHandler)handler;

//获取比赛邀请好友列表
+ (void)getInviteMatchFriendListHandler:(RequestCompleteHandler)handler;

@end
