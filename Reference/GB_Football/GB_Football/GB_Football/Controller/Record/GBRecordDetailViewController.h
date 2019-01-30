//
//  GBRecordDetailViewController.h
//  GB_Football
//
//  Created by Pizza on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseShareViewController.h"

@interface GBRecordDetailViewController : GBBaseShareViewController

- (instancetype)initWithMatchId:(NSInteger)matchId;
- (instancetype)initWithMatchId:(NSInteger)matchId playerId:(NSInteger)playerId;

@property (nonatomic, assign) NSInteger matchId;

- (void)reloadData;

@end
