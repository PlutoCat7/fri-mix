//
//  GBView.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/28.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "YAHGradientView.h"

@interface YAHGradientLayer : CAGradientLayer
@property (nonatomic) CGColorRef startColor;
@property (nonatomic) CGColorRef endColor;
@end

@implementation YAHGradientLayer

- (instancetype)init
{
    if (self = [super init]) {
        self.colors = @[(__bridge id)([UIColor clearColor].CGColor),
                        (__bridge id)([UIColor clearColor].CGColor)];
    }
    return self;
}

- (CGColorRef)startColor
{
    return (__bridge CGColorRef)self.colors.firstObject;
}

- (void)setStartColor:(CGColorRef)startColor
{
    self.colors = @[(__bridge id)(startColor),
                    (__bridge id)self.endColor];
}

- (CGColorRef)endColor
{
    return (__bridge CGColorRef)self.colors.lastObject;
}

- (void)setEndColor:(CGColorRef)endColor
{
    self.colors = @[(__bridge id)self.startColor,
                    (__bridge id)CGColorRetain(endColor)];
}

@end



@interface YAHGradientView ()
@property (readonly) YAHGradientLayer *gbLayer;
@end

@implementation YAHGradientView

+ (Class)layerClass
{
    return [YAHGradientLayer class];
}

- (YAHGradientLayer *)gbLayer
{
    return (YAHGradientLayer *)self.layer;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (UIColor *)bgStartColor:(UIColor *)color
{
    return [UIColor colorWithCGColor:self.gbLayer.startColor];
}

- (void)setBgStartColor:(UIColor *)color
{
    self.gbLayer.startColor = color.CGColor;
}

- (CGPoint)bgStartPoint
{
    return self.gbLayer.startPoint;
}

- (void)setBgStartPoint:(CGPoint)gradientStartPoint
{
    self.gbLayer.startPoint = gradientStartPoint;
}

- (UIColor *)bgEndColor:(UIColor *)color
{
    return [UIColor colorWithCGColor:self.gbLayer.endColor];
}

- (void)setBgEndColor:(UIColor *)color
{
    self.gbLayer.endColor = color.CGColor;
}

- (CGPoint)bgEndPoint
{
    return self.gbLayer.endPoint;
}

- (void)setBgEndPoint:(CGPoint)gradientEndPoint
{
    self.gbLayer.endPoint = gradientEndPoint;
}

@end
