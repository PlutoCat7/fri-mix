//
//  AnimationLineMoveObject.h
//  GB_Football
//
//  Created by yahua on 2018/1/10.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "AnimationBaseMoveObject.h"
#import "PaintBrush.h"

@interface AnimationLineMoveObject : AnimationBaseMoveObject

@property (nonatomic, strong) NSMutableArray<id<PaintBrush>> *paintBrushList;

@end
