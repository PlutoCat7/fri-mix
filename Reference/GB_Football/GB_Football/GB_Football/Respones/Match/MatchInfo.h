//
//  MatchInfo.h
//  GB_Football
//
//  Created by wsw on 16/7/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "YAHActiveObject.h"
#import "LocationCoordinateInfo.h"
#import "TimeDivisionRecordInfo.h"
#import "TeamLineUpResponseInfo.h"
#import "CoverAreaInfo.h"
#import "TimeRateInfo.h"

@interface MatchConfigInfo : YAHActiveObject

@property (nonatomic, copy) NSString *img_uri_1;
@property (nonatomic, copy) NSString *img_uri_2;
@property (nonatomic, copy) NSString *img_uri_3;
@property (nonatomic, copy) NSString *img_uri_4;
@property (nonatomic, copy) NSString *img_uri_5;
@property (nonatomic, copy) NSString *img_uri_6;
@property (nonatomic, copy) NSString *img_uri_7;
@property (nonatomic, copy) NSString *img_uri_8;
@property (nonatomic, copy) NSString *img_uri_9;

@property (nonatomic, copy) NSString *video_url;

- (NSArray<NSString *> *)imgUrlList;
- (NSArray<NSString *> *)videoUrlList;

@end

//比赛单节信息
@interface MatchSectonInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat pc;
@property (nonatomic, assign) NSInteger sprint_times;
@property (nonatomic, assign) CGFloat sprint_distance;
@property (nonatomic, assign) CGFloat move_distance;
@property (nonatomic, assign) CGFloat max_speed;
@property (nonatomic, copy) NSString *half_url;
@property (nonatomic, assign) long start_time;
@property (nonatomic, assign) long end_time;

@property (nonatomic, copy) NSString *sprint_url;     //冲刺轨迹
@property (nonatomic, copy) NSString *cover_area_url;  //覆盖面积url
@property (nonatomic, assign) CGFloat cover_area_rate; //全场覆盖面积比例
@property (nonatomic, strong) CoverAreaInfo *cover_area_info;
@property (nonatomic, strong) TimeRateInfo *time_rate_info;

@end


@interface MatchHeatMapInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger force_draw_status; //	0 未计算 1 只有上半场有强制绘图 2 只有下半场强制绘图 3 上下半场都是强制绘图 4 都没有强制绘图
@property (nonatomic, assign) NSInteger point_count_status; //0 未计算 1 只有上半场有点 2 只有下半场有点 3 上下半场都有点 4 都没有点

//热力图
@property (nonatomic, copy) NSString *first_half_url;
@property (nonatomic, copy) NSString *second_half_url;
@property (nonatomic, copy) NSString *final_url;

//冲刺图
@property (nonatomic, copy) NSString *first_half_sprint_url;
@property (nonatomic, copy) NSString *second_half_sprint_url;
@property (nonatomic, copy) NSString *final_sprint_url;

//覆盖面积
@property (nonatomic, assign) CGFloat first_cover_area_rate; //上半场覆盖率
@property (nonatomic, assign) CGFloat second_cover_area_rate; //下半场覆盖率
@property (nonatomic, assign) CGFloat final_cover_area_rate;  //全场覆盖率
@property (nonatomic, copy) NSString *final_cover_area_url;
@property (nonatomic, copy) NSString *first_cover_area_url;
@property (nonatomic, copy) NSString *second_cover_area_url;
@property (nonatomic, strong) CoverAreaInfo *first_cover_area_info;
@property (nonatomic, strong) CoverAreaInfo *second_cover_area_info;
@property (nonatomic, strong) CoverAreaInfo *final_cover_area_info;

@property (nonatomic, strong) TimeRateInfo *first_time_rate_info;
@property (nonatomic, strong) TimeRateInfo *second_time_rate_info;
@property (nonatomic, strong) TimeRateInfo *final_time_rate_info;

@end

//比赛成就
@interface MatchAchieveInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat last_max_speed;               //全场最高速度
@property (nonatomic, assign) CGFloat last_max_move_distance;       //全场最高移动距离
@property (nonatomic, assign) NSInteger country_speed_rank;         //最高速度全国排名
@property (nonatomic, assign) NSInteger country_move_distance_rank; //移动距离全国排名
@property (nonatomic, assign) NSInteger speed_pass_ratio;           //最高速度超越全国比例
@property (nonatomic, assign) NSInteger distance_pass_ratio;        //移动距离超过的比例
@property (nonatomic, assign) CGFloat history_max_speed;            //历史最高速度
@property (nonatomic, assign) CGFloat history_max_distance;         //历史最高移动距离
@property (nonatomic, assign) NSInteger speed_history_rank;         //历史最高速度名次
@property (nonatomic, assign) NSInteger distance_history_rank;      //历史移动距离排名
@property (nonatomic, assign) CGFloat country_max_speed;            //全国最高速度
@property (nonatomic, assign) CGFloat country_max_distance;         //全国最大移动距离
@property (nonatomic, assign) CGFloat pass_my_max_speed;            //排在我前一位的最高速度
@property (nonatomic, assign) CGFloat pass_my_max_distance;         //前一名的移动距离
@property (nonatomic, assign) NSInteger status;                     //0未显示过 1显示过
@property (nonatomic, assign) NSInteger display_type;  	 //0不满足显示条件 1速度 2距离

@end

@interface MatchReportInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat average_distance;             //平均移动距离
@property (nonatomic, assign) NSInteger distance_level;             //跑动距离级别
@property (nonatomic, assign) CGFloat average_speed;                //最高速度年龄段的平均数据
@property (nonatomic, assign) NSInteger speed_level;                //最高速度级别
@property (nonatomic, assign) CGFloat average_pc;                   //该年龄段的平均体能消耗
@property (nonatomic, assign) NSInteger pc_level;                   //体能消耗级别
@property (nonatomic, assign) NSInteger run_strong_level;           //跑动强度级别
@property (nonatomic, assign) NSInteger power_att_level;            //体能衰减级别

@end


@interface MatchRectInfo : YAHActiveObject

@property (nonatomic, strong) LocationCoordinateInfo *maxPointA;
@property (nonatomic, strong) LocationCoordinateInfo *maxPointB;
@property (nonatomic, strong) LocationCoordinateInfo *maxPointC;
@property (nonatomic, strong) LocationCoordinateInfo *maxPointD;
@property (nonatomic, assign) double maxWidth;
@property (nonatomic, assign) double maxHeight;
@property (nonatomic, assign) double maxAngle;

@end

@interface SpeedDataInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) CGFloat distance;

@end

@interface MatchDataInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat moveDistance;
@property (nonatomic, assign) CGFloat avgSpeed;
@property (nonatomic, assign) CGFloat maxSpeed;
@property (nonatomic, assign) CGFloat consume;
@property (nonatomic, assign) CGFloat sprintDistance;
@property (nonatomic, assign) NSInteger sprintTime;

@end

@interface MatchUserInfo : YAHActiveObject

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, assign) NSInteger teamNo;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *imageUrl;

@end

@interface MatchInfo : YAHDataResponseInfo

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) NSInteger courtId;
@property (nonatomic, copy) NSString *courtName;
@property (nonatomic, assign) NSInteger creatorId;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *matchName;
@property (nonatomic, assign) NSInteger status;    //0:热力图已生成，  1:未生成
@property (nonatomic, assign) long createMatchDate;    //创建比赛时间
@property (nonatomic, assign) long matchTime;    //手环踢球时间
@property (nonatomic, assign) long firstStartTime;
@property (nonatomic, assign) long firstEndTime;
@property (nonatomic, assign) long secondStartTime;
@property (nonatomic, assign) long secondEndTime;
@property (nonatomic, assign) long match_data_time_a;
@property (nonatomic, assign) long match_data_time_b;
@property (nonatomic, assign) long match_data_time_c;
@property (nonatomic, assign) long match_data_time_d;
@property (nonatomic, assign) NSInteger homeScore;
@property (nonatomic, assign) NSInteger guestScore;
@property (nonatomic, strong) MatchDataInfo *globalData;
@property (nonatomic, strong) MatchDataInfo *firstHalfData;
@property (nonatomic, strong) MatchDataInfo *secondHalfData;
@property (nonatomic, strong) SpeedDataInfo *walkSpeed;
@property (nonatomic, strong) SpeedDataInfo *runSpeed;
@property (nonatomic, strong) SpeedDataInfo *sprintSpeed;
@property (nonatomic, strong) LocationCoordinateInfo *location;
@property (nonatomic, strong) LocationCoordinateInfo *locA;
@property (nonatomic, strong) LocationCoordinateInfo *locB;
@property (nonatomic, strong) LocationCoordinateInfo *locC;
@property (nonatomic, strong) LocationCoordinateInfo *locD;

@property (nonatomic, strong) LocationCoordinateInfo *pointA;
@property (nonatomic, strong) LocationCoordinateInfo *pointB;
@property (nonatomic, strong) LocationCoordinateInfo *pointC;
@property (nonatomic, strong) LocationCoordinateInfo *pointD;
@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) double angle;

@property (nonatomic, strong) MatchRectInfo *rectInfo;

@property (nonatomic, copy) NSString *host_team;    //主队名称
@property (nonatomic, copy) NSString *follow_team;    //客队名称

@property (nonatomic, strong) MatchAchieveInfo *achieve; //本场成就
@property (nonatomic, strong) MatchReportInfo *report;   //比赛数据报告
@property (nonatomic, strong) MatchHeatMapInfo *heatmap_data;  //比赛热力图信息

@property (nonatomic, assign) GameType gameType;  //比赛模式，标准或者多节模式
@property (nonatomic, strong) NSArray<MatchSectonInfo *> *split; //多节信息

@property (nonatomic, assign) NSInteger inviteUserCount;   //邀请人数, 包含自己
@property (nonatomic, strong) MatchUserInfo *matchUserInfo; //比赛中的用户信息

@property (nonatomic, assign) TracticsType tracticsType;
@property (nonatomic, strong) NSArray<TeamLineUpInfo *> *tracticsPlayers;

//赛后配置信息
@property (nonatomic, strong) MatchConfigInfo *matchConfig;

- (BOOL)shouldShowAchieveView;

@end
