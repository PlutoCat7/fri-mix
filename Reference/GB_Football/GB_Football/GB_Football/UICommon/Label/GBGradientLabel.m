//
//  GBGradientLabel.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGradientLabel.h"

@implementation GBGradientLabel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    UIColor *startColor = [UIColor clearColor];
    UIColor *endColor   = [UIColor whiteColor];
    gradient.colors = @[(id)endColor.CGColor,(id)startColor.CGColor, (id)endColor.CGColor];
    gradient.startPoint = CGPointMake(0, 0);//(左，下)
    gradient.endPoint = CGPointMake(1, 0);//(右，下)
    gradient.locations = @[@.2,@.5,@.8];
    
    self.layer.mask = gradient;
    CABasicAnimation * gradientanimation = [CABasicAnimation animationWithKeyPath:@"locations"];
    gradientanimation.fromValue = @[@0, @0,@0.25];
    gradientanimation.toValue = @[@0.75,@1 ,@1];
    gradientanimation.duration = 5.0;
    gradientanimation.repeatCount = HUGE;
    [gradient addAnimation:gradientanimation forKey:@"gradientanimation"];
}


@end
