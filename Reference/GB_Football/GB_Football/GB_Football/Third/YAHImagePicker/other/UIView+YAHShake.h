//
//  UIView+shake.h
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YAHShakeDirection) {
    ShakeDirectionHorizontal = 0,
    ShakeDirectionVertical
};

@interface UIView (YAHShake)

/**-----------------------------------------------------------------------------
 * @name UIView+Shake
 * -----------------------------------------------------------------------------
 */

/** Shake the UIView
 *
 * Shake the text field a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta;

/** Shake the UIView at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval;

/** Shake the UIView at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param direction of the shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(YAHShakeDirection)shakeDirection;

@end

@interface UIView (orientation)
/**
 *    屏幕宽
 *
 */
- (CGFloat)orientationWidth;
/**
 *    屏幕高
 *
 */
- (CGFloat)orientationHeight;
/**
 *    屏幕宽
 *
 */
- (CGFloat)orientationWidth:(UIInterfaceOrientation)orientation;
/**
 *    屏幕高
 *
 */
- (CGFloat)orientationHeight:(UIInterfaceOrientation)orientation;
@end