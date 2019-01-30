//
//  GBFourCornerView.m
//  GB_Football
//
//  Created by Pizza on 16/8/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBFourCorner.h"
#import "XXNibBridge.h"

@interface GBFourCorner()<XXNibBridge>
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *whiteCollect;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *redCollect;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *headCollect;

@end

@implementation GBFourCorner

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupAnimation];
}

-(void)dealloc
{
    for (UIImageView *view in self.headCollect) {
        [view.layer removeAllAnimations];
    }
}

-(void)setupAnimation
{
    for (UIImageView *view in self.headCollect)
    {
        [self rotate:YES duration:1.5f layer:view.layer];
    }
}

- (IBAction)actionPressCorner:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(GBFourCorner:didSelectAtIndex:)]) {
        [self.delegate GBFourCorner:self didSelectAtIndex:button.tag];
    }
}

-(void)setPointA:(STATE_CORNER)pointA
{
    switch (pointA)
    {
        case STATE_WHITE:
            ((UIImageView*)self.whiteCollect[0]).hidden = NO;
            ((UIImageView*)self.redCollect[0]).hidden   = YES;
            ((UIImageView*)self.headCollect[0]).hidden  = YES;
            break;
        case STATE_RED:
            ((UIImageView*)self.whiteCollect[0]).hidden = YES;
            ((UIImageView*)self.redCollect[0]).hidden   = NO;
            ((UIImageView*)self.headCollect[0]).hidden  = YES;
            break;
        case STATE_HEAD:
            ((UIImageView*)self.whiteCollect[0]).hidden = YES;
            ((UIImageView*)self.redCollect[0]).hidden   = YES;
            ((UIImageView*)self.headCollect[0]).hidden  = NO;
            break;
        default:
            break;
    }
}
-(void)setPointB:(STATE_CORNER)pointB
{
    switch (pointB)
    {
        case STATE_WHITE:
            ((UIImageView*)self.whiteCollect[1]).hidden = NO;
            ((UIImageView*)self.redCollect[1]).hidden   = YES;
            ((UIImageView*)self.headCollect[1]).hidden  = YES;
            break;
        case STATE_RED:
            ((UIImageView*)self.whiteCollect[1]).hidden = YES;
            ((UIImageView*)self.redCollect[1]).hidden   = NO;
            ((UIImageView*)self.headCollect[1]).hidden  = YES;
            break;
        case STATE_HEAD:
            ((UIImageView*)self.whiteCollect[1]).hidden = YES;
            ((UIImageView*)self.redCollect[1]).hidden   = YES;
            ((UIImageView*)self.headCollect[1]).hidden  = NO;
            break;
        default:
            break;
    }
}
-(void)setPointC:(STATE_CORNER)pointC
{
    switch (pointC)
    {
        case STATE_WHITE:
            ((UIImageView*)self.whiteCollect[2]).hidden = NO;
            ((UIImageView*)self.redCollect[2]).hidden   = YES;
            ((UIImageView*)self.headCollect[2]).hidden  = YES;
            break;
        case STATE_RED:
            ((UIImageView*)self.whiteCollect[2]).hidden = YES;
            ((UIImageView*)self.redCollect[2]).hidden   = NO;
            ((UIImageView*)self.headCollect[2]).hidden  = YES;
            break;
        case STATE_HEAD:
            ((UIImageView*)self.whiteCollect[2]).hidden = YES;
            ((UIImageView*)self.redCollect[2]).hidden   = YES;
            ((UIImageView*)self.headCollect[2]).hidden  = NO;
            break;
        default:
            break;
    }
}

-(void)setPointD:(STATE_CORNER)pointD
{
    switch (pointD)
    {
        case STATE_WHITE:
            ((UIImageView*)self.whiteCollect[3]).hidden = NO;
            ((UIImageView*)self.redCollect[3]).hidden   = YES;
            ((UIImageView*)self.headCollect[3]).hidden  = YES;
            break;
        case STATE_RED:
            ((UIImageView*)self.whiteCollect[3]).hidden = YES;
            ((UIImageView*)self.redCollect[3]).hidden   = NO;
            ((UIImageView*)self.headCollect[3]).hidden  = YES;
            break;
        case STATE_HEAD:
            ((UIImageView*)self.whiteCollect[3]).hidden = YES;
            ((UIImageView*)self.redCollect[3]).hidden   = YES;
            ((UIImageView*)self.headCollect[3]).hidden  = NO;
            break;
        default:
            break;
    }
}

#pragma mark - Notification


-(void)rotate:(BOOL)isAnti duration:(CGFloat)duration layer:(CALayer*)layer
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.toValue = [NSNumber numberWithFloat:(isAnti?(-1):1)* M_PI * 2.0];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.cumulative = YES;
    animation.repeatCount = HUGE_VALF;
    [layer addAnimation:animation forKey:@"rotationAnimation"];
}

@end
