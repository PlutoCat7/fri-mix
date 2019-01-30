//
//  TacticsContentViewModel.h
//  GB_Football
//
//  Created by yahua on 2017/12/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBTacticsPlayerModel.h"
#import "TacticsJsonModel.h"
#import "ArrowBrush.h"

#define kTacticsContentViewWidth (335*kAppScale)
#define kTacticsContentViewHeight (480*kAppScale)

@interface TacticsContentViewModel : NSObject

@property (nonatomic, strong) NSArray<TacticsJsonStepModel *> * stepList;

- (GBTacticsPlayerModel *)getBallModel;

- (NSArray<GBTacticsPlayerModel *> *)getDefaultPlayers;

- (NSArray<ArrowBrush *> *)getDefaultBurshList;

- (GBTacticsPlayerModel *)getNextHomeTeamPlayer;

- (GBTacticsPlayerModel *)getNextGuestTeamPlayer;

//
- (BOOL)back;

- (BOOL)isCanBack;

@end
