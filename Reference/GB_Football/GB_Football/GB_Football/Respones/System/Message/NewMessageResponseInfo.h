//
//  NewMessageResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/13.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface NewMessageInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger newMessageMatchInviteCount;  //最新比赛邀请信息个数
@property (nonatomic, assign) NSInteger newMessageSystemCount;   //最新系统消息个数
@property (nonatomic, assign) NSInteger newMessageTeamCount;   //最新球队消息个数

@end

@interface NewMessageResponseInfo : GBResponseInfo

@property (nonatomic, strong) NewMessageInfo *data;

@end
