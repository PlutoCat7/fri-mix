//
//  UIView+shake.m
//  YHImagePicker
//
//  Created by wangshiwen on 15/9/6.
//  Copyright (c) 2015年 yahua. All rights reserved.
//

#import "UIView+YAHShake.h"

@implementation UIView (YAHShake)
- (void)shake:(int)times withDelta:(CGFloat)delta {
	[self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:0.03 shakeDirection:ShakeDirectionHorizontal];
}

- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval
{
	[self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:interval shakeDirection:ShakeDirectionHorizontal];
}

- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(YAHShakeDirection)shakeDirection
{
    [self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:interval shakeDirection:shakeDirection];
}

- (void)_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval shakeDirection:(YAHShakeDirection)shakeDirection
{
    
	[UIView animateWithDuration:interval animations:^{
		self.layer.affineTransform = (shakeDirection == ShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
	} completion:^(BOOL finished) {
		if(current >= times) {
			self.layer.affineTransform = CGAffineTransformIdentity;
			return;
		}
		[self _shake:(times - 1)
		   direction:direction * -1
		currentTimes:current + 1
		   withDelta:delta
			andSpeed:interval
	  shakeDirection:shakeDirection];
	}];
}
@end

@implementation UIView(orientation)

- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? CGRectGetHeight(self.frame) : CGRectGetWidth(self.frame);
}

- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? CGRectGetWidth(self.frame) : CGRectGetHeight(self.frame);
}

- (CGFloat)orientationWidth:(UIInterfaceOrientation)orientation {
    
    CGFloat width = 0.f;
    UIInterfaceOrientation stautsOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(stautsOrientation)) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            width = CGRectGetWidth(self.frame);
        } else {
            width = CGRectGetHeight(self.frame);
        }
    } else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            width = CGRectGetHeight(self.frame);
        } else {
            width = CGRectGetWidth(self.frame);
        }
    }
    return width;
}
- (CGFloat)orientationHeight:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsLandscape(orientation)
    ? CGRectGetWidth(self.frame) : CGRectGetHeight(self.frame);
}
@end