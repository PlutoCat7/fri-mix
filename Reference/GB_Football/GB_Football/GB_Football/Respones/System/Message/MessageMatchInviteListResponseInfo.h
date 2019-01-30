//
//  MessageMatchInviteListResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"

typedef NS_ENUM(NSUInteger, MessageMatchInviteState) {
    MessageMatchInviteState_Invalid,  //比赛作废
    MessageMatchInviteState_Doing,    //比赛进行中
    MessageMatchInviteState_Completed, //比赛已完成
};

typedef NS_ENUM(NSUInteger, MessageMatchInviteMyState) {  //用户对于比赛的状态
    MessageMatchInviteMyState_Invited,  //被邀请中
    MessageMatchInviteMyState_Join,     //已加入
    MessageMatchInviteMyState_Upload_Data, //已加入，并且上传过数据
};

@interface MessageMatchInviteInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger match_id;
@property (nonatomic, assign) NSInteger creator_id;
@property (nonatomic, copy) NSString *match_name;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *court_address;
@property (nonatomic, assign) long create_time;
@property (nonatomic, assign) MessageMatchInviteState matchState;
@property (nonatomic, assign) MessageMatchInviteMyState matchMyState;

@end

@interface MessageMatchInviteListResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<MessageMatchInviteInfo *> *data;

@end
