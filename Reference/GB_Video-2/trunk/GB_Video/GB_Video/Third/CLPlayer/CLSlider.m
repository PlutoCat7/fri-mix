//
//  Slider.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/2.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "CLSlider.h"

#define SLIDER_X_BOUND 80
#define SLIDER_Y_BOUND 40
#define SLIDER_H_BOUND 2
#define SLIDER_H_BLOCK 12

@interface CLSlider ()

@end

@implementation CLSlider

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds {
    
    [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y, CGRectGetWidth(bounds), SLIDER_H_BOUND);
}

#pragma mark - Private

- (void)setup {
    
    UIImage *thumbImage = [UIImage imageNamed:@"cl_progress"];
    
    [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
}

@end
