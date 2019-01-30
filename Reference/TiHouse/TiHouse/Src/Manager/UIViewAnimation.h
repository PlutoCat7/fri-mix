//
//  UIViewAnimation.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/26.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewAnimation : NSObject
+(instancetype)shareAnimation;
//左右摆动的效果(路径动画)
+(CAKeyframeAnimation *)getSwingAnimationWithPoint:(CGPoint)point IsX:(BOOL)isX;
//让圆转圈，实现"加载中"的效果
+(CABasicAnimation *)getRotateAnimation;
//画圆
+(CAShapeLayer *)getCircleWithRadius:(CGFloat)radius BackgroundColor:(UIColor *)backgroundColor;
@end
