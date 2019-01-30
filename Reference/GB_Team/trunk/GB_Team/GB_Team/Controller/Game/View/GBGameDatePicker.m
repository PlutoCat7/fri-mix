//
//  GBGameDatePicker.m
//  GB_Team
//
//  Created by gxd on 16/11/29.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGameDatePicker.h"
#import <pop/POP.h>
#import "XXNibBridge.h"

#define kZHDatePickerDefaultMinimumYear 1936
#define kZHDatePickerDefaultRowHeight 50.0f

typedef enum {
    ZHDatePickerDisplayModelBeforeCurrent = 0,
    ZHDatePickerDisplayModeFreeStyle = 1,
}ZHDatePickerDisplayMode;

@interface GBGameDatePicker()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UIPickerView *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *container;

// 日期参数
@property (weak, nonatomic)  NSArray *years;
@property (weak, nonatomic)  NSArray *months;
@property (weak, nonatomic)  NSArray *days;
@property (assign, nonatomic) NSInteger selectedYear;
@property (assign, nonatomic) NSInteger selectedMonth;
@property (assign, nonatomic) NSInteger selectedDay;
@property(nonatomic, assign) NSInteger minYear;
@property(nonatomic, assign) NSInteger maxYear;
@property(nonatomic, assign) ZHDatePickerDisplayMode pickerDisplayMode;

@end

@implementation GBGameDatePicker

+ (instancetype)showWithDate:(NSDate *)date {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBGameDatePicker" owner:self options:nil];
    for (UIView *view in viewArray) {
        if ([view isKindOfClass:[GBGameDatePicker class]]) {
            GBGameDatePicker *selectView = (GBGameDatePicker *) view;
            selectView.frame = [UIScreen mainScreen].bounds;
            if (date) {
                selectView.selectedYear = date.year;
                selectView.selectedMonth = date.month;
                selectView.selectedDay = date.day;
            }
            
            [selectView.datePickerView selectRow:(selectView.selectedYear - selectView.minYear) inComponent:0 animated:NO];
            [selectView.datePickerView selectRow:(selectView.selectedMonth - 1) inComponent:1 animated:NO];
            [selectView.datePickerView selectRow:(selectView.selectedDay - 1) inComponent:2 animated:NO];
            
            [keywindow addSubview:selectView];
            
            return selectView;
        }
    }
    
    return nil;
}

+ (BOOL)hide {
    GBGameDatePicker *hud = [GBGameDatePicker HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)
    {
        POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionAnimation.toValue = @([UIScreen mainScreen].bounds.size.height+hud.container.size.height/2);
        [hud.container.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (finished){
                [hud removeFromSuperview];
                [hud.container.layer pop_removeAnimationForKey:@"positionAnimation"];
            }};
        POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        opacityAnimation.fromValue = @(1);
        opacityAnimation.toValue   = @(0);
        opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (finished){
                [hud.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
            }};
        [hud.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        return YES;
    }
    return NO;
}

+ (GBGameDatePicker *)HUDForView: (UIView *)view {
    GBGameDatePicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBGameDatePicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBGameDatePicker *)aView;
        }
    }
    return hud;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self loadData];
    [self setupUI];
    [self setupAnimation];
}

-(void)dealloc
{
    [self.backView.layer pop_removeAllAnimations];
    [self.container.layer pop_removeAllAnimations];
}

- (void)loadData{
    NSDate *currentDate = [NSDate date];
    NSInteger curMonth = currentDate.month;
    NSInteger curDay = currentDate.day;
    NSInteger curYear = currentDate.year;
    _minYear = kZHDatePickerDefaultMinimumYear;
    _maxYear = curYear;
    _selectedYear = curYear - 26;
    _selectedMonth = curMonth;
    _selectedDay = curDay;
    [_datePickerView reloadAllComponents];
    [_datePickerView setShowsSelectionIndicator:YES];
}


- (void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}


- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+self.container.size.height/2);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-self.container.size.height/2);
    [self.container.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished){
        [self.container.layer pop_removeAnimationForKey:@"positionAnimation"];
    }};
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished){
        self.backView.alpha = 1.0f;
        [self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
    }};
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (IBAction)actionCancel:(id)sender {
    [GBGameDatePicker hide];
}

- (IBAction)actionSave:(id)sender {
    [GBGameDatePicker hide];
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(didSelectDateWithDate:year:month:day:)])
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:_selectedDay];
        [components setMonth:_selectedMonth];
        [components setYear:_selectedYear];
        NSDate *selecteDate = [calendar dateFromComponents:components];
        [self.delegate didSelectDateWithDate:selecteDate year:_selectedYear month:_selectedMonth day:_selectedDay];
    }
}

- (IBAction)actionTapDismiss:(id)sender {
    [GBGameDatePicker hide];
}

#pragma mark - Property

- (void)setMinYear:(NSInteger)minYear {
    _minYear = minYear;
    
    if (_minYear >= _maxYear) {
        
        //reset default
        _minYear = kZHDatePickerDefaultMinimumYear;
        _maxYear = [self _getCurYear] + 100;
    }
    [_datePickerView reloadAllComponents];
    
}

- (void)setMaxYear:(NSInteger)maxYear {
    _maxYear = maxYear;
    if (_maxYear <= _minYear) {
        _minYear = kZHDatePickerDefaultMinimumYear;
        _maxYear = [self _getCurYear] + 100;
    }
    [_datePickerView reloadAllComponents];
    
}


- (void)setPickerDisplayMode:(ZHDatePickerDisplayMode)pickerDisplayMode {
    _pickerDisplayMode = pickerDisplayMode;
    
    switch (_pickerDisplayMode) {
        case ZHDatePickerDisplayModeFreeStyle: {
            
            _minYear = kZHDatePickerDefaultMinimumYear;
            _maxYear = [self _getCurYear] + 100;
        }
            break;
        case ZHDatePickerDisplayModelBeforeCurrent: {
            //strict on display rows
            
            _maxYear = [self _getCurYear];
            _minYear = kZHDatePickerDefaultMinimumYear;
        }
            break;
        default:
            break;
    }
    
    [_datePickerView reloadAllComponents];
}

- (NSInteger)_getCurMonth {
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSInteger curMonth = [components month];
    
    
    return curMonth;
}

- (NSInteger)_getCurDay {
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    
    NSInteger curDay = [components day];
    
    
    return curDay;
}

- (NSInteger)_getCurYear {
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSInteger curYear = [components year];
    
    return curYear;
}

#pragma mark - Picker Delegate &&s Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    switch (component) {
        case 0: {
            //year
            return (_maxYear - _minYear) + 1;
        }
            break;
        case 1: {
            //month
            
            NSInteger yearSelected = [pickerView selectedRowInComponent:0] + _minYear;
            switch (_pickerDisplayMode) {
                case ZHDatePickerDisplayModeFreeStyle: {
                    return 12;
                }
                    break;
                case ZHDatePickerDisplayModelBeforeCurrent: {
                    if ([self _getCurYear] == yearSelected) {
                        return [self _getCurMonth];
                    }
                    return 12;
                }
                    break;
                default:
                    break;
            }
            return 12;
            
        }
            break;
        case 2: {
            //day
            
            
            //get selected year and month;
            NSInteger yearSelected = [pickerView selectedRowInComponent:0] + _minYear;
            NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
            
            if (_pickerDisplayMode == ZHDatePickerDisplayModelBeforeCurrent) {
                
                if (yearSelected == [self _getCurYear] && monthSelected == [self _getCurMonth]) {
                    return [self _getCurDay];
                }
                
            }
            if (monthSelected == 2 && (yearSelected % 4 == 0) && (yearSelected % 100 != 0)) {
                //lap year
                return 29;
            } else if (monthSelected == 2) {
                return 28;
            } else if (monthSelected == 1 || monthSelected == 3 || monthSelected == 5 || monthSelected == 7 || monthSelected == 8 || monthSelected == 10 || monthSelected == 12) {
                return 31;
            } else {
                return 30;
            }
        }
            break;
        default: {
            return 0;
        }
            break;
    }
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kZHDatePickerDefaultRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = (UILabel *) view;
    if (nil == label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _datePickerView.frame.size.width / 3, kZHDatePickerDefaultRowHeight)];
    }
    
    [label setFont:[UIFont systemFontOfSize:22.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[ColorManager textColor]];
    
    NSString *title = @"";
    switch (component) {
        case 0://year
            title = [NSString stringWithFormat:@"%td%@", row + _minYear,LS(@"年")];
            break;
        case 1://month
            title = [NSString stringWithFormat:@"%td%@", row + 1,LS(@"月")];
            break;
        case 2://day
            title = [NSString stringWithFormat:@"%td%@", row + 1,LS(@"日")];
            break;
        default:
            break;
    }
    [label setText:title];
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            //year
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
        }
            break;
        case 1: {
            //month
            [pickerView reloadComponent:2];
        }
            break;
        case 2: {
            //day
            
        }
            break;
            
        default:
            break;
    }
    _selectedYear = [_datePickerView selectedRowInComponent:0] + _minYear;
    _selectedMonth = [_datePickerView selectedRowInComponent:1] + 1;
    _selectedDay = [_datePickerView selectedRowInComponent:2] + 1;
    
}

@end
