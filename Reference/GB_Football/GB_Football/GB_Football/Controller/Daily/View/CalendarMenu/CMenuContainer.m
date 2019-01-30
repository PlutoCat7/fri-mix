//
//  CMenuContainer.m
//  GB_Football
//
//  Created by gxd on 17/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "CMenuContainer.h"
#import "FDCalendar.h"
#import "UIColor+Extension.h"
#import "CMenuConfiguration.h"

@interface CMenuContainer ()<FDCalendarDelegate> {
    CGRect endFrame;
    CGRect startFrame;
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) FDCalendar *fdCalendar;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation CMenuContainer

- (id)initWithFrame:(CGRect)frame data:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        _date = date;
        
        self.layer.backgroundColor = [UIColor color:[CMenuConfiguration mainColor] withAlpha:0.0].CGColor;
        self.clipsToBounds = YES;
        
        self.fdCalendar = [[FDCalendar alloc] initWithCurrentDate:date];
        endFrame = self.fdCalendar.frame;
        startFrame = endFrame;
        startFrame.origin.y -= endFrame.size.height;
        
        self.fdCalendar.frame = startFrame;
        self.fdCalendar.delegate = self;
        
    }
    return self;
}

- (void)show
{
    [self addSubview:self.fdCalendar];
    if (!self.footerView) {
        [self addFooter];
    }
    [UIView animateWithDuration:[CMenuConfiguration animationDuration] animations:^{
        self.layer.backgroundColor = [UIColor color:[CMenuConfiguration mainColor] withAlpha:[CMenuConfiguration backgroundAlpha]].CGColor;
        self.fdCalendar.frame = endFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self bounceAnimationDuration] animations:^{
            
        }];
        
        if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didMenuAnimationFinish)]) {
            [self.calendarDelegate didMenuAnimationFinish];
        }
    }];
}

- (void)hide
{
    [UIView animateWithDuration:[self bounceAnimationDuration] animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[CMenuConfiguration animationDuration] animations:^{
            self.layer.backgroundColor = [UIColor color:[CMenuConfiguration mainColor] withAlpha:0.0].CGColor;
            self.fdCalendar.frame = startFrame;
        } completion:^(BOOL finished) {
            
            currentIndexPath = nil;
            [self removeFooter];
            [self removeFromSuperview];
            
            if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didMenuAnimationFinish)]) {
                [self.calendarDelegate didMenuAnimationFinish];
            }
        }];
    }];
}

- (float)bounceAnimationDuration
{
    float percentage = 28.57;
    return [CMenuConfiguration animationDuration]*percentage/100.0;
}

- (void)addFooter
{
    if (!self.footerView) {
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, endFrame.size.height, [CMenuConfiguration menuWidth], self.frame.size.height - endFrame.size.height)];
        [self addSubview:self.footerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundTap:)];
        [self.footerView addGestureRecognizer:tap];
    }
    
}

- (void)removeFooter
{
    if (self.footerView) {
        [self.footerView removeFromSuperview];
        self.footerView = nil;
    };
}

- (void)onBackgroundTap:(id)sender {
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didBackgroundTap)]) {
        [self.calendarDelegate didBackgroundTap];
    }
}

- (void)dealloc
{
    self.fdCalendar = nil;
    self.calendarDelegate = nil;
}


- (void)setCurrentDate:(NSDate *)date {
    self.date = date;
    
    if (self.fdCalendar) {
        [self.fdCalendar setCurrentDate:date];
    }
}

#pragma delegate

- (void)didSelectDate:(NSDate *)date {
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.calendarDelegate didSelectDate:date];
    }
}
@end
