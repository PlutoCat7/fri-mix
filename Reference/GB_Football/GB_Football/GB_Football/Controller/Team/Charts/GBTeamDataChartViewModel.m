//
//  GBTeamDataChartViewModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamDataChartViewModel.h"

#import "TeamRequest.h"

@interface GBTeamDataChartViewModel ()

@property (nonatomic, strong, readwrite) TeamInfo *teamInfo;
@property (nonatomic, strong) TeamDataInfo *teamDataInfo;

@property (nonatomic, strong) NSArray<ChartDataModel *> *gameCountList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *sprintList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *eruptList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *endurList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *coverAreatList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *maxSpeedList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *distanceList;

@end

@implementation GBTeamDataChartViewModel

- (instancetype)initWithTeamInfo:(TeamInfo *)teamInfo {
    
    self = [super init];
    if (self) {
        _teamInfo = teamInfo;
    }
    return self;
}

- (NSArray<TeamDataPlayerInfo *> *)playersInfo {
    
    return self.teamDataInfo.team_data;
}

- (BOOL)isHasTeamData {
    
    return self.teamDataInfo.team_data.count>0;
}

- (void)getTeamDataWithHandler:(void(^)(NSError *error))handler {
    
    [TeamRequest getTeamDataWithId:self.teamInfo.teamId handler:^(id result, NSError *error) {
        
        if (!error) {
            self.teamDataInfo = result;
        }
        BLOCK_EXEC(handler, error);
    }];
}

- (NSArray<NSString *> *)getScoreList {
    
    NSArray *originList = [self.teamDataInfo.team_mess.score_history componentsSeparatedByString:@","];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=originList.count-1; index>=0; index--) {
        [result addObject:originList[index]];
    }
    if (result.count<7) {
        NSArray *defaultScoreList = @[@"1000", @"500", @"1000", @"500", @"800", @"650", @"1000"];
        NSInteger startIndex = result.count;
        for (NSInteger i=6; i>=startIndex; i--) {
            [result insertObject:defaultScoreList[i] atIndex:0];
        }
    }
    
    return [result subarrayWithRange:NSMakeRange(result.count-7, 7)];
}

- (NSArray<ChartDataModel *> *)getGameCountRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.teamDataInfo.team_data rankType:GameRankType_Count];
    self.gameCountList = result;
    if (result.count>6) {
        result = [result subarrayWithRange:NSMakeRange(0, 6)];
    }
    return result;
}
- (NSArray<ChartDataModel *> *)getSprintRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.teamDataInfo.team_data rankType:GameRankType_Sprint];
    self.sprintList = result;
    if (result.count>6) {
        result = [result subarrayWithRange:NSMakeRange(0, 6)];
    }
    return result;
}

- (NSArray<ChartDataModel *> *)getEruptRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.teamDataInfo.team_data rankType:GameRankType_Erupt];
    self.eruptList = result;
    if (result.count>6) {
        result = [result subarrayWithRange:NSMakeRange(0, 6)];
    }
    return result;
}
- (NSArray<ChartDataModel *> *)getEndurRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.teamDataInfo.team_data rankType:GameRankType_Endur];
    self.endurList = result;
    if (result.count>6) {
        result = [result subarrayWithRange:NSMakeRange(0, 6)];
    }
    return result;
}

- (NSArray<ChartDataModel *> *)getAreaRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.teamDataInfo.team_data rankType:GameRankType_Area];
    self.coverAreatList = result;
    if (result.count>6) {
        result = [result subarrayWithRange:NSMakeRange(0, 6)];
    }
    return result;
}

- (NSArray<ChartDataModel *> *)getMaxSpeedRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.teamDataInfo.team_data rankType:GameRankType_MaxSpeed];
    self.maxSpeedList = result;
    if (result.count>6) {
        result = [result subarrayWithRange:NSMakeRange(0, 6)];
    }
    return result;
}

- (NSArray<ChartDataModel *> *)getDisTanceRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.teamDataInfo.team_data rankType:GameRankType_Distance];
    self.distanceList = result;
    if (result.count>6) {
        result = [result subarrayWithRange:NSMakeRange(0, 6)];
    }
    return result;
}

- (NSString *)gameCountRankDesc {
    
    return [NSString stringWithFormat:@"%@ %td", LS(@"team.data.team.total.label.count"), (NSInteger)[self.gameCountList subValueMaxWithKey:@"value"]];
}

- (NSString *)sprintRankDesc {
    
    return [NSString stringWithFormat:@"%@ %td", LS(@"team.data.team.total.label.sprint"), (NSInteger)[self.sprintList subValueCountWithKey:@"value"]];
}

- (NSString *)eruptRankDesc {
    
    return [NSString stringWithFormat:@"%@ %.1f", LS(@"team.data.team.total.label.erupt"), [self.eruptList subValueCountWithKey:@"value"]];
}

- (NSString *)endurRankDesc {
    
    return [NSString stringWithFormat:@"%@ %.1f", LS(@"team.data.team.total.label.endur"), [self.endurList subValueCountWithKey:@"value"]];
}

- (NSString *)coverAreaRankDesc {
    
    return [NSString stringWithFormat:@"%@ %td%%", LS(@"team.data.team.total.label.area"), (NSInteger)[self.coverAreatList subValueAvgWithKey:@"value"]];
}

- (NSString *)maxSpeedRankDesc {
    
    return [NSString stringWithFormat:@"%@ %.1fm/s", LS(@"team.data.team.total.label.maxspeed"), [self.maxSpeedList subValueAvgWithKey:@"value"]];
}

- (NSString *)distanceRankDesc {
    
    CGFloat distance = [self.distanceList subValueCountWithKey:@"value"]/1000;
    NSString *distanceString = @"";
    if (distance<1) {
        distanceString = @"<1KM";
    }else {
        distanceString = [NSString stringWithFormat:@"%.1fKM", distance];
    }
    return [NSString stringWithFormat:@"%@ %@", LS(@"team.data.team.total.label.distance"), distanceString];
}

@end
