//
//  CalendarMenuView.m
//  GB_Football
//
//  Created by gxd on 17/6/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "CalendarMenuView.h"
#import "CMenuButton.h"
#import "CMenuContainer.h"
#import "CMenuMonthContainer.h"
#import "UIColor+Extension.h"
#import "CMenuConfiguration.h"
#import "GBNavigationBar.h"

typedef enum
{
    CalendarType_Day = 0,
    CalendarType_Week,
    CalendarType_Month,
}CalendarType;


@interface CalendarMenuView()<CalendarDelegate, MonthCalendarDelegate>

@property (nonatomic, strong) CMenuButton *menuButton;
@property (nonatomic, strong) CMenuContainer *menuView;
@property (nonatomic, strong) CMenuMonthContainer *menuMonthView;

@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, assign) BOOL isMenuAnimate;

@property (nonatomic, strong) UINavigationItem *navigationItem;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *validDate;
@property (nonatomic, assign) CalendarType calendarType;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger validYear;
@property (nonatomic, assign) NSInteger validMonth;

@end

@implementation CalendarMenuView

- (id)initWithDayFrame:(UINavigationItem *)navigationItem frame:(CGRect)frame date:(NSDate *)date {
    self = [super initWithFrame:frame];
    if (self) {
        _calendarType = CalendarType_Day;
        _navigationItem = navigationItem;
        _date = date;
        _validDate = date;
        
        frame.origin.y += 1.0;
        self.menuButton = [[CMenuButton alloc] initWithFrame:frame];
        self.menuButton.title.font = [UIFont fontWithName:self.menuButton.title.font.fontName size:16.0];
        self.menuButton.title.textColor = [UIColor whiteColor];
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
        
        [self updateMenuButtonTitle];
        
        self.isMenuAnimate = FALSE;
    }
    return self;
}

- (id)initWithWeekFrame:(UINavigationItem *)navigationItem frame:(CGRect)frame date:(NSDate *)date {
    self = [super initWithFrame:frame];
    if (self) {
        _calendarType = CalendarType_Week;
        _navigationItem = navigationItem;
        _date = date;
        _validDate = date;
        
        frame.origin.y += 1.0;
        self.menuButton = [[CMenuButton alloc] initWithFrame:frame];
        self.menuButton.title.font = [UIFont fontWithName:self.menuButton.title.font.fontName size:16.0];
        self.menuButton.title.textColor = [UIColor whiteColor];
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
        
        [self updateMenuButtonTitle];
        
        self.isMenuAnimate = FALSE;
    }
    return self;
}

- (id)initWithMonthFrame:(UINavigationItem *)navigationItem frame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month {
    self = [super initWithFrame:frame];
    if (self) {
        _calendarType = CalendarType_Month;
        _navigationItem = navigationItem;
        _year = year;
        _month = month;
        _validYear = year;
        _validMonth = month;
        
        frame.origin.y += 1.0;
        self.menuButton = [[CMenuButton alloc] initWithFrame:frame];
        self.menuButton.title.font = [UIFont fontWithName:self.menuButton.title.font.fontName size:16.0];
        self.menuButton.title.textColor = [UIColor whiteColor];
        [self.menuButton addTarget:self action:@selector(onHandleMenuTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.menuButton];
        
        [self updateMenuButtonTitle];
        
        self.isMenuAnimate = FALSE;
    }
    return self;
}

- (void)displayMenuInView:(UIView *)view {
    self.menuContainer = view;
}

#pragma mark -
#pragma mark Actions
- (void)onHandleMenuTap:(id)sender
{
    if (self.menuButton.isActive) {
        [self onShowMenu];
    } else {
        [self onHideMenu];
    }
}

- (void)onShowMenu
{
    if (self.isMenuAnimate) {
        return;
    }
    self.isMenuAnimate = TRUE;
    
    if (self.calendarType == CalendarType_Day || self.calendarType == CalendarType_Week) {
        if (!self.menuView) {
            UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
            CGRect frame = mainWindow.frame;
            frame.origin.y += self.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
            self.menuView = [[CMenuContainer alloc] initWithFrame:frame data:self.date];
            self.menuView.calendarDelegate = self;
        }
        [self.menuContainer addSubview:self.menuView];
        
    } else if (self.calendarType == CalendarType_Month) {
        if (!self.menuMonthView) {
            UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
            CGRect frame = mainWindow.frame;
            frame.origin.y += self.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
            self.menuMonthView = [[CMenuMonthContainer alloc] initWithFrame:frame year:self.year month:self.month];
            self.menuMonthView.calendarDelegate = self;
        }
        [self.menuContainer addSubview:self.menuMonthView];
    }
    
    [self rotateArrow:M_PI];
    
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didShowCalendarMenuBefore)]) {
        [self.calendarDelegate didShowCalendarMenuBefore];
    }
    
    if (self.calendarType == CalendarType_Day || self.calendarType == CalendarType_Week) {
        [self.menuView show];
        
    } else if (self.calendarType == CalendarType_Month) {
        [self.menuMonthView show];
    }
    
    // 显示快速回到今天，本周，本月的按键
    [self showFastSelectNav];
    
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didShowCalendarMenuAfter)]) {
        [self.calendarDelegate didShowCalendarMenuAfter];
    }
}

- (void)onHideMenu
{
    if (self.isMenuAnimate) {
        return;
    }
    self.isMenuAnimate = TRUE;
    [self rotateArrow:0];
    
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didHideCalendarMenuBefore)]) {
        [self.calendarDelegate didHideCalendarMenuBefore];
    }
    
    if (self.calendarType == CalendarType_Day || self.calendarType == CalendarType_Week) {
        self.date = self.validDate;
        [self updateMenuButtonTitle];
        [self.menuView setCurrentDate:self.date];
        
        [self.menuView hide];
        
    } else if (self.calendarType == CalendarType_Month) {
        self.year = self.validYear;
        self.month = self.validMonth;
        [self updateMenuButtonTitle];
        [self.menuMonthView setCurrentDate:self.year month:self.month];
        
        [self.menuMonthView hide];
    }
    // 隐藏快速回到今天，本周，本月的按键
    [self hideFastSelectNav];
    
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didHideCalendarMenuAfter)]) {
        [self.calendarDelegate didHideCalendarMenuAfter];
    }
}

- (void)showFastSelectNav {
    if (self.navigationItem == nil) {
        return;
    }
    
    if (self.calendarType == CalendarType_Day) {
        if (![self.date isToday]) {
            UIButton *fastButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [fastButton setSize:CGSizeMake(48, 24)];
            [fastButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
            [fastButton setTitle:LS(@"today.label.today") forState:UIControlStateNormal];
            [fastButton setTitle:LS(@"today.label.today") forState:UIControlStateHighlighted];
            [fastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            fastButton.backgroundColor = [UIColor clearColor];
            [fastButton addTarget:self action:@selector(actionFastSelect) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:fastButton];
            [self.navigationItem setRightBarButtonItem:rightButton];
        } else {
            [self hideFastSelectNav];
        }
        
    } else if (self.calendarType == CalendarType_Week) {
        NSDate *curDate = self.date ? self.date : [NSDate date];
        NSDate *nowDate = [NSDate date];
        
        // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
        NSInteger currentWeekDay = curDate.weekday;
        if (currentWeekDay == 1) {//方便计算， 将周天改为8
            currentWeekDay = 8;
        }
        
        NSDate *firstDate = [curDate dateByAddingDays:2-currentWeekDay];
        NSDate *lastDate = [curDate dateByAddingDays:2-currentWeekDay+6];
        if (!(([nowDate isLaterThanDate:firstDate] && [lastDate isLaterThanDate:nowDate]) || [firstDate isToday] || [lastDate isToday])) {
            UIButton *fastButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [fastButton setSize:CGSizeMake(48, 24)];
            [fastButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
            [fastButton setTitle:LS(@"today.label.week") forState:UIControlStateNormal];
            [fastButton setTitle:LS(@"today.label.week") forState:UIControlStateHighlighted];
            [fastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            fastButton.backgroundColor = [UIColor clearColor];
            [fastButton addTarget:self action:@selector(actionFastSelect) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:fastButton];
            [self.navigationItem setRightBarButtonItem:rightButton];
        } else {
            [self hideFastSelectNav];
        }
        
    } else if (self.calendarType == CalendarType_Month) {
        NSDate *nowDate = [NSDate date];
        if (!(nowDate.year == self.year && nowDate.month == self.month)) {
            UIButton *fastButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [fastButton setSize:CGSizeMake(48, 24)];
            [fastButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
            [fastButton setTitle:LS(@"today.label.month") forState:UIControlStateNormal];
            [fastButton setTitle:LS(@"today.label.month") forState:UIControlStateHighlighted];
            [fastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            fastButton.backgroundColor = [UIColor clearColor];
            [fastButton addTarget:self action:@selector(actionFastSelect) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:fastButton];
            [self.navigationItem setRightBarButtonItem:rightButton];
        } else {
            [self hideFastSelectNav];
        }
    }
    
    
}

- (void)hideFastSelectNav {
    if (self.navigationItem == nil) {
        return;
    }
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)actionFastSelect {
    if (self.calendarType == CalendarType_Day || self.calendarType == CalendarType_Week) {
        self.date = [NSDate date];
        
        [self.menuView setCurrentDate:self.date];
        [self didSelectDate:self.date];
        
    } else if (self.calendarType == CalendarType_Month) {
        NSDate *date = [NSDate date];
        self.year = date.year;
        self.month = date.month;
        
        [self.menuMonthView setCurrentDate:self.year month:self.month];
        [self didMonthSelectDate:self.year month:self.month];
    }
    
}

- (void)rotateArrow:(float)degrees {
    [UIView animateWithDuration:[CMenuConfiguration animationDuration] delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.menuButton.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

- (void)updateMenuButtonTitle {
    if (self.calendarType == CalendarType_Day) {
        if ([self.date isToday]) {
            self.menuButton.title.text = LS(@"daily.tab.today");
        } else {
            NSString *title = [NSString stringWithFormat:@"%04td/%02td/%02td", self.date.year, self.date.month, self.date.day];
            self.menuButton.title.text = title;
        }
        
    } else if (self.calendarType == CalendarType_Week) {
        NSDate *curDate = self.date ? self.date : [NSDate date];
        NSDate *nowDate = [NSDate date];
        
        // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
        NSInteger currentWeekDay = curDate.weekday;
        if (currentWeekDay == 1) {//方便计算， 将周天改为8
            currentWeekDay = 8;
        }
        
        NSDate *firstDate = [curDate dateByAddingDays:2-currentWeekDay];
        NSDate *lastDate = [curDate dateByAddingDays:2-currentWeekDay+6];
        
        if (([nowDate isLaterThanDate:firstDate] && [lastDate isLaterThanDate:nowDate]) || [firstDate isToday] || [lastDate isToday]) {
            lastDate = nowDate;
        }
        
        if ([lastDate isToday]) {
            NSString *title = LS(@"daily.tab.week");
            self.menuButton.title.text = title;
        } else {
            NSString *title = [NSString stringWithFormat:@"%02td/%02td~%02td/%02td", firstDate.month, firstDate.day, lastDate.month, lastDate.day];
            self.menuButton.title.text = title;
        }
        
        
    } else if (self.calendarType == CalendarType_Month) {
        NSDate *nowDate = [NSDate date];
        if (self.year == nowDate.year && self.month == nowDate.month) {
            NSString *title = LS(@"daily.tab.month");
            self.menuButton.title.text = title;
        } else {
            NSString *title = [NSString stringWithFormat:@"%td/%02td", self.year, self.month];
            self.menuButton.title.text = title;
        }
    }
    
    [self.menuButton layoutSubviews];
    
}

#pragma mark -
#pragma mark Delegate methods
- (void)didSelectDate:(NSDate *)date
{
    if (![date isToday] && [date isLaterThanDate:[NSDate date]]) {
        self.date = date;
        [self showFastSelectNav];
        [self updateMenuButtonTitle];
        
    } else {
        self.date = date;
        self.validDate = date;
        
        self.menuButton.isActive = !self.menuButton.isActive;
        [self onHandleMenuTap:nil];
        
        if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didSelectDate:)]) {
            [self.calendarDelegate didSelectDate:date];
        }
    }
    
    /**
    self.menuButton.isActive = !self.menuButton.isActive;
    [self onHandleMenuTap:nil];
    
    self.date = date;
    [self updateMenuButtonTitle];
    
    if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.calendarDelegate didSelectDate:date];
    }
     */
}

- (void)didBackgroundTap
{
    self.menuButton.isActive = !self.menuButton.isActive;
    [self onHandleMenuTap:nil];
}

- (void)didMenuAnimationFinish {
    self.isMenuAnimate = FALSE;
}

#pragma mark Delegate methods
- (void)didMonthSelectDate:(NSInteger)year month:(NSInteger)month {
    NSDate *nowDate = [NSDate date];
    if (year > nowDate.year || (year == nowDate.year && month > nowDate.month)) {
        self.year = year;
        self.month = month;
        [self showFastSelectNav];
        [self updateMenuButtonTitle];
        
    } else {
        self.year = year;
        self.month = month;
        self.validYear = year;
        self.validMonth = month;
        
        self.menuButton.isActive = !self.menuButton.isActive;
        [self onHandleMenuTap:nil];
        
        if (self.calendarDelegate && [self.calendarDelegate respondsToSelector:@selector(didSelectDate:month:)]) {
            [self.calendarDelegate didSelectDate:year month:month];
        }
    }
    
}

- (void)didMonthBackgroundTap {
    self.menuButton.isActive = !self.menuButton.isActive;
    [self onHandleMenuTap:nil];
}

- (void)didMonthMenuAnimationFinish {
    self.isMenuAnimate = FALSE;
}

#pragma mark -
#pragma mark Memory management
- (void)dealloc {
    self.menuButton = nil;
    self.menuContainer = nil;
}

- (void)remove {
    [self onHideMenu];
}


@end
