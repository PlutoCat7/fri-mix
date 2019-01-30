//
//  CMenuMonthContainer.m
//  GB_Football
//
//  Created by gxd on 17/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "CMenuMonthContainer.h"
#import "FDMonthCalendar.h"
#import "UIColor+Extension.h"
#import "CMenuConfiguration.h"

@interface CMenuMonthContainer ()<FDMonthCalendarDelegate> {
    CGRect endFrame;
    CGRect startFrame;
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, strong) FDMonthCalendar *fdCalendar;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation CMenuMonthContainer

- (id)initWithFrame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month
{
    self = [super initWithFrame:frame];
    if (self) {
        _year = year;
        _month = month;
        
        self.layer.backgroundColor = [UIColor color:[CMenuConfiguration mainColor] withAlpha:0.0].CGColor;
        self.clipsToBounds = YES;
        
        self.fdCalendar = [[FDMonthCalendar alloc] initWithCurrentDate:year month:month];
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
        
        if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didMonthMenuAnimationFinish)]) {
            [self.calendarDelegate didMonthMenuAnimationFinish];
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
            
            if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didMonthMenuAnimationFinish)]) {
                [self.calendarDelegate didMonthMenuAnimationFinish];
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
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didMonthBackgroundTap)]) {
        [self.calendarDelegate didMonthBackgroundTap];
    }
}

- (void)dealloc
{
    self.fdCalendar = nil;
    self.calendarDelegate = nil;
}


- (void)setCurrentDate:(NSInteger)year month:(NSInteger)month {
    self.year = year;
    self.month = month;
    
    if (self.fdCalendar) {
        [self.fdCalendar setCurrentDate:year month:month ];
    }
}

#pragma delegate

- (void)didSelectMonth:(NSInteger)year month:(NSInteger)month {
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didMonthSelectDate:month:)]) {
        [self.calendarDelegate didMonthSelectDate:year month:month];
    }
}

@end
