//
//  GBGameTypeDescView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGameTypeDescView.h"
#import <pop/POP.h>

@interface GBGameTypeDescView ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;


@end

@implementation GBGameTypeDescView

+ (void)showWithGameType:(GameType)gameType {
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBGameTypeDescView" owner:nil options:nil];
    GBGameTypeDescView *preView = [xibArray firstObject];
    preView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    preView.descImageView.image = gameType==GameType_Define?[UIImage imageNamed:@"explain_b"]:[UIImage imageNamed:@"explain_a"];
    [[UIApplication sharedApplication].keyWindow addSubview:preView];
    [preView showPopBox];
}
#pragma mark - Action

- (IBAction)cancelEvent:(id)sender {
    
    [self hidePopBox];
}

#pragma mark - Private

- (void)showPopBox {
    
    self.tipBack.alpha = 0;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = NO;
        self.tipBack.alpha = 1.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        [self.descImageView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.descImageView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)hidePopBox
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = YES;
        self.tipBack.alpha = 0.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
}

-(void)dealloc
{
    [self.descImageView.layer pop_removeAllAnimations];
    [self.tipBack pop_removeAllAnimations];
}

@end
