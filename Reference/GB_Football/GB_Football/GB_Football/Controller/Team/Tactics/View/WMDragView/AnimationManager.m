//
//  AnimationManager.m
//  TestDemo
//
//  Created by yahua on 2017/11/7.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "AnimationManager.h"
#import "GBTacticsPlayerModel.h"

#define kAnimationDuration 1.25f
#define kAnimationKey @"kAnimationKey"

@interface AnimationManager () <CAAnimationDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray<AnimationStepObject *> *stepList;

@property (nonatomic, assign) NSInteger currentStep;   //正在进行第几步动画
@property (nonatomic, assign) NSInteger currentAnimationCount;  //当前一步动画个数
@property (nonatomic, assign) BOOL isRemoveLastFrame;  //是否正在进行删除动画
@property (nonatomic, assign) BOOL isAnimationFrame;  //是否进行动画

@end

@implementation AnimationManager

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _stepList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Public

- (void)addFrameAnimation:(AnimationStepObject *)setObject {
    
    if (self.isAnimationFrame) {
        return;
    }
    [self.stepList addObject:setObject];
}

- (AnimationStepObject *)lastStepObject {
    
    return self.stepList.lastObject;
}

- (void)removeFrameWithStep:(NSInteger)step {
    
#warning 不能删除吗？
    if (self.isAnimationFrame) {
        return;
    }
    if (self.isRemoveLastFrame) {  //正在做删除动画
        return;
    }
    
    if (step>=self.stepList.count) {
        return;
    }
    self.currentStep = step;
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidDelete:nowStepObject:)]) {
        AnimationStepObject *nowStepObject = nil;
        if (self.stepList.count>1) {
            NSInteger nowIndex = step - 1;
            if (nowIndex<0) { //被删除的是第一个, 取第二个当做当前step
                nowIndex = step + 1;
            }
            nowStepObject = self.stepList[nowIndex];
        }
        
        [self.delegate animationDidDelete:self.stepList[self.currentStep] nowStepObject:nowStepObject];
    }
    
    AnimationStepObject *stepObject = self.stepList[self.currentStep];
    if (stepObject.viewMoveList.count>0) {
        
        self.isRemoveLastFrame = YES;
        
        for (AnimationViewMoveObject *object in stepObject.viewMoveList) {
            //1.创建核心动画
            [self singleViewAnimation:object.moveView paths:[[object.keyPointList reverseObjectEnumerator] allObjects]];
        }
        self.currentAnimationCount = stepObject.viewMoveList.count;
    }else {
        [self.stepList removeObject:stepObject];
    }
}

- (void)startAnimation {
    
    if (self.stepList.count == 0) {
        return;
    }
    
    if (self.isAnimationFrame) {
        return;
    }

    self.currentStep = 0;
    self.isAnimationFrame = YES;
    [self animation];
}

- (void)pauseAnimation {
    
    self.isAnimationFrame = NO;
    
    if (_currentStep >= self.stepList.count) {
        _currentStep = self.stepList.count - 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop:isFinish:)]) {
        [self.delegate animationDidStop:self.stepList[_currentStep] isFinish:NO];
    }
}

- (void)resumeAnimation {
    
}

#pragma mark - Delegate

-(void)animationDidStart:(CAAnimation *)anim
{
    
    NSLog(@"开始动画");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"结束动画");
    if (self.isRemoveLastFrame) {
        self.currentAnimationCount--;
        if (self.currentAnimationCount == 0) {
            //保留动画开始位置
            AnimationStepObject *stepObject = self.stepList[self.currentStep];
            for (AnimationViewMoveObject *object in stepObject.viewMoveList) {
                object.moveView.center = object.beginPoint;
                [object.moveView.layer removeAnimationForKey:kAnimationKey];
            }
            self.isRemoveLastFrame = NO;
            [self.stepList removeObject:stepObject];
        }
    }else {
        self.currentAnimationCount--;
        if (self.currentAnimationCount == 0) {
            
            //保留动画结束位置
            AnimationStepObject *stepObject = self.stepList[self.currentStep];
            for (AnimationViewMoveObject *object in stepObject.viewMoveList) {
                object.moveView.center = object.endPoint;
                [object.moveView.layer removeAnimationForKey:kAnimationKey];
            }
            self.currentStep++;
            [self animation];
        }
    }
}

#pragma mark - Private

- (void)animation {
    
    if (!self.isAnimationFrame) {  //是否进行动画， 可能被中途暂停了
        return;
    }
//    //移除旧动画
//    for (WMDragView *dragView in self.viewList) {
//        [dragView.layer removeAnimationForKey:kAnimationKey];
//    }
    
    if (self.currentStep >= self.stepList.count) {
        self.isAnimationFrame = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(animationDidStop:isFinish:)]) {
            [self.delegate animationDidStop:self.stepList[self.currentStep - 1] isFinish:YES];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationAtStep:stepObject:)]) {
        [self.delegate animationAtStep:self.currentStep stepObject:self.stepList[self.currentStep]];
    }
    
    //动画
    AnimationStepObject *stepObject = self.stepList[self.currentStep];
    if (stepObject.viewMoveList.count==0) { //下一帧动画
        self.currentStep++;
        [self animation];
        return;
    }
    for (AnimationViewMoveObject *object in stepObject.viewMoveList) {
        object.moveView.center = object.beginPoint;
        //1.创建核心动画
        [self singleViewAnimation:object.moveView paths:[object.keyPointList copy]];
    }
    self.currentAnimationCount = [stepObject.viewMoveList count];
}

- (void)singleViewAnimation:(UIView *)view paths:(NSArray<NSValue *> *)values {
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    keyAnima.values = values;
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO
    ;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=kAnimationDuration;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //设置代理，开始—结束
    keyAnima.delegate=self;
    
    [view.layer addAnimation:keyAnima forKey:kAnimationKey];
}

#pragma mark Setter and Getter



@end
