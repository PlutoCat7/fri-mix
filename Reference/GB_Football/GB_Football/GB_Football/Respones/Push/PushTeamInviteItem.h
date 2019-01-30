//
//  PushTeamInviteItem.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//  球队邀请

#import "PushTeamItem.h"

@interface PushTeamInviteItem : PushTeamItem

@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, copy) NSString *teamName;

@end
