//
//  TacticsContentView.h
//  GB_Football
//
//  Created by yahua on 2017/12/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"
#import "AnimationStepObject.h"
#import "TacticsJsonModel.h"

@interface TacticsContentView : UIView <XXNibBridge>

@property (nonatomic, assign) NSInteger totalStep;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) BOOL isPalying;  //是否正在播放
@property (nonatomic, assign) BOOL isCanBack;  //能否回退
@property (nonatomic, assign) BOOL isBursh;  //是否可以画线
@property (nonatomic, assign) BOOL isEdit;  //是否处于编辑战术模式

//载入网络数据
- (void)loadWithNetworkData:(NSArray<TacticsJsonStepModel *> *)stepList;

- (NSArray<AnimationStepObject *> *)stepList;

- (void)playTactics:(BOOL)isPlay;

- (void)addNewStep;

- (void)deleteStep;

- (void)addHomeTeamPlayer;

- (void)addGuestTeamPlayer;

//回退一次操作
- (void)back;

@end
