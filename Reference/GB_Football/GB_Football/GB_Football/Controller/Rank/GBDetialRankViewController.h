//
//  GBDetialRankViewController.h
//  GB_Football
//
//  Created by Pizza on 16/8/31.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PageViewController.h"

typedef enum
{
    DailyRank_This_Distance = 1,
    DailyRank_This_AvgSpeed,
    DailyRank_This_MaxSpeed,
    DailyRank_History_Distance,
    DailyRank_History_AvgSpeed,
    DailyRank_History_MaxSpeed,
    DailyRank_Week,
    DailyRank_Month,
    DailyRank_Day,
}GBDetialRankType;

@interface GBDetialRankViewController : PageViewController
// 标题和单位
- (instancetype)initWithType:(GBDetialRankType)type;
@end
