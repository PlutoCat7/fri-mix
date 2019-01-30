//
//  BasePopAlertView.m
//  FWRACProject
//
//  Created by apple on 2017/6/7.
//  Copyright © 2017年 he. All rights reserved.
//

#import "BasePopAlertView.h"
#import <POP.h>

@interface BasePopAlertView ()

@property (nonatomic,assign) PopAlertViewDirection currentDirection;

@property (nonatomic,strong) UIView *contentView;

@end

@implementation BasePopAlertView


- (void)showWithContentView:(UIView *)contentView direction:(PopAlertViewDirection)direction{
    self.currentDirection = direction;
    self.contentView = contentView;
    
    [self animationWithShow:YES];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = window.rootViewController;
    [window.rootViewController.view addSubview:self];
}

- (void)showFromRootVCWithContentView:(UIView *)contentView direction:(PopAlertViewDirection)direction{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //任务中心控制器
    UITabBarController *tabVC =  (UITabBarController *)delegate.window.rootViewController;
  
    [tabVC.view addSubview:self];
    
    self.currentDirection = direction;
    self.contentView = contentView;
    
    [self animationWithShow:YES];
}

- (void)dismissAlertView{
    
    [self animationWithShow:NO];
    
}

- (void)animationWithShow:(BOOL)isShow{
    switch (self.currentDirection) {
        case PopAlertViewDirectionUp:{
            [self upAnimate:isShow];
        }
            break;
        case PopAlertViewDirectionDown:{
            [self downAnimate:isShow];
        }
            break;
        case PopAlertViewDirectionLeft:{
            [self leftAnimate:isShow];
        }
            break;
        case PopAlertViewDirectionRight:{
            [self RightAnimate:isShow];
        }
            break;
        case PopAlertViewDirectionCenter:{
            [self centerAnimate:isShow];
        }
            break;
        case PopAlertViewDirectionBottom:{
            [self bottomAnimate:isShow];
        }
            break;
        default:
            break;
    }
}

- (void)bottomAnimate:(BOOL)isShow{
    
    NSValue *startPoint = [NSValue valueWithCGPoint:CGPointMake(kScreen_Width/2, kScreen_Height + self.contentView.height/2)];
    NSValue *endPoint = [NSValue valueWithCGPoint:CGPointMake(kScreen_Width/2, kScreen_Height-260/2.0)];
    NSString *animateKey = @"showAnimate";
    
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    if (isShow) {
        animate.fromValue = startPoint;
        animate.toValue = endPoint;
        
    }else{
        animate.fromValue = endPoint;
        animate.toValue = startPoint;
        animateKey = @"dismissAnimate";
        WS(weakSelf);
        [animate setCompletionBlock:^(POPAnimation *prop, BOOL fint){
            
            [weakSelf removeFromSuperview];
        }];
        [self dismissAlp];
    }
    
    [self.contentView pop_addAnimation:animate forKey:animateKey];
}

/**
 从下往上

 @param isShow 是否是出现
 */
- (void)upAnimate:(BOOL)isShow {
    
    [self animationVerticalWithStartPointY:kScreen_Height + self.contentView.height/2 showStatus:isShow];
}

/**
 从上往下
 
 @param isShow 是否是出现
 */
- (void)downAnimate:(BOOL)isShow {
    
    [self animationVerticalWithStartPointY:-self.contentView.height/2 showStatus:isShow];
}

/**
 从左往右
 
 @param isShow 是否是出现
 */
- (void)leftAnimate:(BOOL)isShow {
    
    [self animationVerticalWithStartPointY:-self.contentView.width/2 showStatus:isShow];
}

/**
 从右往左
 
 @param isShow 是否是出现
 */
- (void)RightAnimate:(BOOL)isShow {
    
    [self animationVerticalWithStartPointY:self.contentView.width/2 +kScreen_Width showStatus:isShow];
}

/**
 中心动画

 @param isShow 是否显示
 */
- (void)centerAnimate:(BOOL)isShow{

    self.superview.origin = CGPointMake(0, 0);
    self.contentView.center = self.superview.center;
    
    NSValue *startSize = [NSValue valueWithCGSize:CGSizeMake(0.01, 0.01)];
    NSValue *endSize = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    NSString *animateKey = @"showAnimate";
    
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    
    if (isShow) {
        animate.fromValue = startSize;
        animate.toValue = endSize;
        
    }else{
        animate.fromValue = endSize;
        animate.toValue = startSize;
        animateKey = @"dismissAnimate";
        WS(weakSelf);
        [animate setCompletionBlock:^(POPAnimation *prop, BOOL fint){
            weakSelf.contentView = nil;
            [weakSelf removeFromSuperview];
        }];
        [self dismissAlp];
    }
    
    [self.contentView pop_addAnimation:animate forKey:animateKey];
}


/**
 垂直动画

 @param y 移动的y
 @param isShow 是否显示
 */
- (void)animationVerticalWithStartPointY:(CGFloat)y showStatus:(BOOL)isShow{
    
    NSValue *startPoint = [NSValue valueWithCGPoint:CGPointMake(kScreen_Width/2, y)];
    NSValue *endPoint = [NSValue valueWithCGPoint:CGPointMake(kScreen_Width/2, kScreen_Height/2)];
    NSString *animateKey = @"showAnimate";
    
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    if (isShow) {
        animate.fromValue = startPoint;
        animate.toValue = endPoint;
        
    }else{
        animate.fromValue = endPoint;
        animate.toValue = startPoint;
        animateKey = @"dismissAnimate";
        WS(weakSelf);
        [animate setCompletionBlock:^(POPAnimation *prop, BOOL fint){
            
            [weakSelf removeFromSuperview];
        }];
        [self dismissAlp];
    }
    
    [self.contentView pop_addAnimation:animate forKey:animateKey];
    
}

/**
 水平动画

 @param x 移动的x
 @param isShow 是否显示
 */
- (void)animationHorizontalWithStartPointX:(CGFloat)x showStatus:(BOOL)isShow{
    
    NSValue *startPoint = [NSValue valueWithCGPoint:CGPointMake(x, kScreen_Height/2)];
    NSValue *endPoint = [NSValue valueWithCGPoint:CGPointMake(kScreen_Width/2, kScreen_Height/2)];
    NSString *animateKey = @"showAnimate";
    
    POPSpringAnimation *animate = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    
    if (isShow) {
        animate.fromValue = startPoint;
        animate.toValue = endPoint;
        
    }else{
        animate.fromValue = endPoint;
        animate.toValue = startPoint;
        animateKey = @"dismissAnimate";
        WS(weakSelf);
        [animate setCompletionBlock:^(POPAnimation *prop, BOOL fint){
            
            [weakSelf removeFromSuperview];
        }];
        [self dismissAlp];
    }
    
    [self.contentView pop_addAnimation:animate forKey:animateKey];
}


- (void)dismissAlp{
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 0;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
