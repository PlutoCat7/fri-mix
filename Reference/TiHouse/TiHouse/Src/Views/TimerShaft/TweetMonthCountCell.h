//
//  TimerShaftTableViewCell.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "TweetMonthCountS.h"
#import "MonthDairyModel.h"

@interface TweetMonthCountCell : CommonTableViewCell

@property (nonatomic ,retain) TweetMonthCountS *tweetMonthCountS;
@property (nonatomic, strong) MonthDairyModel *monthDairyModel;
@property (nonatomic ,retain) UIImageView *icon;//时光轴间隔图标

@end
