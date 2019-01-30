//
//  MessageRequest.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "BaseNetworkRequest.h"
#import "NewMessageResponseInfo.h"
#import "MessageTeamListResponseInfo.h"

@interface MessageRequest : BaseNetworkRequest

/**
 检查是否有未读消息

 @param handler 回调
 */
+ (void)checkHasNewMessageWithHandler:(RequestCompleteHandler)handler;


/**
 删除比赛邀请信息

 @param deleteList 比赛的id列表
 @param handler 回调
 */
+ (void)deleteMatchInviteWithMatchIdList:(NSArray<NSNumber *> *)deleteList handler:(RequestCompleteHandler)handler;

/**
 删除球队消息
 
 @param deleteList 球队信息列表
 @param handler 回调
 */
+ (void)deleteTeamMessageWithList:(NSArray<MessageTeamInfo *> *)deleteList handler:(RequestCompleteHandler)handler;

@end
