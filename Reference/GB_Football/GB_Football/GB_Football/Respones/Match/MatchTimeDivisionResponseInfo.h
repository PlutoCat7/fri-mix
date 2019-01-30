//
//  MatchTimeDivisionResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/1/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"

@interface MatchTimeDivisionInfo : YAHActiveObject

@property (nonatomic, assign) CGFloat pc;      //消耗
@property (nonatomic, assign) NSInteger sprint_times;  //冲刺时间
@property (nonatomic, assign) CGFloat sprint_distance;  //冲刺距离
@property (nonatomic, assign) CGFloat move_distance;   //移动距离
@property (nonatomic, assign) NSInteger duration;     //持续时间
@property (nonatomic, assign) CGFloat avg_speed;     //平均速度
@property (nonatomic, assign) CGFloat max_speed;    //最大速度
@property (nonatomic, assign) CGFloat walk;         //慢走距离
@property (nonatomic, assign) CGFloat run;         //跑动距离
@property (nonatomic, assign) CGFloat sprint;     //冲刺距离


@end


@interface BarChartModel : NSObject

// 移动距离图表
@property (nonatomic,strong) NSArray<NSString*>* axiXMove;
@property (nonatomic,strong) NSArray<NSString*>* axiYMove;
@property (nonatomic,strong) NSArray<NSString*>* topMove;
@property (nonatomic,strong) NSArray<NSNumber*>* progressMove;
@property (nonatomic,strong) NSString* totalMove;
// 最高速度图表
@property (nonatomic,strong) NSArray<NSString*>* axiXSpeed;
@property (nonatomic,strong) NSArray<NSString*>* axiYSpeed;
@property (nonatomic,strong) NSArray<NSString*>* topSpeed;
@property (nonatomic,strong) NSArray<NSNumber*>* progressSpeed;
@property (nonatomic,strong) NSString* maxSpeed;

@end

@interface MatchTimeDivisionResponseInfo : GBResponseInfo
@property (nonatomic, strong) NSArray<MatchTimeDivisionInfo *> *data;
-(BarChartModel*)parse;
@end
