//
//  UIView+YHLayout.h
//  TestAutoLayer
//
//  Created by yahua on 16/3/14.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YHAutoLayout)

/**
 *  @author wangsw, 16-03-21 16:03:34
 *
 *  切图的标准宽度
 */
+ (void)setStandardUIWidth:(CGFloat)width;

//自动适配大小
- (void)auto_left:(CGFloat)left;
- (void)auto_top:(CGFloat)top;
- (void)auto_right:(CGFloat)right;
- (void)auto_bottom:(CGFloat)bottom;
- (void)auto_width:(CGFloat)width;
- (void)auto_height:(CGFloat)height;
- (void)auto_size:(CGSize)size;
- (void)auto_frame:(CGRect)frame;

//相对一个view的相对位置
- (void)auto_top:(CGFloat)top FromView:(UIView *)view;
- (void)auto_bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)auto_left:(CGFloat)left FromView:(UIView *)view;
- (void)auto_right:(CGFloat)right FromView:(UIView *)view;


//(相对父视图)需成对调用 否则宽高会变化
- (void)auto_topInContainer:(CGFloat)top;
- (void)auto_bottomInContainer:(CGFloat)bottom;
- (void)auto_leftInContainer:(CGFloat)left;
- (void)auto_rightInContainer:(CGFloat)right;

@end
