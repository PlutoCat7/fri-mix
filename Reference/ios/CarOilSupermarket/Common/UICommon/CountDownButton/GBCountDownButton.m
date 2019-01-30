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
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
    [self attributeTitle:@"获取验证码" underLine:NO buttonEnable:YES];
}
-(void)touchUp
{
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:5.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:50.f options:
         UIViewAnimationOptionCurveEaseOut animations:^{
                     self.transform = CGAffineTransformMakeScale(1.0, 1.0);
         } completion:^(BOOL finished){}];
    } completion:^(BOOL finished){}];
}

- (void)startCountDown:(NSInteger)seconds
{
    self.userInteractionEnabled = NO;
    self.currentSeconds = seconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateButton) userInfo:nil repeats:YES];
    [self updateButton];
}

- (void)startCountDown
{
    [self startCountDown:self.countdownSeconds];
}

- (void)stopCountDown
{
    [self stopTimer];
    self.userInteractionEnabled = YES;
}

#pragma mark - private functions

- (void)updateButton
{
    self.currentSeconds--;
    if (self.currentSeconds <= 0)
    {
        [self stopTimer];
        self.userInteractionEnabled = YES;
        [self setEnabled:YES];
        [self attributeTitle:@"获取验证码" underLine:NO buttonEnable:YES];
    }
    else
    {
        [self setEnabled:NO];
        [self attributeTitle:[NSString stringWithFormat:@"%td s", self.currentSeconds]
                   underLine:NO buttonEnable:YES];
    }
}

- (void)stopTimer
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(NSMutableAttributedString*)attributeTitle:(NSString*)string underLine:(BOOL)underLine buttonEnable:(BOOL)buttonEnable
{
    NSMutableAttributedString *content =[[NSMutableAttributedString alloc]initWithString:string];
    NSRange contentRange = {0,[content length]};
    if (underLine)
    {
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];

    }
    [content addAttribute:NSForegroundColorAttributeName
                    value:[UIColor whiteColor]
                    range:NSMakeRange(0,[content length])];
    if (buttonEnable)
    {
        [self setBackgroundColor:[ColorManager styleColor]];
    }
    else
    {
        [self setBackgroundColor:[ColorManager buttonDisableColor]];
    }
    [self setAttributedTitle:content forState:UIControlStateNormal];
    return content;
}

- (void)setButtonEnable:(BOOL)enble
{
    if ([self.timer isValid])
    {
        return;
    }
    [self attributeTitle:@"获取验证码" underLine:NO buttonEnable:enble];
    self.userInteractionEnabled = enble;
    [self setEnabled:enble];
}

@end
