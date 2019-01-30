//
//  AnimationMoveObject.h
//  TestDemo
//
//  Created by yahua on 2017/11/7.
//  Copyright © 2017年 王时温. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationBaseMoveObject.h"
#import "GBTacticsPlayerModel.h"
#import "WMDragView.h"

@interface AnimationViewMoveObject : AnimationBaseMoveObject

@property (nonatomic, weak) WMDragView *moveView;
@property (nonatomic, assign) TacticsPlayerType moveType;
@property (nonatomic, assign) CGPoint beginPoint;  //开始位置
@property (nonatomic, assign) CGPoint endPoint;    //最后的位置

//关键点集合（每次移动时记录）
@property (nonatomic, strong) NSMutableArray<NSValue *> *keyPointList;

@end
