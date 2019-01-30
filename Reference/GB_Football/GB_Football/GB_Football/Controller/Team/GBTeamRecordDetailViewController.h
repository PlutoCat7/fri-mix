//
//  GBTeamRecordDetailViewController.h
//  GB_Football
//
//  Created by gxd on 17/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "TeamDataResponseInfo.h"

@interface GBTeamRecordDetailViewController : GBBaseViewController

- (instancetype)initWithMatchId:(NSInteger)matchId;

- (instancetype)initWithPlayerList:(NSArray<TeamDataPlayerInfo *> *)playerList type:(GBGameRankType)rankType matchId:(NSInteger)matchId;

@end
