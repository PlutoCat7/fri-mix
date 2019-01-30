//
//  FDCalendar.h
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDCalendarDelegate <NSObject>

- (void)didSelectDate:(NSDate *)date;

@end

@interface FDCalendar : UIView

@property (weak, nonatomic) id<FDCalendarDelegate> delegate;

- (instancetype)initWithCurrentDate:(NSDate *)date;

- (void)setCurrentDate:(NSDate *)date;

@end
