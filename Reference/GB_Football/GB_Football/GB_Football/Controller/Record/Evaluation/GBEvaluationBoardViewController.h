//
//  GBEvaluationBoardViewController.h
//  GB_Football
//
//  Created by Pizza on 2017/1/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PageViewController.h"
#import "MatchInfo.h"
#import "MatchRequest.h"
#import "MatchTimeDivisionResponseInfo.h"

@interface GBEvaluationBoardViewController : PageViewController

-(void)drawWithChart:(BarChartModel*)chartModel matchInfo:(MatchInfo*)matchInfo playerId:(NSInteger)playerId;
@end
