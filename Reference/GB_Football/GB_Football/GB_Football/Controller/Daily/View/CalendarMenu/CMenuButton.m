//
//  CMenuButton.m
//  GB_Football
//
//  Created by gxd on 17/6/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "CMenuButton.h"
#import "CMenuConfiguration.h"

@implementation CMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        frame.origin.y -= 2.0;
        self.title = [[UILabel alloc] initWithFrame:frame];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        self.title.textColor = currentStyle[NSForegroundColorAttributeName];
        self.title.font = currentStyle[NSFontAttributeName];
        
        NSShadow *shadow = currentStyle[NSShadowAttributeName];
        if (shadow) {
            self.title.shadowColor = shadow.shadowColor;
            self.title.shadowOffset = shadow.shadowOffset;
        }
        [self addSubview:self.title];
        
        self.arrow = [[UIImageView alloc] initWithImage:[CMenuConfiguration arrowImage]];
        [self addSubview:self.arrow];
    }
    return self;
}

- (void)layoutSubviews {
    [self.title sizeToFit];
    self.title.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-2.0)/2);
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.title.frame) + [CMenuConfiguration arrowPadding], self.frame.size.height / 2);
}

#pragma mark -
#pragma mark Handle taps
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isActive = !self.isActive;
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //    self.spotlightGradientRef = nil;
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    //    self.spotlightGradientRef = nil;
}

#pragma mark - Drawing Override
- (void)drawRect:(CGRect)rect{
}


#pragma mark - Factory Method

+ (CGGradientRef)newSpotlightGradient
{
    size_t locationsCount = 2;
    CGFloat locations[2] = {1.0f, 0.0f,};
    CGFloat colors[12] = {0.0f,0.0f,0.0f,0.0f,
        0.0f,0.0f,0.0f,0.55f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}

- (void)setSpotlightGradientRef:(CGGradientRef)newSpotlightGradientRef
{
    CGGradientRelease(_spotlightGradientRef);
    _spotlightGradientRef = nil;
    
    _spotlightGradientRef = newSpotlightGradientRef;
    CGGradientRetain(_spotlightGradientRef);
    
    [self setNeedsDisplay];
}

#pragma mark - Deallocation

- (void)dealloc{
    [self setSpotlightGradientRef:nil];
}


@end
