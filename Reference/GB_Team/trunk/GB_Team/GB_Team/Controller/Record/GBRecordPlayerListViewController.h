//
//  GBRecordPlayerListViewController.h
//  GB_Team
//
//  Created by Pizza on 16/9/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBasePageViewController.h"

@interface GBRecordPlayerListViewController : GBBasePageViewController

- (instancetype)initWithMatchId:(NSInteger)matchId;

// 比赛id
@property (nonatomic, assign) NSInteger matchId;

@end
