//
//  GBTeamDataChartViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamResponseInfo.h"
#import "TeamDataResponseInfo.h"
#import "GBChartsLogic.h"

@interface GBTeamDataChartViewModel : NSObject

@property (nonatomic, strong, readonly) TeamInfo *teamInfo;
@property (nonatomic, strong, readonly) NSArray<TeamDataPlayerInfo *> *playersInfo;
@property (nonatomic, assign, readonly) BOOL isHasTeamData;

- (instancetype)initWithTeamInfo:(TeamInfo *)teamInfo;

- (void)getTeamDataWithHandler:(void(^)(NSError *error))handler;

//数据提供
- (NSArray<NSString *> *)getScoreList;
- (NSArray<ChartDataModel *> *)getGameCountRankList;
- (NSArray<ChartDataModel *> *)getSprintRankList;
- (NSArray<ChartDataModel *> *)getEruptRankList;
- (NSArray<ChartDataModel *> *)getEndurRankList;
- (NSArray<ChartDataModel *> *)getAreaRankList;
- (NSArray<ChartDataModel *> *)getMaxSpeedRankList;
- (NSArray<ChartDataModel *> *)getDisTanceRankList;

- (NSString *)gameCountRankDesc;
- (NSString *)sprintRankDesc;
- (NSString *)eruptRankDesc;
- (NSString *)endurRankDesc;
- (NSString *)coverAreaRankDesc;
- (NSString *)maxSpeedRankDesc;
- (NSString *)distanceRankDesc;

@end
