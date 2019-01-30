//
//  PaintingLayer.h
//  GB_Football
//
//  Created by yahua on 2018/1/9.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol PaintBrush;

@interface PaintingLayer : CALayer

/**
 *  触摸事件响应,于四个触摸事件发生时调用此方法并将 UITouch 传入
 *
 *  @param touch Touch
 */

- (void)touchAction:(UITouch *)touch brush:(id<PaintBrush>)paintBrush;

- (void)refreshWithBrushList:(NSArray<id<PaintBrush>> *)brushList;

/**
 *  清屏
 */
- (void)clear;

@end
