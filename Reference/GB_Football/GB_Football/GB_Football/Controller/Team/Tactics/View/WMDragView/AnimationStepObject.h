//
//  AnimationStepObject.h
//  GB_Football
//
//  Created by yahua on 2017/12/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationViewMoveObject.h"
#import "AnimationLineMoveObject.h"

extern NSString *const AnimationStepMoveCountChangeNotification;

@interface AnimationStepObject : NSObject

@property (nonatomic, copy) NSString *identifier;
//移动集合
@property (nonatomic, strong) NSMutableArray<AnimationViewMoveObject *> *viewMoveList;
@property (nonatomic, strong, readonly) AnimationLineMoveObject *lineMoveObject;

//记录移动步骤
@property (nonatomic, strong) NSMutableArray<NSString *> *moveList;

@property (nonatomic, assign) BOOL isMove;  //是否有移动(包含view的移动和箭头)

- (void)addNewMove:(NSString *)identifier;

//移除最后一次移动
- (AnimationBaseMoveObject *)removeLastMove;

- (AnimationBaseMoveObject *)findAnimationObjectWithIdenfier:(NSString *)idenfier;

@end
