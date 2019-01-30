//
//  MPBarsGraphView.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPBarsGraphView.h"

@interface MPBarsGraphView()
{
    BOOL shouldAnimate;
    CGFloat margin,gap,bar;
}
@property (nonatomic,readwrite) CGFloat topCornerRadius;
@end

@implementation MPBarsGraphView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        currentTag=-1;
        self.topCornerRadius=-1;
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.values.count && !self.waitToUpdate) {
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        [self addBarsAnimated:shouldAnimate];
    }
}

- (void)addBarsAnimated:(BOOL)animated{
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    if (animated) {
        self.layer.masksToBounds=YES;
    }

    TYPE_BAR type = [self.delegate MPBarsGraphViewType:self];
    if (type == TYPE_WEEK)
    {
        margin = [UIScreen mainScreen].bounds.size.width * 29.f/375.f;
        bar    = [UIScreen mainScreen].bounds.size.width * 16.f/375.f;
        gap    = [UIScreen mainScreen].bounds.size.width * 27.f/375.f;

        CGFloat radius=bar*(self.topCornerRadius >=0 ? self.topCornerRadius : 1);
        
        for (NSInteger i=0;i<points.count;i++)
        {
            CGFloat height=[[points objectAtIndex:i] floatValue]*(self.height-PADDING*2)+PADDING/3;
            BOOL isZero = NO;
            if (height == PADDING/3)
            {
                isZero = YES;
            }
            MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(bar/2, self.height)];
            NSArray<UIColor*> *arrayColors = [self.delegate MPBarsGraphViewColor:self];
            [button setBackgroundColor:arrayColors[i]];
            if (isZero == YES)
            {
                button.frame=CGRectMake(margin+(gap*i+bar*i),self.height-height, bar,0);
            }
            else
            {
                button.frame=CGRectMake(margin+(gap*i+bar*i), animated ? self.height : self.height-height, bar, animated ? height+10 : height);
            }
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = button.bounds;
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)].CGPath;
            button.layer.mask=maskLayer;
            button.tag=i;
            [self addSubview:button];
            
            if (animated) {
                [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    button.y=self.height-height;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0 animations:^{
                        button.frame=CGRectMake(margin+(gap*i+bar*i), self.height-height, bar, height);
                    }];
                }];
            }
            
            [buttons addObject:button];
        }
    }
    else if (type == TYPE_MONTH)
    {
        margin = [UIScreen mainScreen].bounds.size.width * 37.f/375.f;
        bar    = [UIScreen mainScreen].bounds.size.width * 3.f/375.f;
        gap    = [UIScreen mainScreen].bounds.size.width * 7.f/375.f;
        
        CGFloat radius=bar*(self.topCornerRadius >=0 ? self.topCornerRadius : 1);
        for (NSInteger i=0;i<points.count;i++)
        {
            CGFloat height=[[points objectAtIndex:i] floatValue]*(self.height-PADDING*2)+PADDING/3;
            BOOL isZero = NO;
            if (height == PADDING/3)
            {
                isZero = YES;
            }
            MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(bar/2, self.height)];
            NSArray<UIColor*> *arrayColors = [self.delegate MPBarsGraphViewColor:self];
            [button setBackgroundColor:arrayColors[i]];
            if (i > 0)
            {
                if (isZero == YES)
                {
                    button.frame=CGRectMake(margin+(gap*i+bar*i)+(gap+bar),self.height-height, bar,0);
                }
                else
                {
                    button.frame=CGRectMake(margin+(gap*i+bar*i)+(gap+bar), animated ? self.height : self.height-height, bar, animated ? height+5 : height);
                }
            }
            else
            {
                button.frame=CGRectMake(margin+(gap*i+bar*i), animated ? self.height : self.height-height, bar, animated ? height+5 : height);
            }
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = button.bounds;
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)].CGPath;
            button.layer.mask=maskLayer;
            button.tag=i;
            [self addSubview:button];
            
            if (animated)
            {
                [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    button.y=self.height-height;
                }completion:^(BOOL finished) {
                    [UIView animateWithDuration:0 animations:^{
                        if (i > 0)
                        {
                            button.frame=CGRectMake(margin+(gap*i+bar*i)+(gap+bar), self.height-height, bar, height);
                        }
                        else
                        {
                            button.frame=CGRectMake(margin+(gap*i+bar*i), self.height-height, bar, height);
                        }
                    }];
                }];
            }
            
            [buttons addObject:button];
        }
    }
    shouldAnimate=NO;
}

- (CGFloat)animationDuration{
    return _animationDuration>0.0 ? _animationDuration : 1.f;
}

- (void)animate{
    self.waitToUpdate=NO;
    shouldAnimate=YES;
    [self setNeedsDisplay];
}

@end
