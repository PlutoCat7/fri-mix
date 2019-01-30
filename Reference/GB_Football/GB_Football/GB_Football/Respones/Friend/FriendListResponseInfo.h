//
//  FriendListResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface FriendInfo : GBResponseInfo

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) FriendStatus status;  //好友邀请
@property (nonatomic, assign) FriendInviteMatchStatus inviteStatus;  //比赛邀请

@end

//好友列表
@interface FriendListDataInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<FriendInfo *> *addressBookList;
@property (nonatomic, strong) NSArray<FriendInfo *> *friendApplyList;
@property (nonatomic, strong) NSArray<FriendInfo *> *friendList;

@end

@interface FriendListResponseInfo : GBResponseInfo

@property (nonatomic, strong) FriendListDataInfo *data;

@end
