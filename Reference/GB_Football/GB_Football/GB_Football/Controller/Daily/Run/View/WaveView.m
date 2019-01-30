//
//  WaveView.m
//  GB_Football
//
//  Created by gxd on 17/7/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "WaveView.h"
#import "UIColor+HEX.h"

@interface WaveView()

@property (nonatomic, assign) CGFloat beginRadiu;
@property (nonatomic, assign) CGFloat endRadiu;
@property (nonatomic, assign) CGPoint drawCenter;

@property (nonatomic, copy) WaveViewAnimEndBlocck endBlock;

@end

@implementation WaveView

+ (instancetype)showInView:(UIView *)view center:(CGPoint)center beginRadiu:(CGFloat)beginRadiu endRadiu:(CGFloat)endRadiu endBlock:(WaveViewAnimEndBlocck)endBlock {
    
    WaveView *waveView = [[WaveView alloc] initWithFrame:[WaveView calFrameWithCenter:center radiu:endRadiu]];
    waveView.beginRadiu = beginRadiu;
    waveView.endRadiu = endRadiu;
    waveView.drawCenter = center;
    waveView.endBlock = endBlock;
    
    [view insertSubview:waveView atIndex:0];
    
    return waveView;
}

+ (CGRect)calFrameWithCenter:(CGPoint)center radiu:(CGFloat)radiu {
    CGRect frame = CGRectMake(center.x - radiu, center.y - radiu, radiu * 2, radiu *2);
    return frame;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        return self;
    }
    
    return self;
}

- (void)didMoveToSuperview {
    CAShapeLayer *waveLayer = [CAShapeLayer new];
    waveLayer.backgroundColor = [UIColor clearColor].CGColor;
    waveLayer.opacity = 1;
    waveLayer.fillColor = [UIColor colorWithHex:0x1d2c22].CGColor;
    [self.layer addSublayer:waveLayer];
    
    [self startAnimationInLayer:waveLayer];
}

- (void)startAnimationInLayer:(CALayer *)layer{
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithArcCenter:self.drawCenter radius:self.beginRadiu startAngle:0 endAngle:M_PI*2 clockwise:YES];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithArcCenter:self.drawCenter radius:self.endRadiu startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 0.6;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 0.6;
    
    [layer addAnimation:rippleAnimation forKey:@"rippleAnimation"];
    [layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    dispatch_after ( dispatch_time ( DISPATCH_TIME_NOW ,0.6 * NSEC_PER_SEC ) , dispatch_get_main_queue ( ) , ^{
        if (self.endBlock) {
            self.endBlock();
            self.endBlock = nil;
        }
    } ) ;
}


@end
