//
//  FDMonthCalendarItem.h
//  GB_Football
//
//  Created by gxd on 17/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>


#define DeviceWidth [UIScreen mainScreen].bounds.size.width

@protocol FDMonthCalendarItemDelegate;

@interface FDMonthCalendarItem : UIView

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger curYear;
@property (assign, nonatomic) NSInteger curMonth;
@property (weak, nonatomic) id<FDMonthCalendarItemDelegate> delegate;

- (NSInteger)nextYear;
- (NSInteger)previousYear;

@end

@protocol FDMonthCalendarItemDelegate <NSObject>

- (void)calendarItem:(FDMonthCalendarItem *)item selectedYear:(NSInteger)year selectedMonth:(NSInteger)month;

@end
