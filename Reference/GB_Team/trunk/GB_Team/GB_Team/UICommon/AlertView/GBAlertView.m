//
//  GBAlertView.m
//  GB_Football
//
//  Created by wsw on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBAlertView.h"
#import "GBBoxButton.h"

#import <pop/POP.h>

@interface GBAlertView ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet GBBoxButton *okButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *cancelButton;

@property (nonatomic, copy) GBAlertViewCallBackBlock alertViewCallBackBlock;

@end

@implementation GBAlertView

+ (instancetype)alertWithCallBackBlock:(GBAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message cancelButtonName:(NSString *)cancelButtonName otherButtonTitle:(NSString *)otherButtonTitle {
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBAlertView" owner:nil options:nil];
    GBAlertView *alert = [xibArray firstObject];
    
    alert.titleLabel.text = title;
    [alert setContentText:message];
    [alert.cancelButton setTitle:cancelButtonName forState:UIControlStateNormal];
    [alert.okButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    if ([NSString stringIsNullOrEmpty:otherButtonTitle]) {
        alert.okButton.hidden = YES;
        alert.cancelButton.frame = alert.cancelButton.superview.bounds;
    }
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    [alert layout];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert showPopBox];
    
    return alert;
}

- (void)dismiss {
    
    [self cancelEvent:nil];
}

#pragma mark - Action

- (IBAction)cancelEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.alertViewCallBackBlock, 0);
}
- (IBAction)okEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.alertViewCallBackBlock, 1);
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
        if(finish)[self.boxView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.boxView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)hidePopBox
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.hidden = YES;
        self.tipBack.alpha = 0.f;
        [self.tipBack pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
    };
    [self.tipBack pop_addAnimation:anim forKey:@"alpha"];
}

- (void)layout {
    
    self.boxView.height = self.titleLabel.height+40+self.contentLabel.height+52+self.cancelButton.height+30;
    self.boxView.centerY = [self height]/2;
    self.boxView.centerX = [self width]/2;
    
    self.contentLabel.top = self.titleLabel.height+40;
    self.contentLabel.centerX = self.boxView.width/2;
    self.buttonView.bottom = self.boxView.height-30;
}

- (void)setContentText:(NSString *)text {
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [self.contentLabel setAttributedText:attributedString1];
    [self.contentLabel sizeToFit];
}

-(void)dealloc
{
    [self.tipBack pop_removeAllAnimations];
    [self.boxView.layer pop_removeAllAnimations];
}

@end
