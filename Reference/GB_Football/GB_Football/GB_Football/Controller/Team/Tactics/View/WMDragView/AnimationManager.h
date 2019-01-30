//
//  AnimationManager.h
//  TestDemo
//
//  Created by yahua on 2017/11/7.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDragView.h"
#import "AnimationStepObject.h"

@protocol AnimationManagerDelegate <NSObject>

- (void)animationAtStep:(NSInteger)step stepObject:(AnimationStepObject *)stepObject;

- (void)animationDidStop:(AnimationStepObject *)stepObject isFinish:(BOOL)isFinish;
/**
 删除步

 @param stepObject 被删除的步
 @param nowStepObject 删除后当前步
 */
- (void)animationDidDelete:(AnimationStepObject *)stepObject nowStepObject:(AnimationStepObject *)nowStepObject;

@end

@interface AnimationManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<AnimationStepObject *> *stepList;

@property (nonatomic, weak) id<AnimationManagerDelegate> delegate;

- (void)addFrameAnimation:(AnimationStepObject *)setObject;

- (AnimationStepObject *)lastStepObject;

//移除帧
- (void)removeFrameWithStep:(NSInteger)step;

- (void)startAnimation;

- (void)pauseAnimation;

- (void)resumeAnimation;

@end
