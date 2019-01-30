//
//  GBChartsLogic.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamDataResponseInfo.h"
#import "ChartDataModel.h"
#import "PlayerStarResponeInfo.h"

@interface GBChartsLogic : NSObject

+ (NSArray<ChartDataModel *> *)getRankList:(NSArray<TeamDataPlayerInfo *> *)list rankType:(GBGameRankType)rankType;

+ (NSArray<NSNumber *> *)dataWithPlayerStarInfo:(PlayerStarExtendInfo *)info;

@end
