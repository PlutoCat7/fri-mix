//
//  TallyTimePickerView.m
//  Demo2018
//
//  Created by AlienJunX on 2018/2/26.
//  Copyright © 2018年 AlienJunX. All rights reserved.
//

#import "TallyTimePickerView.h"


@interface TallyTimePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, weak) UIView *container;
@property (nonatomic, weak) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *dateStrArray;
@property (nonatomic , copy) TallyTimePickerViewBlock block;
@end

@implementation TallyTimePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bg = [UIView new];
        [self addSubview:bg];
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = 0.4;
        
        //
        UIView *container = [UIView new];
        [self addSubview:container];
        self.container = container;
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.height.equalTo(@250);
            make.bottom.equalTo(self).offset(250);
        }];
        
        UIView *toolView = [UIView new];
        toolView.backgroundColor = [UIColor whiteColor];
        [container addSubview: toolView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            make.leading.trailing.top.equalTo(container);
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [okBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [toolView addSubview:cancelBtn];
        [toolView addSubview:okBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(toolView);
            make.width.equalTo(@50);
        }];
        [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(toolView);
            make.width.equalTo(@50);
        }];
        
        
        UIPickerView *pickerView = [UIPickerView new];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        pickerView.backgroundColor = XWColorFromHex(0xf6f6f5);
        [container addSubview:pickerView];
        self.pickerView = pickerView;
        
        [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@206);
            make.leading.trailing.equalTo(container);
            make.top.equalTo(toolView.mas_bottom);
        }];

        // 默认选中
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self defaultSelected];
        });
    }
    return self;
}

- (void)defaultSelected {
    // 选中当前时间行
    NSInteger hoursIndex = 0;
    NSInteger minuteIndex = 0;
    NSInteger dayIndex = 0;
    
    // 获取系统当前时间
    NSDate *date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"HH"];
    NSString *h = [df stringFromDate:currentDate];
    
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init ];
    [df1 setDateFormat:@"mm"];
    NSString *m = [df1 stringFromDate:currentDate];
    
    // 找到时间所在位置
    hoursIndex = [self.hoursArray indexOfObject:h];
    minuteIndex = [self.minuteArray indexOfObject:m];
    
    for (NSInteger i =0; i<self.dateArray.count; i++) {
        NSDate *datea = self.dateArray[i];
        if (currentDate.year == datea.year && currentDate.month == datea.month && currentDate.day == datea.day){
            // 今天
            dayIndex = i;
            break;
        }
    }
    [self.pickerView selectRow:dayIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:hoursIndex inComponent:1 animated:NO];
    [self.pickerView selectRow:minuteIndex inComponent:2 animated:NO];
}

- (void)show:(TallyTimePickerViewBlock)block {
    _block = block;
    
    [kKeyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(kKeyWindow);
    }];
    [self.superview layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UIPickViewDatasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dateArray.count;
    }
    if (component == 1) {
        return self.hoursArray.count;
    }
    if (component == 2) {
        return self.minuteArray.count;
    }
    return 5;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 160;
    }
    return 40;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.dateStrArray[row];
    }
    
    if (component == 1) {
        return self.hoursArray[row];
    }
    
    if (component == 2) {
        return self.minuteArray[row];
    }
    return @"";
}

#pragma mark - Action
- (void)okBtnAction:(UIButton *)sender {
    NSInteger dayIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger hoursIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger minuteIndex = [self.pickerView selectedRowInComponent:2];
    
    NSDate *date = self.dateArray[dayIndex];
    NSString *hour = self.hoursArray[hoursIndex];
    NSString *minute = self.minuteArray[minuteIndex];
    
    NSString *str = [NSDate stringWithDate:date format:@"yyyy年MM月dd日"];
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@:%@", str, hour, minute];
    NSLog(@"%@", timeStr);
    
    NSDate *outDate = [NSDate dateWithString:[NSString stringWithFormat:@"%@:00", timeStr] format:@"yyyy年MM月dd日 HH:mm:ss"];
    
    if (self.block) {
        self.block(timeStr, outDate);
    }
    
    [self cancelBtnAction:nil];
}

- (void)cancelBtnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(250);
        }];
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter/setter
- (NSMutableArray *)hoursArray {
    if (_hoursArray == nil) {
        _hoursArray = [NSMutableArray array];
        for (int i = 0; i < 24; i++) {
            if (i < 10) {
                [_hoursArray addObject:[NSString stringWithFormat:@"0%d",i]];
            } else {
                [_hoursArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
    }
    return _hoursArray;
}

- (NSMutableArray *)minuteArray {
    if (_minuteArray == nil) {
        _minuteArray = [NSMutableArray array];
        
        for (int i = 0; i < 60; i++) {
            if (i < 10) {
                [_minuteArray addObject:[NSString stringWithFormat:@"0%d",i]];
            } else {
                [_minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
        }
    }
    return _minuteArray;
}

- (NSMutableArray *)dateArray {
    if (_dateArray == nil) {
        _dateArray = [NSMutableArray array];
        
        NSDate *date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM"];
        
        
        // 前个月
        NSString *dateString = [NSString stringWithFormat:@"%lu-%lu", [currentDate year], [currentDate month]-1];
        NSDate *preMonth = [formatter dateFromString:dateString];
        for (int i = 1; i <= [preMonth getDays]; i++) {
            NSDate *d = [self getAMonthDate:preMonth day:i];
            [_dateArray addObject:d];
        }
        
        // 当前月
        for (int i = 1; i <= [currentDate getDays]; i++) {
            NSDate *d = [self getAMonthDate:currentDate day:i];
            [_dateArray addObject:d];
        }
        
        // 后个月
        NSString *dateString1 = [NSString stringWithFormat:@"%lu-%lu", [currentDate year], [currentDate month]+1];
        NSDate *nextMonth = [formatter dateFromString:dateString1];
        for (int i = 1; i <= [nextMonth getDays]; i++) {
            NSDate *d = [self getAMonthDate:nextMonth day:i];
            [_dateArray addObject:d];
        }
    }
    return _dateArray;
}

- (NSMutableArray *)dateStrArray {
    if (_dateStrArray == nil) {
        // 处理显示的dateStrArray
        _dateStrArray = [NSMutableArray array];
        NSDate *date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        for (NSDate *date in self.dateArray) {
            if (currentDate.year == date.year && currentDate.month == date.month && currentDate.day == date.day){
                // 今天
                [_dateStrArray addObject:@"今天"];
            } else {
                NSString *weekDay = [date dayFromWeekday2];
                NSString *dateStr = [NSDate stringWithDate:date format:@"M月dd日"];
                NSString *str = [NSString stringWithFormat:@"%@ %@", dateStr, weekDay];
                [_dateStrArray addObject:str];
            }
        }
    }
    return _dateStrArray;
}

- (NSDate *)getAMonthDate:(NSDate*)date day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components: dayInfoUnits fromDate:date];
    components.day = day;
    NSDate *nextMonthDate = [calendar dateFromComponents:components];
    return nextMonthDate;
}


@end
