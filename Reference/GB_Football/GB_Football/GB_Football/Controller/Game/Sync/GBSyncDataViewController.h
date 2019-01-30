//
//  GBSyncDataViewController.h
//  GB_Football
//
//  Created by Pizza on 16/8/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "MatchInfo.h"

@interface GBSyncDataViewController : GBBaseViewController

@property (nonatomic, assign) BOOL hideRecordTimeDivision;

- (instancetype)initWithMatchId:(NSInteger)matchId showSportCard:(BOOL)showSportCard;

@end
