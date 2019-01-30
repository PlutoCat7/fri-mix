//
//  UIViewAnimation.m
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/26.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import "UIViewAnimation.h"

@implementation UIViewAnimation

+(instancetype)shareAnimation{
    UIViewAnimation *uiAnimation = [[UIViewAnimation alloc]init];
    return uiAnimation;
}

//给按钮添加左右摆动的效果(路径动画)
+(CAKeyframeAnimation *)getSwingAnimationWithPoint:(CGPoint)point IsX:(BOOL)isX{
    
    if (!isX) {
        CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y - 10)],
                            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y + 10)],
                            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y - 10)],
                            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y + 10)],
                            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y - 10)],
                            [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                            [NSValue valueWithCGPoint:point]];
        keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        keyFrame.duration = 0.5f;
        
        return keyFrame;
    }
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;

    return keyFrame;
}

//让圆转圈，实现"加载中"的效果
+(CABasicAnimation *)getRotateAnimation{
    
    CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    baseAnimation.duration = 0.4;
    baseAnimation.fromValue = @(0);
    baseAnimation.toValue = @(2 * M_PI);
    baseAnimation.repeatCount = MAXFLOAT;
    
    return baseAnimation;
}

//画圆
+(CAShapeLayer *)getCircleWithRadius:(CGFloat)radius BackgroundColor:(UIColor *)backgroundColor{
    UIBezierPath* path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:(radius/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = 1.5;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = backgroundColor.CGColor;
    shapeLayer.frame = CGRectMake(0, 0, radius, radius);
    shapeLayer.path = path.CGPath;
    
    return shapeLayer;
}




@end
