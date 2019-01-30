//
//  FDMonthCalendar.h
//  GB_Football
//
//  Created by gxd on 17/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDMonthCalendarDelegate <NSObject>

- (void)didSelectMonth:(NSInteger)year month:(NSInteger)month;

@end

@interface FDMonthCalendar : UIView

@property (weak, nonatomic) id<FDMonthCalendarDelegate> delegate;

- (instancetype)initWithCurrentDate:(NSInteger)year month:(NSInteger)month;

- (void)setCurrentDate:(NSInteger)year month:(NSInteger)month;

@end
