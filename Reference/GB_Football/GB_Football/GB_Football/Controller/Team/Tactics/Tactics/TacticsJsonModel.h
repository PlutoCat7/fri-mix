//
//  TacticsJsonModel.h
//  GB_Football
//
//  Created by yahua on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//  将战术转化为json string

#import "YAHActiveObject.h"

@interface TacticsJsonPointModel : YAHActiveObject

@property (nonatomic, assign) CGFloat x;   // 0-1
@property (nonatomic, assign) CGFloat y;   //-1

@end

@interface TacticsJsonLineModel : YAHActiveObject

@property (nonatomic, strong) TacticsJsonPointModel *beginPoint;   //开始位置
@property (nonatomic, strong) TacticsJsonPointModel *endPoint;   //结束位置
@end

@interface TacticsJsonPlayerMoveModel : YAHActiveObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSArray<TacticsJsonPointModel *> *pathList;  //移动轨迹

@end

@interface TacticsJsonStepModel : YAHActiveObject

@property (nonatomic, strong) TacticsJsonPlayerMoveModel *footballMove;
@property (nonatomic, strong) NSArray<TacticsJsonPlayerMoveModel *> *homePlayersMoveList;
@property (nonatomic, strong) NSArray<TacticsJsonPlayerMoveModel *> *guestPlayersMoveList;
@property (nonatomic, strong) NSArray<TacticsJsonLineModel *> *arrowLineList;

//移动顺序数组
@property (nonatomic, strong) NSArray<NSString *> *moveList;

@end

@interface TacticsJsonModel : YAHActiveObject

@property (nonatomic, assign) NSInteger count;  //球员个数
@property (nonatomic, copy) NSString *tacticsName; //战术名称
@property (nonatomic, strong) NSArray<TacticsJsonStepModel *> *stepList;

@end
