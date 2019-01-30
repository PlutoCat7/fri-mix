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
    UIImage *maxImg = [[UIImage imageNamed:@"progress_bj"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0];
    UIImage *minImg = [[UIImage imageNamed:@"progress-0"]  stretchableImageWithLeftCapWidth:5.0 topCapHeight:0];
    [self setMaximumTrackImage:maxImg forState:UIControlStateNormal];
    [self setMinimumTrackImage:minImg forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"light"] forState:UIControlStateHighlighted];
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, self.width, 8);
}

@end
