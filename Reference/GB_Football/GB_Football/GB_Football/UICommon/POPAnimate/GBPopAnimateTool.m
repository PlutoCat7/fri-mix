//
//  GBPopAnimateTool.m
//  GB_Football
//
//  Created by Pizza on 2016/12/21.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPopAnimateTool.h"

@implementation GBPopAnimateTool

+(void)popFade:(UIView*)view fade:(BOOL)fade repeat:(BOOL)repeat
              duration:(CGFloat)duration beginTime:(CGFloat)beginTime
       completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if(repeat)
    {
        anim.repeatForever = YES;
        anim.autoreverses  = YES;
    }
    if (fade)
    {
        anim.fromValue = @(1.0);
        anim.toValue   = @(0.0);
    }
    else
    {
        anim.fromValue = @(0.0);
        anim.toValue   = @(1.0);
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"alpha"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"alpha"];
}

+(void)popScale:(UIView*)view x:(CGFloat)x y:(CGFloat)y repeat:(BOOL)repeat
               duration:(CGFloat)duration beginTime:(CGFloat)beginTime
        completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(x,y)];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.beginTime = CACurrentMediaTime() + beginTime;
    anim.duration = duration;
    if(repeat)
    {
        anim.repeatForever = YES;
        anim.autoreverses  = YES;
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"scale"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"scale"];
}

+(void)popCenter:(UIView*)view x:(CGFloat)x y:(CGFloat)y repeat:(BOOL)repeat
                duration:(CGFloat)duration beginTime:(CGFloat)beginTime
         completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(x,y)];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if(repeat)
    {
        anim.repeatForever = YES;
        anim.autoreverses  = YES;
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"center"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"center"];
}

+(void)popColored:(UIView*)view color:(UIColor*)color repeat:(BOOL)repeat
         duration:(CGFloat)duration beginTime:(CGFloat)beginTime
  completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    anim.toValue = color;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.beginTime = CACurrentMediaTime() + beginTime;
    anim.duration = duration;
    if(repeat)
    {
        anim.repeatForever = YES;
        anim.autoreverses  = YES;
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"color"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"color"];
}

+(void)popAppear:(UIView*)appear disappear:(UIView*)disappear
        duration:(CGFloat)duration beginTime:(CGFloat)beginTime
 completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *appearAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    appearAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    appearAnim.duration  = duration;
    appearAnim.beginTime = CACurrentMediaTime() + beginTime;
    appearAnim.fromValue = @(0.0);
    appearAnim.toValue   = @(1.0);
    appearAnim.completionBlock = ^(POPAnimation *ani, BOOL fin){
    if(fin)[appear pop_removeAnimationForKey:@"appear"];};
    [appear pop_addAnimation:appearAnim forKey:@"appear"];
    
    POPBasicAnimation *disAppearAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    disAppearAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    disAppearAnim.duration  = duration;
    disAppearAnim.beginTime = CACurrentMediaTime() + beginTime;
    disAppearAnim.fromValue   = @(1.0);
    disAppearAnim.toValue     = @(0.0);
    disAppearAnim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin){[disappear pop_removeAnimationForKey:@"disapear"];}
                    BLOCK_EXEC(completionBlock);};
    [disappear pop_addAnimation:disAppearAnim forKey:@"disapear"];
    
}

+(void)popAppearFromMini:(UIView*)view  beginTime:(CGFloat)beginTime completionBlock:(void(^)())completionBlock
{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    anim.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2,0.2)];
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0,1.0)];
    anim.beginTime = CACurrentMediaTime() + beginTime;
    anim.springBounciness = 15.f;
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"springAppear"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"springAppear"];
}


@end
