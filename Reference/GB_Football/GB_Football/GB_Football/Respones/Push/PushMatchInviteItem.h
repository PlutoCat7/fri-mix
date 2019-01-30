//
//  PushMatchInviteItem.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PushItem.h"

typedef NS_ENUM(NSUInteger, PushMatchInviteItemType) {
    PushMatchInviteItemType_Invite,  //邀请
    PushMatchInviteItemType_Remove,  //移除
};

@interface PushMatchInviteItem : PushItem

@property (nonatomic, assign) PushMatchInviteItemType inviteType;
@property (nonatomic, copy) NSString *creatorImageUrl;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, assign) NSInteger creatorId;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, copy) NSString *courtName;
@property (nonatomic, assign) NSInteger matchId;

@end
