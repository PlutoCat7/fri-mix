//
//  GBUpdateSlider.m
//  GB_Football
//
//  Created by Pizza on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBUpdateSlider.h"

@implementation GBUpdateSlider

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI
{
    UIImage *maxImg = [[UIImage imageNamed:@"black"]  stretchableImageWithLeftCapWidth:0.0 topCapHeight:0];
    [self setMaximumTrackImage:maxImg forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"empty"] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"empty"] forState:UIControlStateHighlighted];
}

-(void)setSliderColor:(SLIDER_COLOR)sliderColor
{
    _sliderColor = sliderColor;
    switch (sliderColor) {
        case COLOR_GREEN:
        {
            [self setMinimumTrackImage:[[UIImage imageNamed:@"green"]
                                        stretchableImageWithLeftCapWidth:0.0 topCapHeight:0]
                              forState:UIControlStateNormal];
        }
            break;
        case COLOR_RED:
        {
            [self setMinimumTrackImage:[[UIImage imageNamed:@"red"]
                                        stretchableImageWithLeftCapWidth:0.0 topCapHeight:0]
                              forState:UIControlStateNormal];
        }
            break;
        case COLOR_CYAN:
        {
            [self setMinimumTrackImage:[[UIImage imageNamed:@"cyan"]
                                        stretchableImageWithLeftCapWidth:0.0 topCapHeight:0]
                              forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, self.width,5);
}

@end
