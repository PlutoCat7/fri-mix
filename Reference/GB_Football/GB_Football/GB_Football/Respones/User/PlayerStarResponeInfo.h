//
//  PlayerStarResponeInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface PlayerStarExtendInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) CGFloat   avgMove;
@property (nonatomic, assign) CGFloat   avgHighSpeed;
@property (nonatomic, assign) CGFloat   avgSpeed;
@property (nonatomic, assign) CGFloat   avgMatchMinute;
@property (nonatomic, assign) CGFloat   avgPC;
@property (nonatomic, assign) CGFloat   singleMaxMove;
@property (nonatomic, assign) CGFloat   singleMaxHighSpeed;
@property (nonatomic, assign) CGFloat   singleMaxAvgSpeed;
@property (nonatomic, assign) CGFloat   singleMaxMatchMinute;
@property (nonatomic, assign) CGFloat   singleMaxPC;
@property (nonatomic, assign) NSInteger matchCount;
@property (nonatomic, assign) CGFloat   speed;
@property (nonatomic, assign) CGFloat   endurance;
@property (nonatomic, assign) CGFloat   physique;

@property (nonatomic, assign) NSInteger score;  //最新战斗力
@property (nonatomic, copy) NSString *score_history; //历史战斗值，逗号隔开，左边最近，右边最久
@property (nonatomic, assign) NSInteger match_count;  //比赛次数
@property (nonatomic, assign) CGFloat max_speed;      //最高速度
@property (nonatomic, assign) CGFloat distance_count; //移动距离
@property (nonatomic, assign) CGFloat sprint_time;    //冲刺次数
@property (nonatomic, assign) CGFloat run_distance;   //耐力
@property (nonatomic, assign) CGFloat power;          //爆发力
@property (nonatomic, assign) CGFloat cover_rate;   //覆盖面积

@end

@interface PlayerStarUserInfo : YAHActiveObject

@property (nonatomic, copy  ) NSString  *nick;
@property (nonatomic, assign) SexType   sexType;
@property (nonatomic, copy  ) NSString  *phone;
@property (nonatomic, assign) NSInteger birthday;
@property (nonatomic, assign) CGFloat   weight;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, copy  ) NSString  *teamName;
@property (nonatomic, assign) NSInteger teamNo;
@property (nonatomic, copy  ) NSString  *position;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger regionId;
@property (nonatomic, copy  ) NSString  *imageUrl;

@end

@interface PlayerStarInfo : YAHActiveObject

@property (nonatomic, strong) PlayerStarExtendInfo *extend_data;
@property (nonatomic, strong) PlayerStarUserInfo *user_data;
@property (nonatomic, assign) BOOL isFriend;

+ (PlayerStarInfo *)playerStarInfoWithUserInfo:(UserInfo *)userInfo;

@end

@interface PlayerStarResponeInfo : GBResponseInfo

@property (nonatomic, strong) PlayerStarInfo *data;

@end
