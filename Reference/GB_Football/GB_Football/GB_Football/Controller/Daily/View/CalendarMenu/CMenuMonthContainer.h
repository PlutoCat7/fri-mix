//
//  CMenuMonthContainer.h
//  GB_Football
//
//  Created by gxd on 17/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MonthCalendarDelegate <NSObject>
- (void)didMonthBackgroundTap;
- (void)didMonthSelectDate:(NSInteger)year month:(NSInteger)month;
- (void)didMonthMenuAnimationFinish;
@end

@interface CMenuMonthContainer : UIView

@property (nonatomic, weak) id <MonthCalendarDelegate> calendarDelegate;

- (instancetype)initWithFrame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month;
- (void)show;
- (void)hide;

- (void)setCurrentDate:(NSInteger)year month:(NSInteger)month;

@end
