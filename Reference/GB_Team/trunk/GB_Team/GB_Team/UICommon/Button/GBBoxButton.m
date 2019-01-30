//
//  GBBoxButton.m
//  GB_Football
//
//  Created by Pizza on 16/8/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBoxButton.h"
#import <pop/POP.h>

#define JUMP_TAG 777

@implementation GBBoxButton

#pragma mark - Life Cycle

-(void)dealloc
{
    [self.layer pop_removeAllAnimations];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0,0,0,0)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    [self addTarget:self action:@selector(scaleToSmall)forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)forControlEvents:UIControlEventTouchDragExit];
    if (self.tag == JUMP_TAG) {
        [self addTarget:self action:@selector(touchDownJump) forControlEvents:UIControlEventTouchDown];
    }
    else
    {
        [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    }
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

-(void)touchDown
{
    self.backgroundColor = [UIColor blackColor];
    [self setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
}

-(void)touchDownJump
{
    self.backgroundColor = [UIColor blackColor];
    [self setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
}

-(void)touchUp
{
    self.backgroundColor = [UIColor colorWithHex:0x212121];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)setEnabled:(BOOL)enabled
{
    self.backgroundColor = enabled?[ColorManager styleColor]:[ColorManager disableColor];
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