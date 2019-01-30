//
//  UIFont+YHAutoLayout.h
//  TestAutoLayer
//
//  Created by yahua on 16/3/14.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (YAHAutoLayout)

/**
 *  @author wangsw, 16-03-21 16:03:34
 *
 *  切图的标准宽度
 */
+ (void)setStandardUIWidth:(CGFloat)width;

+ (UIFont *)autoFontOfSize:(CGFloat)size;

+ (UIFont *)autoBoldFontOfSize:(CGFloat)size;

@end
