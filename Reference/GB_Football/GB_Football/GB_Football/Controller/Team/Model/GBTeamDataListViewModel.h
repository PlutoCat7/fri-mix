//
//  GBTeamDataListViewModel.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/17.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBTeamDataListModel.h"
#import "TeamDataResponseInfo.h"

@interface GBTeamDataListViewModel : NSObject

- (instancetype)initWithPlayerList:(NSArray<TeamDataPlayerInfo *> *)playerList;

- (GBTeamDataListModel *)teamDataListModelWithType:(GBGameRankType)gameRankType;

@end
