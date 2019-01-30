//
//  GBFullGameViewModel.h
//  GB_Football
//
//  Created by yahua on 2017/8/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchInfo.h"
#import "GBFullGameModel.h"

@interface GBFullGameViewModel : NSObject

@property (nonatomic, strong) MatchInfo *matchInfo;

@property (nonatomic, strong, readonly) GBFullGameModel *model;

- (void)swipeCoverArea;

@end
