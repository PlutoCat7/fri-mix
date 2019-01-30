//
//  AnimationBtnLogin.m
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/9.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AnimationBtnLogin.h"
#import "UIViewAnimation.h"

@interface AnimationBtnLogin()
{
    UIView *tagView;
}
@end

@implementation AnimationBtnLogin

-(void)AnimationBtnLoginWithTagView:(UIView *)view{
    WEAKSELF
    tagView = view;
    UIViewController *VC = [self viewController:view];
    XWLog(@"========%@",VC);
    //盖住view，以屏蔽掉点击事件
    _coverView = [[UIView alloc]initWithFrame:VC.view.bounds];
    _coverView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_coverView];
    
    //执行登录按钮转圈动画的view
    CGRect viewFrame = [VC.view convertRect:view.frame fromView:view.superview];
    _loginAnimView = [[UIView alloc] initWithFrame:viewFrame];
    _loginAnimView.layer.cornerRadius = kRKBHEIGHT(25);
    _loginAnimView.layer.masksToBounds = YES;
    _loginAnimView.backgroundColor = view.backgroundColor;
    [_coverView addSubview:_loginAnimView];
    view.hidden = YES;
    //把view从宽的样子变圆
    CGPoint centerPoint = _loginAnimView.center;
    CGFloat radius = MIN(_loginAnimView.frame.size.width, _loginAnimView.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.loginAnimView.frame = CGRectMake(0, 0, radius, radius);
        weakSelf.loginAnimView.center = centerPoint;
        weakSelf.loginAnimView.layer.cornerRadius = radius/2;
        weakSelf.loginAnimView.layer.masksToBounds = YES;
    }completion:^(BOOL finished) {
        //给圆加一条不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:(radius/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.lineWidth = 1.5;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = view.backgroundColor.CGColor;
        shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        shapeLayer.path = path.CGPath;
        [weakSelf.loginAnimView.layer addSublayer:shapeLayer];
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [weakSelf.loginAnimView.layer addAnimation:baseAnimation forKey:nil];
    }];
    
}

-(void)RemoveAnimationBtnLogin{
    tagView.hidden = NO;
    [_coverView removeFromSuperview];
    [_loginAnimView removeFromSuperview];
    [_loginAnimView.layer removeAllAnimations];
}

- (void)LoginFail{
    //把蒙版、动画view等隐藏，把真正的login按钮显示出来
    tagView.hidden = NO;
    [_coverView removeFromSuperview];
    [_loginAnimView removeFromSuperview];
    [_loginAnimView.layer removeAllAnimations];
    //给按钮添加左右摆动的效果(路径动画)
    CAKeyframeAnimation *keyFrame = [UIViewAnimation getSwingAnimationWithPoint:_loginAnimView.layer.position IsX:YES];
    [tagView.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}


- (UIViewController *)viewController:(UIView *)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
