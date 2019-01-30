//
//  FDCalendar.m
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDCalendar.h"
#import "FDCalendarItem.h"
#import "FDCalendarConfig.h"

static NSDateFormatter *dateFormattor;

@interface FDCalendar () <UIScrollViewDelegate, FDCalendarItemDelegate>

@property (strong, nonatomic) NSDate *curDate;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FDCalendarItem *leftCalendarItem;
@property (strong, nonatomic) FDCalendarItem *centerCalendarItem;
@property (strong, nonatomic) FDCalendarItem *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@end

@implementation FDCalendar

- (instancetype)initWithCurrentDate:(NSDate *)date {
    if (self = [super init]) {
        self.backgroundColor = [FDCalendarConfig backgroundColor];
        self.curDate = date;
        
        [self setupTitleBar];
        [self setupWeekHeader];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        
        [self setShowDate:self.curDate];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame: self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
    }
    
    [self addSubview:_backgroundView];
    
    return _backgroundView;
}

#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"yyyy-MM"];
    }
    return [dateFormattor stringFromDate:date];
}

// 设置上层的titleBar
- (void)setupTitleBar {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 45)];
    titleView.backgroundColor = [UIColor clearColor];
    [self addSubview:titleView];
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 25)];
    [self.leftButton setImage:[UIImage imageNamed:@"page_left.png"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 40, 10, 30, 25)];
    [self.rightButton setImage:[UIImage imageNamed:@"page_right.png"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.rightButton];
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleButton setTitleColor:[FDCalendarConfig heightLightColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleButton.center = titleView.center;
    [titleView addSubview:titleButton];
    
    self.titleButton = titleButton;
}

// 设置星期文字的显示
- (void)setupWeekHeader {
    NSArray *Weekdays = @[LS(@"calendar.label.sun"), LS(@"calendar.label.mon"), LS(@"calendar.label.tues"), LS(@"calendar.label.wed"), LS(@"calendar.label.thur"), LS(@"calendar.label.fri"), LS(@"calendar.label.sat")];
    NSInteger count = [Weekdays count];
    CGFloat offsetX = 5;
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 50, (DeviceWidth - 10) / count, 20)];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.text = Weekdays[i];
        weekdayLabel.textColor = [FDCalendarConfig weekFontColor];
        
        [self addSubview:weekdayLabel];
        offsetX += weekdayLabel.frame.size.width;
    }
}

// 设置包含日历的item的scrollView
- (void)setupScrollView {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, 75, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self addSubview:self.scrollView];
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    
    self.leftCalendarItem = [[FDCalendarItem alloc] init];
    [self.scrollView addSubview:self.leftCalendarItem];
    
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = DeviceWidth;
    self.centerCalendarItem = [[FDCalendarItem alloc] init];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    self.rightCalendarItem = [[FDCalendarItem alloc] init];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前显示的日期，初始化
- (void)setShowDate:(NSDate *)date {
    self.centerCalendarItem.date = date;
    self.leftCalendarItem.date = [self.centerCalendarItem previousMonthDate];
    self.rightCalendarItem.date = [self.centerCalendarItem nextMonthDate];
    
    self.centerCalendarItem.curDate = self.curDate;
    self.leftCalendarItem.curDate = self.curDate;
    self.rightCalendarItem.curDate = self.curDate;
    
    [self.titleButton setTitle:[self stringFromDate:self.centerCalendarItem.date] forState:UIControlStateNormal];
    
    NSArray *subViews = [self.scrollView subviews];
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    
    NSInteger offsetX = 0;
    NSInteger sizeWidth = 0;
    // 通过日期禁止左右滑动
    // 是否添加左item
    if (date.year > 2017 || (date.year == 2017 && date.month > 1)) {
        [self.scrollView addSubview:self.leftCalendarItem];
        offsetX += self.scrollView.frame.size.width;
        sizeWidth += self.scrollView.frame.size.width;
        
        self.leftButton.hidden = NO;
        
    } else {
        self.leftButton.hidden = YES;
    }
    
    // 添加中间item
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = sizeWidth;
    self.centerCalendarItem.frame = itemFrame;
    
    [self.scrollView addSubview:self.centerCalendarItem];
    sizeWidth += self.scrollView.frame.size.width;
    
    // 是否添加右item
    NSDate *todayDate = [NSDate date];
    if (date.year < todayDate.year || (date.year == todayDate.year && date.month < todayDate.month)) {
        itemFrame.origin.x = sizeWidth;
        self.rightCalendarItem.frame = itemFrame;
        
        [self.scrollView addSubview:self.rightCalendarItem];
        sizeWidth += self.scrollView.frame.size.width;
        
        self.rightButton.hidden = NO;
        
    } else {
        self.rightButton.hidden = YES;
    }
    
    self.scrollView.contentSize = CGSizeMake(sizeWidth, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    
    //self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

// 重新加载日历items的数据
- (void)reloadCalendarItems {
    CGPoint offset = self.scrollView.contentOffset;
    CGRect centerFrame = self.centerCalendarItem.frame;
    CGSize scrollSize = self.scrollView.contentSize;
    
    if (offset.x > centerFrame.origin.x && centerFrame.origin.x + centerFrame.size.width < scrollSize.width) {
        [self setNextMonthDate];
    } else if (offset.x < centerFrame.origin.x && centerFrame.origin.x > 0) {
        [self setPreviousMonthDate];
    }
    
}

- (void)setCurrentDate:(NSDate *)curDate {
    self.curDate = curDate;
    [self setShowDate:curDate];
}

#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousMonthDate {
    [self setShowDate:[self.centerCalendarItem previousMonthDate]];
}

// 跳到下一个月
- (void)setNextMonthDate {
    [self setShowDate:[self.centerCalendarItem nextMonthDate]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadCalendarItems];
}

#pragma mark - FDCalendarItemDelegate

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date {

    self.curDate = date;
    [self setShowDate:self.curDate];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.delegate didSelectDate:date];
    }
}

@end
