//
//  AnimationLineMoveObject.m
//  GB_Football
//
//  Created by yahua on 2018/1/10.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "AnimationLineMoveObject.h"

@implementation AnimationLineMoveObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _paintBrushList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)removeLastMove {
    
    [_paintBrushList removeLastObject];
}

@end
