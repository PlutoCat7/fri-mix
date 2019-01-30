//
//  UIView+YHLayout.h
//  TestAutoLayer
//
//  Created by yahua on 16/3/21.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YAHFrameutil)

@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;


/**
 *    当前实例在屏幕上的x坐标（scroll view适用）
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 *    当前实例在屏幕上的y坐标（scroll view适用）
 */
@property (nonatomic, readonly) CGFloat screenViewY;


@end


@interface UIView (YAHLayout)

//相对于父view
- (void)centerXInContainer;
- (void)centerYInContainer;

- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize;
- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize;
- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize;
- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize;

//相对于其他view
- (void)top:(CGFloat)top FromView:(UIView *)view;
- (void)bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)left:(CGFloat)left FromView:(UIView *)view;
- (void)right:(CGFloat)right FromView:(UIView *)view;

//equal
- (void)centerXEqualToView:(UIView *)view;
- (void)centerYEqualToView:(UIView *)view;
- (void)topEqualToView:(UIView *)view;
- (void)bottomEqualToView:(UIView *)view;
- (void)leftEqualToView:(UIView *)view;
- (void)rightEqualToView:(UIView *)view;
- (void)widthEqualToView:(UIView *)view;
- (void)heightEqualToView:(UIView *)view;
- (void)sizeEqualToView:(UIView *)view;
- (void)frameEqualToView:(UIView *)view;

- (UIView *)topSuperView;

@end
