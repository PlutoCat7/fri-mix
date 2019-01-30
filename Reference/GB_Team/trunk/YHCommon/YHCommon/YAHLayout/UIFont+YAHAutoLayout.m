//
//  UIFont+YHAutoLayout.m
//  TestAutoLayer
//
//  Created by yahua on 16/3/14.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "UIFont+YAHAutoLayout.h"

#import <objc/runtime.h>

#define kFontAutoLayoutScale  ([UIScreen mainScreen].bounds.size.width*1.0/[UIFont standardWidth])

@implementation UIFont (YAHAutoLayout)

static char kStandardWidth;
+ (void)setStandardUIWidth:(CGFloat)width {
    
    objc_setAssociatedObject(self, &kStandardWidth, @(width), OBJC_ASSOCIATION_RETAIN);
}

+ (CGFloat)standardWidth {
    
    NSNumber *width = objc_getAssociatedObject(self, &kStandardWidth);
    return [width floatValue];
}

+ (UIFont *)autoFontOfSize:(CGFloat)size {
    
    size = size * kFontAutoLayoutScale;
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)autoBoldFontOfSize:(CGFloat)size {
    
    size = size * kFontAutoLayoutScale;
    return [UIFont boldSystemFontOfSize:size];
}

@end
