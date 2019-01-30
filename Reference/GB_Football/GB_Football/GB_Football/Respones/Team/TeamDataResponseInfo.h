//
//  TeamDataResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "TeamResponseInfo.h"

@interface TeamDataPlayerInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, assign) NSInteger match_count;  //比赛次数
@property (nonatomic, assign) CGFloat max_speed;      //最高速度
@property (nonatomic, assign) CGFloat distance_count; //移动距离
@property (nonatomic, assign) NSInteger sprint_time;    //冲刺次数
@property (nonatomic, assign) CGFloat run_distance;   //耐力
@property (nonatomic, assign) CGFloat power;          //爆发力
@property (nonatomic, assign) CGFloat cover_rate;   //覆盖面积

@property (nonatomic, copy) NSString *abbreviateName; //昵称 缩写

@end


@interface TeamDataTeamInfo : TeamInfo

@property (nonatomic, assign) NSInteger score;  //最新战斗力
@property (nonatomic, copy) NSString *score_history; //历史战斗值，逗号隔开，左边最近，右边最久

- (NSArray<NSString *> *)historyScoreList;

@end

@interface TeamDataInfo : YAHActiveObject

@property (nonatomic, strong) TeamDataTeamInfo *team_mess;
@property (nonatomic, strong) NSArray<TeamDataPlayerInfo *> *team_data;

@end

@interface TeamDataResponseInfo : GBResponseInfo

@property (nonatomic, strong) TeamDataInfo *data;

@end
