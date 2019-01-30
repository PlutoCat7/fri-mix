//
//  TacticsEditBoardView.h
//  GB_Football
//
//  Created by yahua on 2017/12/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"

@protocol TacticsEditBoardViewDelegate <NSObject>

- (void)didClickAddHomeTeamPlayer;

- (void)didClickAddGuestTeamPlayer;

- (void)didClickBrushTactics:(BOOL)isBrush;

- (void)didClickRevoke;

- (void)didClickPlay:(BOOL)isPlay;

@end

@interface TacticsEditBoardView : UIView <XXNibBridge>

@property (nonatomic, weak) id<TacticsEditBoardViewDelegate> delegate;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL isCanBack;

@property (nonatomic, assign) BOOL hideEditBoard;

@end
