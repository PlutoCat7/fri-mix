//
//  MatchResponseInfo.h
//  GB_Team
//
//  Created by weilai on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "LocationCoordinateInfo.h"

@interface MatchHeatMapInfo : YAHActiveObject

@property (nonatomic, copy) NSString *first_half_url;
@property (nonatomic, copy) NSString *second_half_url;
@property (nonatomic, copy) NSString *final_url;
@property (nonatomic, assign) NSInteger force_draw_status; //	0 未计算 1 只有上半场有强制绘图 2 只有下半场强制绘图 3 上下半场都是强制绘图 4 都没有强制绘图
@property (nonatomic, assign) NSInteger point_count_status; //0 未计算 1 只有上半场有点 2 只有下半场有点 3 上下半场都有点 4 都没有点

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

@interface MatchPlayerInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat first_move_distance;
@property (nonatomic, assign) CGFloat first_max_speed;
@property (nonatomic, assign) CGFloat first_pc;
@property (nonatomic, assign) NSInteger first_sprint_times;   //冲刺次数
@property (nonatomic, assign) CGFloat first_sprint_distance;
@property (nonatomic, assign) CGFloat second_move_distance;
@property (nonatomic, assign) CGFloat second_max_speed;
@property (nonatomic, assign) CGFloat second_pc;
@property (nonatomic, assign) NSInteger second_sprint_times;   //冲刺次数
@property (nonatomic, assign) CGFloat second_sprint_distance;

@property (nonatomic, strong) MatchRectInfo *point_rect;
@property (nonatomic, strong) SpeedDataInfo *walkSpeed;
@property (nonatomic, strong) SpeedDataInfo *runSpeed;
@property (nonatomic, strong) SpeedDataInfo *sprintSpeed;

@property (nonatomic, assign) NSInteger player_id;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *player_name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) NSInteger clothes_no;  //球衣号码
@property (nonatomic, copy) NSString *position;   //球场位置
@property (nonatomic, assign) CGFloat move_distance;
@property (nonatomic, assign) CGFloat max_speed;
@property (nonatomic, assign) CGFloat pc;         //消耗卡路里

@property (nonatomic, strong) MatchHeatMapInfo *heatmap_data;  //比赛热力图信息

@end

@interface MatchMessInfo : YAHActiveObject

@property (nonatomic, assign) NSInteger match_id;
@property (nonatomic, copy) NSString *court_name;
@property (nonatomic, strong) LocationCoordinateInfo *court_a;
@property (nonatomic, strong) LocationCoordinateInfo *court_b;
@property (nonatomic, strong) LocationCoordinateInfo *court_c;
@property (nonatomic, strong) LocationCoordinateInfo *court_d;
@property (nonatomic, strong) LocationCoordinateInfo *point_a;
@property (nonatomic, strong) LocationCoordinateInfo *point_b;
@property (nonatomic, strong) LocationCoordinateInfo *point_c;
@property (nonatomic, strong) LocationCoordinateInfo *point_d;

@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) double angle;
@property (nonatomic, assign) NSInteger home_score;
@property (nonatomic, assign) NSInteger guest_score;
@property (nonatomic, assign) long match_time_a;   //上半场开始时间
@property (nonatomic, assign) long match_time_b;   //上半场结束时间
@property (nonatomic, assign) long match_time_c;   //下半场开始时间
@property (nonatomic, assign) long match_time_d;   //下半场结束时间

@property (nonatomic, copy) NSString *host_team;    //主队名称
@property (nonatomic, copy) NSString *follow_team;    //客队名称

@end

@interface MatchDetailInfo : YAHActiveObject

@property (nonatomic, strong) NSArray<MatchPlayerInfo *> *playerList;
@property (nonatomic, strong) MatchMessInfo *matchMess;

@end

@interface MatchDetailResponseInfo : GBResponseInfo

@property (nonatomic, strong) MatchDetailInfo *data;

@end
