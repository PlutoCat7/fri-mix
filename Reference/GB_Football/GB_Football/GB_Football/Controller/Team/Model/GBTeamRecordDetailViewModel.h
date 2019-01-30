//
//  GBTeamRecordDetailViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/17.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBTeamDataListModel.h"
#import "TeamDataResponseInfo.h"

@interface GBTeamRecordDetailViewModel : NSObject

@property (nonatomic, assign) NSInteger matchId;
@property (nonatomic, assign) BOOL isNeedLoadNetWorkData;

- (instancetype)initWithPlayerList:(NSArray<TeamDataPlayerInfo *> *)playerList;

- (void)getRankInfo:(void(^)(NSError *error))block;

- (GBTeamDataListModel *)teamDataListModelWithType:(GBGameRankType)gameRankType;

@end
