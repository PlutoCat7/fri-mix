//
//  GBBaseAlertView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseAlertView.h"

#import <pop/POP.h>

@implementation GBBaseAlertView

-(void)dealloc
{
    [self.backgroundView pop_removeAllAnimations];
    [self.animationView.layer pop_removeAllAnimations];
}

- (void)showPopBox {
    
    self.backgroundView.alpha = 0;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = NO;
        self.backgroundView.alpha = 1.f;
        [self.backgroundView pop_removeAnimationForKey:@"alpha"];
    };
    [self.backgroundView pop_addAnimation:anim forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        if(finish)[self.animationView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.animationView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)hidePopBox
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = YES;
        self.backgroundView.alpha = 0.f;
        [self.backgroundView pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
    };
    [self.backgroundView pop_addAnimation:anim forKey:@"alpha"];
}
@end
