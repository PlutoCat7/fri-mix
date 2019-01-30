//
//  GBLipiCountDownButton.m
//  GB_Football
//
//  Created by Pizza on 2017/3/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBLipiCountDownButton.h"
#import <pop/POP.h>

@interface GBLipiCountDownButton()
@property (nonatomic) NSInteger currentSeconds;
@property (nonatomic) NSInteger countdownSeconds;
@property (nonatomic, strong) NSTimer *timer;
- (void)updateButton;
- (void)stopTimer;

@end

@implementation GBLipiCountDownButton

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
        [self setTitle:self.defaultTitle forState:UIControlStateNormal];
    }
    else
    {
        [self setEnabled:NO];
        [self setTitle:[NSString stringWithFormat:@"%@(%li)",self.defaultTitle,(long)self.currentSeconds]
              forState:UIControlStateNormal];
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


- (void)setButtonEnable:(BOOL)enble
{
    if ([self.timer isValid])
    {
        return;
    }
    [self setTitle:self.defaultTitle forState:UIControlStateNormal];
    self.userInteractionEnabled = enble;
    [self setEnabled:enble];
}

- (void)setup
{
    [self addTarget:self action:@selector(scaleToSmall)forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

-(void)touchDown
{
    self.backgroundColor = [UIColor blackColor];
    [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
}

-(void)touchUp
{
    self.backgroundColor = [UIColor colorWithHex:0x212121];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)setEnabled:(BOOL)enabled
{
    [self setTitleColor:enabled?[UIColor whiteColor]:[UIColor colorWithHex:0x909090] forState:UIControlStateNormal];
    [super setEnabled:enabled];
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.layer pop_removeAnimationForKey:@"layerScaleSmallAnimation"];
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 2.0f;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.layer pop_removeAnimationForKey:@"layerScaleSpringAnimation"];
    };
    
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.layer pop_removeAnimationForKey:@"layerScaleDefaultAnimation"];
    };
    
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}


@end
