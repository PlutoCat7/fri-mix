//
//  TeamHomeResponeInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "TeamResponseInfo.h"

@interface TeamPalyerInfo : YAHActiveObject

@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, assign) NSInteger team_no;
@property (nonatomic, assign) TeamPalyerType roleType;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) FriendInviteMatchStatus inviteStatus;  //比赛邀请

@end

@interface TeamHomeRespone : YAHActiveObject

@property (nonatomic, strong) NSArray<TeamPalyerInfo *> *players;
@property (nonatomic, strong) TeamInfo *team_mess;

@end

@interface TeamHomeResponeInfo : GBResponseInfo

@property (nonatomic, strong) TeamHomeRespone *data;

@end
