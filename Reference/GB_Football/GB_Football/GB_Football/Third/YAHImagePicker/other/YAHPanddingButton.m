//
//  UIPanddingButton.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "YAHPanddingButton.h"

@implementation YAHPanddingButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithFrame:frame backgroundImageInsets:UIEdgeInsetsZero];
}

- (id)initWithFrame:(CGRect)frame backgroundImageInsets:(UIEdgeInsets)insets {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImageInsets = insets;
    }
    return self;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    
    return [super backgroundRectForBounds:UIEdgeInsetsInsetRect(bounds, self.backgroundImageInsets)];
}

@end
