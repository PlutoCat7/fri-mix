//
//  GBGameStatistucsViewModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameStatistucsViewModel.h"
#import "MatchRequest.h"

@interface GBGameStatistucsViewModel ()

@property (nonatomic, assign) NSInteger matchId;

@property (nonatomic, strong) NSArray<ChartDataModel *> *sprintList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *eruptList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *endurList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *coverAreatList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *maxSpeedList;
@property (nonatomic, strong) NSArray<ChartDataModel *> *distanceList;

@end

@implementation GBGameStatistucsViewModel

- (instancetype)initWithMatchId:(NSInteger)matchId {
    
    self = [super init];
    if (self) {
        _matchId = matchId;
    }
    
    return self;
}

- (void)getDataWithHandler:(void(^)(NSError *error))handler {
    
    [MatchRequest getMatchPlayerBehaviourWithMatchId:self.matchId handler:^(id result, NSError *error) {
        
        if (!error) {
            self.team_data = result;
        }
        BLOCK_EXEC(handler, error);
    }];
}


- (NSArray<ChartDataModel *> *)getSprintRankList {
    
    NSArray<ChartDataModel *> *result = [GBChartsLogic getRankList:self.team_data rankType:GameRankType_Sprint];
    self.sprintList = result;
    return [self handleChartData:result];
}

- (NSArray<ChartDataModel *> *)getEruptRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.team_data rankType:GameRankType_Erupt];
    self.eruptList = result;
    return [self handleChartData:result];
}

- (NSArray<ChartDataModel *> *)getEndurRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.team_data rankType:GameRankType_Endur];
    self.endurList = result;
    return [self handleChartData:result];
}

- (NSArray<ChartDataModel *> *)getAreaRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.team_data rankType:GameRankType_Area];
    self.coverAreatList = result;
    return [self handleChartData:result];
}

- (NSArray<ChartDataModel *> *)getMaxSpeedRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.team_data rankType:GameRankType_MaxSpeed];
    self.maxSpeedList = result;
    return [self handleChartData:result];
}

- (NSArray<ChartDataModel *> *)getDisTanceRankList {
    
    NSArray *result = [GBChartsLogic getRankList:self.team_data rankType:GameRankType_Distance];
    self.distanceList = result;
    return [self handleChartData:result];
}

- (NSString *)sprintRankDesc {
    
    return [NSString stringWithFormat:@"%@ %td", LS(@"team.data.total.label.sprint"), (NSInteger)[self.sprintList subValueCountWithKey:@"value"]];
}

- (NSString *)eruptRankDesc {
    
    return [NSString stringWithFormat:@"%@ %.1f", LS(@"team.data.total.label.erupt"), [self.eruptList subValueCountWithKey:@"value"]];
}

- (NSString *)endurRankDesc {
    
    return [NSString stringWithFormat:@"%@ %.1f", LS(@"team.data.total.label.endur"), [self.endurList subValueCountWithKey:@"value"]];
}

- (NSString *)coverAreaRankDesc {
    
    return [NSString stringWithFormat:@"%@ %td%%", LS(@"team.data.total.label.area"), (NSInteger)round([self.coverAreatList subValueAvgWithKey:@"value"])];
}

- (NSString *)maxSpeedRankDesc {
    
    return [NSString stringWithFormat:@"%@ %.1fm/s", LS(@"team.data.total.label.maxspeed"), [self.maxSpeedList subValueAvgWithKey:@"value"]];
}

- (NSString *)distanceRankDesc {
    
    CGFloat distance = [self.distanceList subValueCountWithKey:@"value"]/1000;
    NSString *distanceString = @"";
    if (distance<1) {
        distanceString = @"<1KM";
    }else {
        distanceString = [NSString stringWithFormat:@"%.1fKM", distance];
    }
    return [NSString stringWithFormat:@"%@ %@", LS(@"team.data.total.label.distance"), distanceString];
}

#pragma mark - Private

- (NSArray<ChartDataModel *> *)handleChartData:(NSArray<ChartDataModel *> *)handleData {
    
    NSMutableArray<ChartDataModel *> *tmpResult = [NSMutableArray arrayWithArray:handleData];
    if (handleData.count>6) {
        tmpResult = [NSMutableArray arrayWithArray:[handleData subarrayWithRange:NSMakeRange(0, 6)]];
    }
    __block ChartDataModel *mineDataModel = nil;
    [handleData enumerateObjectsUsingBlock:^(ChartDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isMine) {
            mineDataModel = obj;
        }
    }];
    if (!mineDataModel) {
        return [tmpResult copy];
    }
    
    mineDataModel.nameFont = [UIFont boldSystemFontOfSize:10.0f];
    mineDataModel.nameColor = [UIColor greenColor];
    mineDataModel.valueTextColor = [UIColor greenColor];
    if (![tmpResult containsObject:mineDataModel]) { //将本人与第六名进行替换
        ChartDataModel *willRemoveDataModel = [tmpResult lastObject];
        mineDataModel.valueColor = willRemoveDataModel.valueColor;
        [tmpResult removeObject:willRemoveDataModel];
        [tmpResult addObject:mineDataModel];
    }
    
    return [tmpResult copy];
}

@end
