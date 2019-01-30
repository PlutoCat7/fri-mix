//
//  PaintingLayer.m
//  GB_Football
//
//  Created by yahua on 2018/1/9.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "PaintingLayer.h"
#import "PaintBrush.h"

@interface PaintingLayer ()

@property (nonatomic, strong) NSMutableArray<id<PaintBrush>> *paintBrushList;

@end

@implementation PaintingLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.drawsAsynchronously = YES;
        self.contentsScale       = [UIScreen mainScreen].scale;
        _paintBrushList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
    // 绘制过程中 contents 会变动,返回 nil, 否则会有晃瞎狗眼的隐式动画.
    if ([event isEqualToString:@"contents"]) {
        return nil;
    }
    return [super actionForKey:event];
}

#pragma mark - 绘图

- (void)drawInContext:(CGContextRef)ctx
{

    // 使用画刷对象绘图.
    for (id<PaintBrush> brush in self.paintBrushList) {
        [brush drawInContext:ctx];
    }

}

#pragma mark - 触摸处理

- (void)touchAction:(UITouch *)touch brush:(id<PaintBrush>)brush
{
    if (!brush) return;
    
    CGPoint point = [self convertPoint:[touch locationInView:touch.view] fromLayer:touch.view.layer];
    
    switch (touch.phase) {
        case UITouchPhaseMoved:
            
            [brush moveToPoint:point];
            
            break;
            
        case UITouchPhaseBegan:
            
            [brush beginAtPoint:point];
            [self.paintBrushList addObject:brush];
            break;
            
        case UITouchPhaseEnded:
        case UITouchPhaseCancelled:
            
            [brush end];
            
            break;
            
        case UITouchPhaseStationary:
            break; // 占位用,不然有警告...
    }

    [self setNeedsDisplay];
}

- (void)refreshWithBrushList:(NSArray<id<PaintBrush>> *)brushList {
    
    [self.paintBrushList removeAllObjects];
    [self.paintBrushList addObjectsFromArray:brushList];
    [self setNeedsDisplay];
}

#pragma mark - 清屏 撤销 恢复

- (void)clear
{
    [self.paintBrushList removeAllObjects];
    
    [self setNeedsDisplay];
}
@end
