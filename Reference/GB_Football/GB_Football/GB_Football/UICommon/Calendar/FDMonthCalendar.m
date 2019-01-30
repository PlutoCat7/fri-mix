//
//  FDMonthCalendar.m
//  GB_Football
//
//  Created by gxd on 17/6/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "FDMonthCalendar.h"
#import "FDMonthCalendarItem.h"
#import "FDCalendarConfig.h"

static NSDateFormatter *dateFormattor;

@interface FDMonthCalendar () <UIScrollViewDelegate, FDMonthCalendarItemDelegate>

@property (assign, nonatomic) NSInteger curYear;
@property (assign, nonatomic) NSInteger curMonth;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FDMonthCalendarItem *leftCalendarItem;
@property (strong, nonatomic) FDMonthCalendarItem *centerCalendarItem;
@property (strong, nonatomic) FDMonthCalendarItem *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;
@end

@implementation FDMonthCalendar

- (instancetype)initWithCurrentDate:(NSInteger)year month:(NSInteger)month {
    if (self = [super init]) {
        self.backgroundColor = [FDCalendarConfig backgroundColor];
        self.curYear = year;
        self.curMonth = month;
        
        [self setupTitleBar];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        
        [self setShowDate:self.curYear month:self.curMonth];
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

- (NSString *)stringFromDate:(NSInteger)year month:(NSInteger)month {
    
    return [NSString stringWithFormat:@"%td", year];
}

// 设置上层的titleBar
- (void)setupTitleBar {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 45)];
    titleView.backgroundColor = [UIColor clearColor];
    [self addSubview:titleView];
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 25)];
    [self.leftButton setImage:[UIImage imageNamed:@"page_left.png"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(setPreviousYear) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.leftButton];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 40, 10, 30, 25)];
    [self.rightButton setImage:[UIImage imageNamed:@"page_right.png"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(setNextYear) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.rightButton];
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleButton setTitleColor:[FDCalendarConfig heightLightColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleButton.center = titleView.center;
    [titleView addSubview:titleButton];
    
    self.titleButton = titleButton;
}

// 设置包含日历的item的scrollView
- (void)setupScrollView {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, 45, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self addSubview:self.scrollView];
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    
    self.leftCalendarItem = [[FDMonthCalendarItem alloc] init];
    [self.scrollView addSubview:self.leftCalendarItem];
    
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = DeviceWidth;
    self.centerCalendarItem = [[FDMonthCalendarItem alloc] init];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    self.rightCalendarItem = [[FDMonthCalendarItem alloc] init];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前显示的日期，初始化
- (void)setShowDate:(NSInteger)year month:(NSInteger)month {
    self.centerCalendarItem.year = year;
    self.leftCalendarItem.year = [self.centerCalendarItem previousYear];
    self.rightCalendarItem.year = [self.centerCalendarItem nextYear];
    
    self.centerCalendarItem.curYear = self.curYear;
    self.leftCalendarItem.curYear = self.curYear;
    self.rightCalendarItem.curYear = self.curYear;
    
    self.centerCalendarItem.curMonth = self.curMonth;
    self.leftCalendarItem.curMonth = self.curMonth;
    self.rightCalendarItem.curMonth = self.curMonth;
    
    [self.titleButton setTitle:[self stringFromDate:year month:self.curMonth] forState:UIControlStateNormal];
    
    NSArray *subViews = [self.scrollView subviews];
    for (UIView *view in subViews) {
        [view removeFromSuperview];
    }
    
    NSInteger offsetX = 0;
    NSInteger sizeWidth = 0;
    // 通过日期禁止左右滑动
    // 是否添加左item
    if (year > 2017) {
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
    if (year < todayDate.year) {
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
        [self setNextYear];
    } else if (offset.x < centerFrame.origin.x && centerFrame.origin.x > 0) {
        [self setPreviousYear];
    }
    
}

- (void)setCurrentDate:(NSInteger)year month:(NSInteger)month {
    self.curYear = year;
    self.curMonth = month;
    [self setShowDate:year month:month];
}

#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousYear {
    [self setShowDate:[self.centerCalendarItem previousYear] month:self.curMonth];
}

// 跳到下一个月
- (void)setNextYear {
    [self setShowDate:[self.centerCalendarItem nextYear] month:self.curMonth];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadCalendarItems];
}

#pragma mark - FDCalendarItemDelegate

- (void)calendarItem:(FDMonthCalendarItem *)item selectedYear:(NSInteger)year selectedMonth:(NSInteger)month {
    self.curYear = year;
    self.curMonth = month;
    [self setShowDate:self.curYear month:self.curYear];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMonth:month:)]) {
        [self.delegate didSelectMonth:year month:month];
    }
}


@end
