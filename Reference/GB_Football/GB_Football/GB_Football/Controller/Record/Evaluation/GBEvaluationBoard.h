//
//  GBEvaluationBoard.h
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchTimeDivisionResponseInfo.h"
#import "MatchInfo.h"

@interface GBEvaluationBoard : UIView
-(void)reloadTableWith:(MatchInfo*)info;
-(void)drawChartWithBarChartModel:(BarChartModel*)barChartModel;
@property (nonatomic, copy) void (^actionClickAchivement)();
-(void)showBarChartAnimation;
@end
