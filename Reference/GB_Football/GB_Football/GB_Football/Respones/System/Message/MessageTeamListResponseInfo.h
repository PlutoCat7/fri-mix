//
//  MessageTeamListResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

typedef NS_ENUM(NSUInteger, MessageTeamType) {
    MessageTeamType_Apply = 1,
    MessageTeamType_Invite,
    MessageTeamType_Other,
};

@interface MessageTeamInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, assign) NSInteger create_time;
@property (nonatomic, assign) MessageTeamType messageType;  //1: 申请消息 2: 邀请消息 3: 文本消息
@property (nonatomic, assign) NSInteger messageStatus;  //0:申请中 1:通过 2:拒绝 邀请消息状态是 0:邀请中 1:通过 查看消息状态是:1:踢出 2:任命副队长 3: 解除副队长 4移交队长
@property (nonatomic, assign) NSInteger team_id;
@property (nonatomic, copy) NSString *team_name;

@end


@interface MessageTeamListResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<MessageTeamInfo *> *data;


@end
