//
//  GBRippleView.h
//  GB_Football
//
//  Created by gxd on 17/7/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GBRippleView;

@protocol RippleClickDelegate <NSObject>

- (void)didRippleClick:(GBRippleView *)rippleView;

@end

@interface GBRippleView : UIView

@property (weak, nonatomic) id<RippleClickDelegate> delegate;

- (void)setButtonBackgroudImage:(UIImage *)backgroudImage;
- (void)setButtonBackgroudImageAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha;
- (void)setButtonFontSize:(NSInteger)fontSize;
- (void)setButtonTitle:(NSString*)title;

-(void)beginLedWithCompletionBlock;
-(void)endRingWithCompletionBlock;

@end
