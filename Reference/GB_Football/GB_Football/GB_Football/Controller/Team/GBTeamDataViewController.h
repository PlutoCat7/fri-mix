//
//  GBTeamDataViewController.h
//  GB_Football
//
//  Created by gxd on 17/7/20.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "GBTeamDataListViewController.h"

#import "TeamDataResponseInfo.h"

@interface GBTeamDataViewController : GBBaseViewController

- (instancetype)initWithPlayerList:(NSArray<TeamDataPlayerInfo *> *)playerList type:(GBGameRankType)rankType;

@end
