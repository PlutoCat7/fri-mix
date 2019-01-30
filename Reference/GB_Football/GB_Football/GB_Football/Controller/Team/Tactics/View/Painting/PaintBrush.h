//
//  Header.h
//  GB_Football
//
//  Created by yahua on 2018/1/9.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

@import UIKit;

@protocol PaintBrush <NSObject>

/**
 *  线条粗细
 */
@property (nonatomic) CGFloat lineWidth;

/**
 *  线条颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  初始点
 */
@property (nonatomic, readonly) CGPoint startPoint;

/**
 *  上一点
 */
@property (nonatomic, readonly) CGPoint previousPoint;

/**
 *  当前点
 */
@property (nonatomic, readonly) CGPoint currentPoint;

/**
 *  需要重绘的矩形范围
 */
@property (nonatomic, readonly) CGRect redrawRect;

/**
 *  是否需要绘制
 */
@property (nonatomic, readonly) BOOL needsDraw;

/**
 *  绘制图案到上下文
 *
 *  @param context 上下文
 */
- (void)drawInContext:(CGContextRef)context;

/**
 *  从指定点开始
 *
 *  @param point 指定点（坐标）
 */
- (void)beginAtPoint:(CGPoint)point;

/**
 *  移动到指定点
 *
 *  @param point 指定点（坐标）
 */
- (void)moveToPoint:(CGPoint)point;

/**
 *  移动结束
 */
- (void)end;

@end
