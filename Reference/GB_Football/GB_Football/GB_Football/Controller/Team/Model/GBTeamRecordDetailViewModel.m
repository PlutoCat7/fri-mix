//
//  GBTeamRecordDetailViewModel.m
//  GB_Football
//
//  Created by 王时温 on 2017/8/17.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamRecordDetailViewModel.h"
#import "TeamRequest.h"

@interface GBTeamRecordDetailViewModel ()

@property (nonatomic, strong) NSArray<TeamDataPlayerInfo *> *playersList;

@end

@implementation GBTeamRecordDetailViewModel

- (instancetype)initWithPlayerList:(NSArray<TeamDataPlayerInfo *> *)playerList {
    
    self = [super init];
    if (self) {
        _playersList = playerList;
    }
    
    return self;
}

- (BOOL)isNeedLoadNetWorkData {
    
    return self.playersList.count==0;
}

- (void)getRankInfo:(void(^)(NSError *error))block {
    
    [TeamRequest getTeamMatchPlayerDataWithId:self.matchId handler:^(id result, NSError *error) {

        if (!error) {
            self.playersList = result;
        }
        BLOCK_EXEC(block, error);
    }];
}

- (GBTeamDataListModel *)teamDataListModelWithType:(GBGameRankType)gameRankType {
    
    if (self.playersList.count == 0) {
        return nil;
    }
    
    GBTeamDataListModel *teamDataListModel = nil;
    switch (gameRankType) {
        case GameRankType_Sprint:
            teamDataListModel = [self sortWithSprint];
            break;
        case GameRankType_Erupt:
            teamDataListModel = [self sortWithErupt];
            break;
        case GameRankType_Endur:
            teamDataListModel = [self sortWithEndur];
            break;
        case GameRankType_Area:
            teamDataListModel = [self sortWithArea];
            break;
        case GameRankType_MaxSpeed:
            teamDataListModel = [self sortWithMaxSpeed];
            break;
        case GameRankType_Distance:
            teamDataListModel = [self sortWithDistance];
            break;
        default:
            return nil;
            break;
    }
    
    teamDataListModel.matchId = self.matchId;
    teamDataListModel.modelType = TeamDataModelType_Match;
    return teamDataListModel;
}

#pragma mark - Private

- (GBTeamDataListModel *)sortWithSprint {
    
    NSArray<TeamDataPlayerInfo *> *sortArray = [self.playersList sortDescWithKey:@"sprint_time"];
    
    GBTeamDataListModel *model = [[GBTeamDataListModel alloc] init];
    model.desc = [NSString stringWithFormat:@"%@ %td", LS(@"team.data.total.label.sprint"), (NSInteger)[sortArray subValueCountWithKey:@"sprint_time"]];
    NSMutableArray *players = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (TeamDataPlayerInfo *info in sortArray) {
        GBTeamDataDetailModel *detailModel = [[GBTeamDataDetailModel alloc] init];
        detailModel.playerId = info.user_id;
        detailModel.name = info.user_name;
        detailModel.valueString = [NSString stringWithFormat:@"%d", (int)info.sprint_time];
        detailModel.unit = @"";
        
        [players addObject:detailModel];
    }
    model.players = [players copy];
    
    return model;
}

- (GBTeamDataListModel *)sortWithErupt {
    
    NSArray<TeamDataPlayerInfo *> *sortArray = [self.playersList sortDescWithKey:@"power"];
    
    GBTeamDataListModel *model = [[GBTeamDataListModel alloc] init];
    model.desc = [NSString stringWithFormat:@"%@ %.1f", LS(@"team.data.total.label.erupt"), [sortArray subValueCountWithKey:@"power"]];
    NSMutableArray *players = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (TeamDataPlayerInfo *info in sortArray) {
        GBTeamDataDetailModel *detailModel = [[GBTeamDataDetailModel alloc] init];
        detailModel.playerId = info.user_id;
        detailModel.name = info.user_name;
        detailModel.valueString = [NSString stringWithFormat:@"%0.1f", info.power];
        detailModel.unit = @"";
        
        [players addObject:detailModel];
    }
    model.players = [players copy];
    
    return model;
}

- (GBTeamDataListModel *)sortWithEndur {
    
    NSArray<TeamDataPlayerInfo *> *sortArray = [self.playersList sortDescWithKey:@"run_distance"];
    
    GBTeamDataListModel *model = [[GBTeamDataListModel alloc] init];
    model.desc = [NSString stringWithFormat:@"%@ %.1f", LS(@"team.data.total.label.endur"), [sortArray subValueCountWithKey:@"run_distance"]];
    NSMutableArray *players = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (TeamDataPlayerInfo *info in sortArray) {
        GBTeamDataDetailModel *detailModel = [[GBTeamDataDetailModel alloc] init];
        detailModel.playerId = info.user_id;
        detailModel.name = info.user_name;
        detailModel.valueString = [NSString stringWithFormat:@"%0.1f", info.run_distance];
        detailModel.unit = @"";
        
        [players addObject:detailModel];
    }
    model.players = [players copy];
    
    return model;
    
}

- (GBTeamDataListModel *)sortWithArea {
    
    NSArray<TeamDataPlayerInfo *> *sortArray = [self.playersList sortDescWithKey:@"cover_rate"];
    
    GBTeamDataListModel *model = [[GBTeamDataListModel alloc] init];
    model.desc = [NSString stringWithFormat:@"%@ %td%%", LS(@"team.data.total.label.area"), (NSInteger)[sortArray subValueAvgWithKey:@"cover_rate"]];
    NSMutableArray *players = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (TeamDataPlayerInfo *info in sortArray) {
        GBTeamDataDetailModel *detailModel = [[GBTeamDataDetailModel alloc] init];
        detailModel.playerId = info.user_id;
        detailModel.name = info.user_name;
        detailModel.valueString = [NSString stringWithFormat:@"%d", (int)round(info.cover_rate)];
        detailModel.unit = @"%";
        
        [players addObject:detailModel];
    }
    model.players = [players copy];
    
    return model;
    
}

- (GBTeamDataListModel *)sortWithMaxSpeed {
    
    NSArray<TeamDataPlayerInfo *> *sortArray = [self.playersList sortDescWithKey:@"max_speed"];
    
    GBTeamDataListModel *model = [[GBTeamDataListModel alloc] init];
    model.desc = [NSString stringWithFormat:@"%@ %.1fM/S", LS(@"team.data.total.label.maxspeed"), [sortArray subValueAvgWithKey:@"max_speed"]];
    NSMutableArray *players = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (TeamDataPlayerInfo *info in sortArray) {
        GBTeamDataDetailModel *detailModel = [[GBTeamDataDetailModel alloc] init];
        detailModel.playerId = info.user_id;
        detailModel.name = info.user_name;
        detailModel.valueString = [NSString stringWithFormat:@"%0.1f", info.max_speed];
        detailModel.unit = @"M/S";
        
        [players addObject:detailModel];
    }
    model.players = [players copy];
    
    return model;
}

- (GBTeamDataListModel *)sortWithDistance {
    
    NSArray<TeamDataPlayerInfo *> *sortArray = [self.playersList sortDescWithKey:@"distance_count"];
    
    GBTeamDataListModel *model = [[GBTeamDataListModel alloc] init];
    CGFloat distance = [sortArray subValueCountWithKey:@"distance_count"]/1000;
    NSString *distanceString = @"";
    if (distance<1) {
        distanceString = @"<1KM";
    }else {
        distanceString = [NSString stringWithFormat:@"%.1fKM", distance];
    }
    model.desc = [NSString stringWithFormat:@"%@ %@", LS(@"team.data.total.label.distance"), distanceString];
    NSMutableArray *players = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (TeamDataPlayerInfo *info in sortArray) {
        GBTeamDataDetailModel *detailModel = [[GBTeamDataDetailModel alloc] init];
        detailModel.playerId = info.user_id;
        detailModel.name = info.user_name;
        if (info.distance_count < 1000) {
            detailModel.unit = @"M";
            detailModel.valueString = [NSString stringWithFormat:@"%0.1f", info.distance_count];
            
        } else {
            detailModel.unit = @"KM";
            detailModel.valueString = [NSString stringWithFormat:@"%0.1f", info.distance_count/1000];
        }
        
        [players addObject:detailModel];
    }
    model.players = [players copy];
    
    return model;
}

@end
