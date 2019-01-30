//
//  GBHardUpdateView.m
//  GB_Football
//
//  Created by Pizza on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBHardUpdateView.h"
#import "GBUpdateSlider.h"
#import <pop/POP.h>
#import "GBBoxButton.h"
#import "RTLabel.h"
#import "GBAlertLiPiUpdate.h"
#import "GBAlertRestartBle.h"

#define kUpdateCountDown 15

@interface GBHardUpdateView()

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *textStateLabel;
@property (weak, nonatomic) IBOutlet GBUpdateSlider *slider;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *tipsStLabel;
@property (weak, nonatomic) IBOutlet GBBoxButton *retryButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *closeButton;
// 国际化
@property (weak, nonatomic) IBOutlet UILabel *titleStLabel;
@property (weak, nonatomic) IBOutlet RTLabel *tipStLabel1;
@property (weak, nonatomic) IBOutlet RTLabel *tipStLabel2;
@property (weak, nonatomic) IBOutlet RTLabel *tipStLabel3;
// 弹出框蒙版
@property (weak, nonatomic) IBOutlet UIView *popMaskView;
// 里皮版弹出框
@property (weak, nonatomic) GBAlertLiPiUpdate *lipiUpdateBox;

@property (nonatomic) NSInteger currentSeconds;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GBHardUpdateView

- (IBAction)actionClose:(id)sender {
    [self remove];
    BLOCK_EXEC(self.didClickButton, 0);
}

- (IBAction)actionConnect:(id)sender {
    [self remove];
    BLOCK_EXEC(self.didClickButton, 1);
}

-(void)showLiPiFinishBox
{
    [GBAlertLiPiUpdate showWithTitle:LS(@"lipi.update.popbox.title")
                             content:LS(@"lipi.update.popbox.restart.content")
                       buttonStrings:@[LS(@"lipi.update.popbox.retry"),LS(@"lipi.update.popbox.close")]
                                onOk:^{
                                    [self remove];
                                    BLOCK_EXEC(self.didClickButton, 1);
                                }onCancel:^{
                                    [self remove];
                                    BLOCK_EXEC(self.didClickButton, 0);
                                }];
}

-(void)showLiPiFinishRestartBleBox
{
    [GBAlertRestartBle showUpdateHint:^{
                                    [self remove];
                                    BLOCK_EXEC(self.didClickButton, 0);
                                }];
}

-(void)localizeUI
{
    self.titleStLabel.text = LS(@"firmware.popbox.title");
    self.tipsStLabel.text = LS(@"firmware.label.notice");
    [self.retryButton setTitle:LS(@"firmware.popbox.btn.again") forState:UIControlStateNormal];
    [self.closeButton setTitle:LS(@"firmware.popbox.btn.close") forState:UIControlStateNormal];
    self.tipStLabel1.text = LS(@"firmware.label.tip1");
    self.tipStLabel2.text = LS(@"firmware.label.tip2");
    self.tipStLabel3.text = LS(@"firmware.label.tip3");
    self.tipStLabel1.textAlignment = RTTextAlignmentCenter;
    self.tipStLabel2.textAlignment = RTTextAlignmentCenter;
    self.tipStLabel3.textAlignment = RTTextAlignmentCenter;
    self.tipStLabel1.font = FONT_ADAPT(13.f);
    self.tipStLabel2.font = FONT_ADAPT(13.f);
    self.tipStLabel3.font = FONT_ADAPT(13.f);
}
// 设置状态
-(void)setupState:(HARD_STATE)state
{
    switch (state)
    {
        case STATE_IDLE:
        {
            self.textStateLabel.text = LS(@"firmware.label.downloading");
            self.percentLabel.text   = LS(@"0");
            self.slider.value = 0.f;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
            break;
        case STATE_DOWNLOADING:
        {
             self.textStateLabel.text = LS(@"firmware.label.downloading");
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
            break;
        case STATE_DOWNLOAD_FINISH:
        {
             self.textStateLabel.text = LS(@"firmware.label.downfinish");
            self.percentLabel.text   = LS(@"100");
            self.slider.value = 1.f;
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
            break;
        case STATE_PROGRAMMING:
        {
            self.textStateLabel.text = LS(@"firmware.label.writting");
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
            break;
        case STATE_PROGRAM_FINISH:
        {
            self.textStateLabel.text = LS(@"firmware.label.writefinish");
            self.percentLabel.text   = LS(@"100");
            self.slider.value = 1.f;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            if (self.deviceUpdateType == UPDATE_TYPE_HAVE_BUTTON)
            {
                [self showPopBox];
            }
            else if  (self.deviceUpdateType == UPDATE_TYPE_NO_BUTTON)
            {
                //[self showLiPiFinishBox];
#warning 固件加入微信后再打开
                [self startCountDown:kUpdateCountDown];
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)startCountDown:(NSInteger)seconds
{
    self.currentSeconds = seconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTipsLabel) userInfo:nil repeats:YES];
    [self updateTipsLabel];
}

- (void)stopTimer
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateTipsLabel
{
    self.currentSeconds--;
    self.tipsStLabel.text = [NSString stringWithFormat:@"%@(%li)",LS(@"lipi.update.popbox.restart.hint"),(long)self.currentSeconds];
    
    if (self.currentSeconds <= 0)
    {
        [self stopTimer];
        
        // 没有按键即2代手环，在2.20及之前的版本做升级，要提示重新打开蓝牙,在2.20后有加入微信运动的服务
        float firmVersion = [self.firmversion floatValue];
        if (firmVersion <= 2.20+0.0001) {
            [self showLiPiFinishRestartBleBox];
        } else {
            [self showLiPiFinishBox];
        }
        
        self.tipsStLabel.text = LS(@"firmware.label.notice");
    }
}

-(void)setPercent:(CGFloat)percent
{
    _percent = percent;
    self.slider.value = (_percent*1.f)/100;
    self.percentLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
}


// 显示
-(void)show
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backView.alpha = 0.f;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(0.0);
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        [self.backView pop_removeAnimationForKey:@"alpha"];
    };
    [self.backView pop_addAnimation:anim forKey:@"alpha"];
    
    [self localizeUI];
    [self setupState:STATE_IDLE];
}

// 移除
-(void)remove
{
    self.popMaskView.alpha = 0.f;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.toValue = @(0.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        [self.backView pop_removeAnimationForKey:@"alpha"];
        [self removeFromSuperview];
    };
    [self.backView pop_addAnimation:anim forKey:@"alpha"];
}


- (void)showPopBox {
    
    self.boxView.alpha = 0;
    self.popMaskView.alpha = 0;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.toValue = @(1.0);
    anim.completionBlock = ^(POPAnimation * animation, BOOL finish){
        self.boxView.alpha = 1.f;
        self.popMaskView.alpha = 1.f;
        [self.boxView pop_removeAnimationForKey:@"alpha"];
    };
    [self.boxView pop_addAnimation:anim forKey:@"alpha"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        [self.boxView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.boxView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void)dealloc
{
    [self.boxView.layer pop_removeAllAnimations];
    [self.boxView pop_removeAllAnimations];
    [self.backView pop_removeAllAnimations];
}
@end
