//
//  AnimationMoveObject.m
//  TestDemo
//
//  Created by yahua on 2017/11/7.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import "AnimationViewMoveObject.h"

@implementation AnimationViewMoveObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _keyPointList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)setBeginPoint:(CGPoint)beginPoint {
    
    _beginPoint = beginPoint;
    if (self.keyPointList.count == 0) {
        [self.keyPointList addObject:[NSValue valueWithCGPoint:beginPoint]];
    }else {
        [self.keyPointList replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:beginPoint]];
    }
}

- (CGPoint)prePoint {
    
    if (self.keyPointList.count>1) {
        return [self.keyPointList[self.keyPointList.count - 2] CGPointValue];
    }else {
        return self.beginPoint;
    }
}

#pragma mark - OverWirte

- (void)removeLastMove {
    
    if (self.keyPointList.count>1) { //起始位置不删除
        [self.keyPointList removeLastObject];
    }
    _moveView.center = [self prePoint];
    self.endPoint = [self.keyPointList.lastObject CGPointValue];
}

@end
