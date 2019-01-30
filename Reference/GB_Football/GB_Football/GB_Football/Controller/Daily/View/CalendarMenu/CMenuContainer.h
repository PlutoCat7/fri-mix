//
//  CMenuContainer.h
//  GB_Football
//
//  Created by gxd on 17/6/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarDelegate <NSObject>
- (void)didBackgroundTap;
- (void)didSelectDate:(NSDate *)date;
- (void)didMenuAnimationFinish;
@end

@interface CMenuContainer : UIView

@property (nonatomic, weak) id <CalendarDelegate> calendarDelegate;

- (instancetype)initWithFrame:(CGRect)frame data:(NSDate *)date;
- (void)show;
- (void)hide;

- (void)setCurrentDate:(NSDate *)date;

@end
