//
//  GBCountDownButton.m
//  GB_Football
//
//  Created by Pizza on 16/8/2.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBCountDownButton.h"

@interface GBCountDownButton()
@property (nonatomic) NSInteger currentSeconds;
@property (nonatomic) NSInteger countdownSeconds;
@property (nonatomic, strong) NSTimer *timer;
- (void)updateButton;
- (void)stopTimer;

@end


@implementation GBCountDownButton

#pragma mark - life cycle

- (void)dealloc
{
    [self stopTimer];
}

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private instance methods
- (void)setup
{
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:self.titleLabel.text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    self.titleLabel.attributedText = content;
}
-(void)touchDown
{
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:5.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.backgroundColor = [UIColor greenColor];
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:50.f options:
         UIViewAnimationOptionCurveEaseOut animations:^{
                     self.transform = CGAffineTransformMakeScale(1.0, 1.0);
             self.backgroundColor = [UIColor clearColor];
         } completion:^(BOOL finished){}];
    } completion:^(BOOL finished){}];
}
- (void)startCountDown:(NSInteger)seconds
{
    self.userInteractionEnabled = NO;
    [self setEnabled:NO];
    self.currentSeconds = seconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateButton) userInfo:nil repeats:YES];
    [self updateButton];
}

- (void)stopCountDown
{
    [self stopTimer];
    self.userInteractionEnabled = YES;
    [self setEnabled:YES];
}

#pragma mark - private functions

- (void)updateButton
{
    self.isCountdown = YES;
    self.currentSeconds--;
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li%@", (long)self.currentSeconds, LS(@"秒后重新发送")]];
    [self setAttributedTitle:title forState:UIControlStateDisabled];
    if (self.currentSeconds <= 0) {
        [self stopTimer];
        self.userInteractionEnabled = YES;
        [self setEnabled:YES];
        
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:LS(@"获取验证码")];
        NSRange contentRange = {0,[content length]};
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        [self setAttributedTitle:content forState:UIControlStateNormal];
        
    } else {
        [self setEnabled:NO];
    }
}

- (void)stopTimer
{
    self.isCountdown = NO;
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
