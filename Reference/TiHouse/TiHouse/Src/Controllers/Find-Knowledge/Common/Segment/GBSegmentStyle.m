//
//  GBSegmentStyle.m
//  GB_Football
//
//  Created by gxd on 17/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBSegmentStyle.h"

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kDefaultTop         UIColorRGBA(  0,   0,   0, 1)
#define kDefaultSlider      UIColorRGBA( 34,  34,  34, 1)
#define kHightLightSlider   UIColorRGBA(  1,  255,  1, 1)
#define kDefaultHighLight   UIColorRGBA(255, 255, 255, 1)
#define kDefaultNomal       UIColorRGBA(144, 144, 144, 1)
#define kSliderHight        2.0f

@implementation GBSegmentStyle

- (instancetype)init {
    if(self = [super init]) {
        _showLine = YES;
        _scrollTitle = NO;
        _scrollLineHeight = 2.0;
        _scrollLineColor = kHightLightSlider;
        _scrollLineBgColor = kDefaultSlider;
        _titleMargin = 20.0;
        _titleFont = [UIFont systemFontOfSize:15.f];
        _highlightTitleFont = [UIFont systemFontOfSize:16.f];
        _normalTitleColor = kDefaultNomal;
        _selectedTitleColor = kDefaultHighLight;
        _highlightSelectTitle = NO;
    }
    return self;
}

@end
