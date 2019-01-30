//
//  GBGameStatistucsViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBChartsLogic.h"
#import "MatchPlayerBehaviourResponseInfo.h"

@interface GBGameStatistucsViewModel : NSObject

@property (nonatomic, assign, readonly) NSInteger matchId;
@property (nonatomic, strong) NSArray<TeamDataPlayerInfo *> *team_data;

- (instancetype)initWithMatchId:(NSInteger)matchId;

- (void)getDataWithHandler:(void(^)(NSError *error))handler;

//数据提供
- (NSArray<ChartDataModel *> *)getSprintRankList;
- (NSArray<ChartDataModel *> *)getEruptRankList;
- (NSArray<ChartDataModel *> *)getEndurRankList;
- (NSArray<ChartDataModel *> *)getAreaRankList;
- (NSArray<ChartDataModel *> *)getMaxSpeedRankList;
- (NSArray<ChartDataModel *> *)getDisTanceRankList;

- (NSString *)sprintRankDesc;
- (NSString *)eruptRankDesc;
- (NSString *)endurRankDesc;
- (NSString *)coverAreaRankDesc;
- (NSString *)maxSpeedRankDesc;
- (NSString *)distanceRankDesc;

@end
