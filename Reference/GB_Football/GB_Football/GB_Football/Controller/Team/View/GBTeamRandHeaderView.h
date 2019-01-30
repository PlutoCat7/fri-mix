//
//  GBTeamRandHeaderView.h
//  GB_Football
//
//  Created by gxd on 17/9/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamRankResponseInfo.h"

typedef enum
{
    GBTeamRankType_Glod = 0,
    GBTeamRankType_Silver,
    GBTeamRankType_Copper
}GBTeamRankType;

@interface GBTeamRandHeaderView : UIView

@property (nonatomic, assign) GBTeamRankType rankType;
@property (nonatomic, copy) void(^didLookUpTeam)(GBTeamRankType rankType);

- (void)refreshWithTeamRankInfo:(TeamRankInfo *)teamRankInfo;

@end
