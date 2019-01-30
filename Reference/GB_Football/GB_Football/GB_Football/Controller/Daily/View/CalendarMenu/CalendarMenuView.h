//
//  CalendarMenuView.h
//  GB_Football
//
//  Created by gxd on 17/6/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarMenuDelegate <NSObject>

@optional
- (void)didSelectDate:(NSDate *)date;
- (void)didSelectDate:(NSInteger)year month:(NSInteger)month;

- (void)didShowCalendarMenuBefore;
- (void)didShowCalendarMenuAfter;
- (void)didHideCalendarMenuBefore;
- (void)didHideCalendarMenuAfter;

@end

@interface CalendarMenuView : UIView

@property (nonatomic, weak) id <CalendarMenuDelegate> calendarDelegate;

- (id)initWithDayFrame:(UINavigationItem *)navigationItem frame:(CGRect)frame date:(NSDate *)date;
- (id)initWithWeekFrame:(UINavigationItem *)navigationItem frame:(CGRect)frame date:(NSDate *)date;
- (id)initWithMonthFrame:(UINavigationItem *)navigationItem frame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month;

- (void)displayMenuInView:(UIView *)view;
- (void)remove;

@end
