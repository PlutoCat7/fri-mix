//
//  GBCircleHub.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/15.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBCircleHub.h"
#import "XXNibBridge.h"
#import <objc/runtime.h>

@interface GBCircleHub()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIImageView *outsideCircle;
@property (weak, nonatomic) IBOutlet UIImageView *insideCircle;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation GBCircleHub

static char kSuperViewKey;
+ (void)setParentView:(UIView *)view {
    
    objc_setAssociatedObject(self, &kSuperViewKey, view, OBJC_ASSOCIATION_RETAIN);
}

+ (UIView *)parentView {
    
    return objc_getAssociatedObject(self, &kSuperViewKey);
}


+ (GBCircleHub *)showWithTip:(NSString*)tip view:(UIView *)view
{
    GBCircleHub *hud = [[[NSBundle mainBundle] loadNibNamed:@"GBCircleHub" owner:nil options:nil] objectAtIndex:0];
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self setParentView:view];
    hud.frame = view.bounds;
    hud.tipLabel.text = tip;
    [view addSubview:hud];
    [hud start];
    return hud;
}

+ (GBCircleHub *)show
{
    GBCircleHub *hud = [[[NSBundle mainBundle] loadNibNamed:@"GBCircleHub" owner:nil options:nil] objectAtIndex:0];
    hud.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud start];
    return hud;
}



+ (void)hideAll {
    
    UIView *view = [self parentView];
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBCircleHub class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            GBCircleHub *hud = (GBCircleHub *)aView;
            [hud hide];
        }
    }
}

- (void)hide {

    [self stop];
    [self removeFromSuperview];

}

- (void)changeText:(NSString*)string {
    
    [self.tipLabel setText:string];
}

#pragma mark - Private

-(void)start
{
    [self rotate:YES duration:1.0 layer:self.insideCircle.layer];
    [self rotate:NO  duration:2.0 layer:self.outsideCircle.layer];
}

-(void)stop
{
    [self.insideCircle.layer removeAllAnimations];
    [self.outsideCircle.layer removeAllAnimations];
}

-(void)rotate:(BOOL)isAnti duration:(CGFloat)duration layer:(CALayer*)layer
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:(isAnti?(-1):1)* M_PI * 2.0];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [layer addAnimation:animation forKey:@"rotationAnimation"];
}

@end
