//
//  UserResponseInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/12.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "CourtResponseInfo.h"
#import "MatchInfo.h"
#import "TeamResponseInfo.h"

@interface UserMatchInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger match_id;
@property (nonatomic, assign) NSInteger creator_id;

@end

@interface ConfigInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger stepNumberGoal;   //目标步数
@property (nonatomic, assign) NSInteger match_add_dail;   //是否将比赛步数加入日常开关

@end

@interface WristbandInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger wristId;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *equipName;  //手环本身的名称
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *handEquipName;  //手环可修改的名称

@end

@interface UserInfo : GBResponseInfo

@property (nonatomic, copy  ) NSString      *sid;
@property (nonatomic, assign) NSInteger     userId;
@property (nonatomic, copy  ) NSString      *nick;
@property (nonatomic, assign) SexType       sexType;
@property (nonatomic, copy  ) NSString      *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) NSInteger          birthday;
@property (nonatomic, assign) NSInteger     weight;
@property (nonatomic, assign) NSInteger     height;
@property (nonatomic, copy  ) NSString      *teamName;
@property (nonatomic, assign) NSInteger     teamNo;
@property (nonatomic, copy  ) NSString      *position;
@property (nonatomic, assign) NSInteger     provinceId;
@property (nonatomic, assign) NSInteger     cityId;
@property (nonatomic, assign) NSInteger     regionId;
@property (nonatomic, copy  ) NSString      *imageUrl;
@property (nonatomic, strong) ConfigInfo    *config;
@property (nonatomic, strong) WristbandInfo *wristbandInfo;
@property (nonatomic, strong) CourtInfo *default_court;
@property (nonatomic, strong) UserMatchInfo *matchInfo;
@property (nonatomic, strong) TeamInfo *team_mess;
// 当前用户在球队里的角色
@property (nonatomic, assign) TeamPalyerType roleType;

- (void)clearMatchInfo;
//本地属性，只有在用户信息内的球队信息内有效
- (BOOL)isCaptainOrViceCaptain;

@end

@interface UserResponseInfo : GBResponseInfo

@property (nonatomic, strong) UserInfo *data;

@end
