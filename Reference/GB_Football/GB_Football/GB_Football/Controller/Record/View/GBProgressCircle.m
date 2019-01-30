//
//  GBProgressCircle.m
//  GB_Football
//
//  Created by Pizza on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBProgressCircle.h"

@interface GBProgressCircle()
@property (nonatomic, assign) CGFloat endAnlge;
@property (nonatomic, strong) CAShapeLayer *backLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end
@implementation GBProgressCircle


-(void)awakeFromNib
{
    [super awakeFromNib];
    if (self.backLayer)
    {
        [self.backLayer removeFromSuperlayer];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath *path=[UIBezierPath bezierPath];
        CGRect rect= self.bounds;
        rect.size = CGSizeMake(rect.size.width, rect.size.height);
        [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2) radius:rect.size.width/2 startAngle:0 endAngle:2*M_PI clockwise:NO];
        self.backLayer=[CAShapeLayer layer];
        self.backLayer.path=path.CGPath;
        self.backLayer.fillColor=[UIColor clearColor].CGColor;
        self.backLayer.strokeColor= self.backColor.CGColor ? self.backColor.CGColor : [UIColor blackColor].CGColor;
        self.backLayer.lineWidth = 2;
        self.backLayer.frame=rect;
        [self.layer addSublayer:self.backLayer];
    });
    [self setPercent:0];
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//}


- (void)setPercent:(CGFloat)percent {
    self.endAnlge = (percent*2*M_PI) + 1.5*M_PI;
    [self setNeedsLayout];
    [self addProgressAnimation];
}

#pragma mark - Private

- (void)addProgressAnimation
{
    if (self.progressLayer)
    {
        [self.progressLayer removeAllAnimations];
        [self.progressLayer removeFromSuperlayer];
    }
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGRect rect= self.bounds;
    [path addArcWithCenter:CGPointMake(rect.size.width/2,rect.size.height/2) radius:rect.size.width/2 startAngle:1.5*M_PI endAngle:self.endAnlge clockwise:YES];
    self.progressLayer =[CAShapeLayer layer];
    self.progressLayer.path=path.CGPath;
    self.progressLayer.fillColor=[UIColor clearColor].CGColor;
    self.progressLayer.strokeColor=self.backColor.CGColor ? self.backColor.CGColor : [UIColor colorWithHex:0x01ff00].CGColor;
    self.progressLayer.lineWidth = 2;
    self.progressLayer.frame=rect;
    [self.layer addSublayer:self.progressLayer];
    [self drawLineAnimation:self.progressLayer];
}

-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration    =2;
    bas.fromValue   =[NSNumber numberWithInteger:0];
    bas.toValue     = @(1);
    [layer addAnimation:bas forKey:@"key"];
}


@end
