//
//  TeamNewTeammateResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

typedef NS_ENUM(NSUInteger, TeamNewTeammateState) {
    TeamNewTeammateState_Normal,
    TeamNewTeammateState_Invited,
    TeamNewTeammateState_Joined = 3,  //已加入球队
};
@interface TeamNewTeammateInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *team_name;  //已加入的球队名称

@property (nonatomic, assign) TeamNewTeammateState state;

@end

@interface TeamNewTeammateResponse : YAHActiveObject

@property (nonatomic, strong) NSArray<TeamNewTeammateInfo *> *apply_list;
@property (nonatomic, strong) NSArray<TeamNewTeammateInfo *> *friend_List;

@end

@interface TeamNewTeammateResponseInfo : GBResponseInfo

@property (nonatomic, strong) TeamNewTeammateResponse *data;

@end
