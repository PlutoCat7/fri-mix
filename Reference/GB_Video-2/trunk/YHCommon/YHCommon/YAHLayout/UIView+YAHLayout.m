//
//  UIView+YHLayout.m
//  TestAutoLayer
//
//  Created by yahua on 16/3/21.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "UIView+YAHLayout.h"

@implementation UIView (YAHFrameutil)

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


@end


@implementation UIView (YHLayout)

#pragma mark -  相对于父view
- (void)centerXInContainer {
    
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    self.centerX = superView.width/2;
}

- (void)centerYInContainer {
    
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    self.centerY = superView.height/2;
}

- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize {
    
    if (shouldResize) {
        self.height = self.top - top + self.height;
    }
    self.top = top;
}

- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize {
    
    if (shouldResize) {
        self.height = self.superview.height - bottom - self.top;
    } else {
        self.top = self.superview.height - self.height - bottom;
    }
}

- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize {
    
    if (shouldResize) {
        self.width = self.left - left + self.superview.width;
    }
    self.left = left;
}

- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize {
    
    if (shouldResize) {
        self.width = self.superview.width - right - self.left;
    } else {
        self.left = self.superview.width - self.width - right;
    }
}


#pragma mark -  相对于其他view
- (void)top:(CGFloat)top FromView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.top = floorf(newOrigin.y + top + view.height);
}

- (void)bottom:(CGFloat)bottom FromView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.top = newOrigin.y - bottom - self.height;
}

- (void)left:(CGFloat)left FromView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.left = newOrigin.x + left + view.width;
}

- (void)right:(CGFloat)right FromView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.left = newOrigin.x - right - self.width;
}

#pragma mark -  equal
- (void)centerXEqualToView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.centerX = centerPoint.x;
}

- (void)centerYEqualToView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.centerY = centerPoint.y;
}

- (void)topEqualToView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.top = newOrigin.y;
}

- (void)bottomEqualToView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.top = newOrigin.y + view.height - self.height;
}

- (void)leftEqualToView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.left = newOrigin.x;
}

- (void)rightEqualToView:(UIView *)view {
    
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.left = newOrigin.x + view.width - self.width;
}

- (void)widthEqualToView:(UIView *)view {
    
    self.width = view.width;
}

- (void)heightEqualToView:(UIView *)view {
    
    self.height = view.height;
}

- (void)sizeEqualToView:(UIView *)view {
    
    self.size = view.size;
}

- (void)frameEqualToView:(UIView *)view {
    
    self.frame = view.frame;
}


- (UIView *)topSuperView
{
    UIView *topSuperView = self.superview;
    
    if (topSuperView == nil) {
        topSuperView = self;
    } else {
        while (topSuperView.superview) {
            topSuperView = topSuperView.superview;
        }
    }
    
    return topSuperView;
}

@end
