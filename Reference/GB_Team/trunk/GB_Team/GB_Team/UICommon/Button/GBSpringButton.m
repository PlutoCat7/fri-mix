//
//  GBSpringButton.m
//  GB_Team
//
//  Created by Pizza on 16/9/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSpringButton.h"
#import <pop/POP.h>

@implementation GBSpringButton

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
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.layer pop_removeAnimationForKey:@"ScaleSmallAnimation"];
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:@"ScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.layer pop_removeAnimationForKey:@"SpringAnimation"];
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:@"SpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.layer pop_removeAnimationForKey:@"ScaleDefaultAnimation"];
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:@"ScaleDefaultAnimation"];
}

@end
