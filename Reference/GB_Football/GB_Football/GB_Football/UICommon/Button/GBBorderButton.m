//
//  GBBorderButton.m
//  GB_Football
//
//  Created by Pizza on 2016/12/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBorderButton.h"
#import <pop/POP.h>

@interface GBBorderButton()
@property (nonatomic,strong) UIColor *nomalBorder;
@property (nonatomic,strong) UIColor *pressBorder;
@property (nonatomic,strong) UIColor *nomalText;
@property (nonatomic,strong) UIColor *pressText;
@property (nonatomic,strong) UIColor *nomalBack;
@property (nonatomic,strong) UIColor *pressBack;

@end
@implementation GBBorderButton

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
        [self setEnabled:NO];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
        [self setEnabled:NO];
    }
    return self;
}

-(void)setupNomalBorderColor:(UIColor*)normal pressColor:(UIColor*)pressColor
{
    self.nomalBorder = normal;
    self.pressBorder = pressColor;
    self.layer.borderColor = self.nomalBorder ? self.nomalBorder.CGColor :[UIColor clearColor].CGColor;
}

-(void)setupNomalTextColor:(UIColor*)normal pressColor:(UIColor*)pressColor
{
    self.nomalText = normal;
    self.pressText = pressColor;
    [self setTitleColor:self.nomalText ? self.nomalText : [self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
}
-(void)setupNomalBackColor:(UIColor*)normal     pressColor:(UIColor*)pressColor
{
    self.nomalBack = normal;
    self.pressBack = pressColor;
    [self setBackgroundColor:self.nomalBack ? self.nomalBack : [UIColor clearColor]];
}

#pragma mark - Setup

- (void)setup
{
    [self setTitleColor:self.nomalText ? self.nomalText : [self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.layer.borderWidth = .5f;
    self.layer.borderColor = self.nomalBorder ? self.nomalBorder.CGColor :[UIColor clearColor].CGColor;
    [self setTitleColor:[UIColor colorWithHex:0x3f3f3f] forState:UIControlStateDisabled];
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(scaleToSmall)forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(scaleAnimation)forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(scaleToDefault)forControlEvents:UIControlEventTouchDragExit];
}

-(void)touchDown
{
    self.layer.borderColor = self.pressBorder ? self.pressBorder.CGColor :[UIColor clearColor].CGColor;
    [self setTitleColor:self.pressText ? self.pressText : [self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.backgroundColor = self.pressBack?self.pressBack:[UIColor clearColor];
}

-(void)touchUp
{
    self.layer.borderColor = self.nomalBorder ? self.nomalBorder.CGColor :[UIColor clearColor].CGColor;
    [self setTitleColor:self.nomalText ? self.nomalText : [self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.backgroundColor = self.nomalBack?self.nomalBack:[UIColor clearColor];
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
