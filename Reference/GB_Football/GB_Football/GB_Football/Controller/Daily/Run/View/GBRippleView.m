//
//  GBRippleView.m
//  GB_Football
//
//  Created by gxd on 17/7/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBRippleView.h"
#import "XXNibBridge.h"
#import "UIColor+HEX.h"

#import <pop/POP.h>
#import "WaveView.h"
#import "RunLightView.h"

@interface GBRippleView()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIView *animView;
@property (weak, nonatomic) IBOutlet UIImageView *buttonImageView;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) RunLightView *progressView;

@end

@implementation GBRippleView

-(void)awakeFromNib
{
    [super awakeFromNib];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupButtonPressAnimation];
        [self setupProgressView];
    });
}

- (IBAction)actionClickBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.enabled = NO;
    
    CGRect animViewFrame = self.animView.frame;
    CGRect viewFrame = self.frame;
    CGPoint center = CGPointMake(animViewFrame.origin.x + animViewFrame.size.width/2.0f,
                                 animViewFrame.origin.y + animViewFrame.size.height/2.0f);
    [WaveView showInView:self center:center beginRadiu:animViewFrame.size.width/2.f endRadiu:viewFrame.size.width/2.f endBlock:^{
        button.enabled = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didRippleClick:)]) {
            [self.delegate didRippleClick:self];
        }
    }];
}


#pragma mark - 按钮动画

-(void)setupButtonPressAnimation {
    [self.actionButton addTarget:self action:@selector(scaleToSmall:)forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.actionButton addTarget:self action:@selector(scaleAnimation:)forControlEvents:UIControlEventTouchUpInside];
    [self.actionButton addTarget:self action:@selector(scaleToDefault:)forControlEvents:UIControlEventTouchDragExit];
}


-(void)scaleToSmall:(id)sender
{
    if (sender == self.actionButton) {
        sender = self.animView;
    }
    [self scaleWithView:sender value:[NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)]];
}

-(void)scaleToDefault:(id)sender
{
    if (sender == self.actionButton) {
        sender = self.animView;
    }
    [self scaleWithView:sender value:[NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)]];
}

-(void)scaleAnimation:(id)sender
{
    UIView *button = sender;
    if (button == self.actionButton) {
        button = self.animView;
    }
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [button.layer pop_removeAnimationForKey:@"layerScaleSpringAnimation"];
    };
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}


- (void)scaleWithView:(UIView *)view value:(NSValue *)value {
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = value;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [view.layer pop_removeAnimationForKey:@"layerScaleDefaultAnimation"];
    };
    [view.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

// 环形点进度条条初始化
-(void)setupProgressView
{
    self.progressView = [[RunLightView alloc]initWithFrame:CGRectInset(self.bounds, 0, 0)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.progressView setProgressStrokeColor:[UIColor clearColor]];
    [self.progressView setBackgroundStrokeColor:[UIColor clearColor]];
    self.progressView.hidden = YES;
    [self insertSubview:self.progressView atIndex:0];
}

// 流水灯动画开始
-(void)beginLedWithCompletionBlock
{
    dispatch_after ( dispatch_time ( DISPATCH_TIME_NOW ,0.3 * NSEC_PER_SEC ) , dispatch_get_main_queue ( ) , ^{
        self.progressView.hidden = NO;
        self.progressView.timeDuration = 2.f;
        [self.progressView setProgressStrokeColor:[UIColor colorWithHex:0x34cd67]];
        [self.progressView setBackgroundStrokeColor:[UIColor colorWithHex:0x333333]];
        [self.progressView beginRunLight];
    } ) ;
    
}

// 流水灯结束
-(void)endRingWithCompletionBlock
{
    self.progressView.hidden = YES;
    [self.progressView setProgressStrokeColor:[UIColor clearColor]];
    [self.progressView setBackgroundStrokeColor:[UIColor clearColor]];
    [self.progressView endRunLight];
}

#pragma mark - Getter & Setter

- (void)setButtonBackgroudImage:(UIImage *)backgroudImage {
    if (backgroudImage != nil) {
        [self.buttonImageView setImage:backgroudImage];
    }
}

- (void)setButtonBackgroudImageAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha; {
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.5;
    anim.beginTime = CACurrentMediaTime();
   
    anim.fromValue = @(fromAlpha);
    anim.toValue   = @(toAlpha);
   
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [self.buttonImageView pop_removeAnimationForKey:@"alpha"];
        }
    };
    [self.buttonImageView pop_addAnimation:anim forKey:@"alpha"];
}

- (void)setButtonFontSize:(NSInteger)fontSize {
    self.buttonLabel.font = [UIFont systemFontOfSize:fontSize];
    self.buttonLabel.textColor = [UIColor whiteColor];
}

- (void)setButtonTitle:(NSString*)title {
    self.buttonLabel.text = title;
}

@end
