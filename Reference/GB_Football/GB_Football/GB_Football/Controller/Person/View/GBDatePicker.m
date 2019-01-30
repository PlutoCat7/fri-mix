//
//  GBDatePicker.m
//  GB_Football
//
//  Created by Pizza on 16/8/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBDatePicker.h"
#import <pop/POP.h>

#define  kZHDatePickerDefaultMinimumYear ([NSDate date].year-80)
#define  kZHDatePickerDefaultMaxYear ([NSDate date].year)
#define  kZHDatePickerDefaultAge 30   //默认30岁
#define kZHDatePickerDefaultRowHeight 50.0f

@interface GBDatePicker()
// 选择器
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
// 选择器的容器，用于后期layer层做动画
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic)  NSArray *years;
@property (weak, nonatomic)  NSArray *months;
@property (weak, nonatomic)  NSArray *days;
@property (assign, nonatomic) NSInteger selectedYear;
@property (assign, nonatomic) NSInteger selectedMonth;
@property (assign, nonatomic) NSInteger selectedDay;
@property(nonatomic, assign) NSInteger minYear;
@property(nonatomic, assign) NSInteger maxYear;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *birthdayStLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;


@end


@implementation GBDatePicker

- (void)loadData{
    NSDate *currentDate = [NSDate date];
    NSInteger curMonth = currentDate.month;
    NSInteger curDay = currentDate.day;
    NSInteger curYear = currentDate.year;
    _minYear = kZHDatePickerDefaultMinimumYear;
    _maxYear = kZHDatePickerDefaultMaxYear;
    _selectedYear = curYear - kZHDatePickerDefaultAge;
    _selectedMonth = curMonth;
    _selectedDay = curDay;
    [_pickerView reloadAllComponents];
    [_pickerView setShowsSelectionIndicator:YES];
}

- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+265.f/2);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-265.f/2+[self equalizeHeight]);
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished)
        {
            [self.container.layer pop_removeAnimationForKey:@"positionAnimation"];
        }
    };
    [self.container.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished){
            self.backView.alpha = 1.0f;
            [self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
        }
    };
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

-(void)setupUI{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.birthdayStLbl.text = LS(@"personal.hint.birthday");
    [self.cancelBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.saveBtn setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self loadData];
    [self setupUI];
    [self setupAnimation];
}

- (void)setPickerTitle:(NSString *)title {
    self.birthdayStLbl.text = title;
}

+ (instancetype)showWithDate:(NSDate *)date {
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    GBDatePicker *picker = [[NSBundle mainBundle]loadNibNamed:@"GBDatePicker" owner:self options:nil][0];
    picker.frame = [UIScreen mainScreen].bounds;
    if (date) {
        picker.selectedYear = date.year;
        picker.selectedMonth = date.month;
        picker.selectedDay = date.day;
    }
    [picker.pickerView selectRow:(picker.selectedYear - picker.minYear) inComponent:0 animated:NO];
    [picker.pickerView selectRow:(picker.selectedMonth - 1) inComponent:1 animated:NO];
    [picker.pickerView selectRow:(picker.selectedDay - 1) inComponent:2 animated:NO];
    [keywindow addSubview:picker];
    return picker;
}

+ (instancetype)showWithDate:(NSDate *)date title:(NSString *)title {
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    GBDatePicker *picker = [[NSBundle mainBundle]loadNibNamed:@"GBDatePicker" owner:self options:nil][0];
    picker.frame = [UIScreen mainScreen].bounds;
    if (date) {
        picker.selectedYear = date.year;
        picker.selectedMonth = date.month;
        picker.selectedDay = date.day;
    }
    [picker.pickerView selectRow:(picker.selectedYear - picker.minYear) inComponent:0 animated:NO];
    [picker.pickerView selectRow:(picker.selectedMonth - 1) inComponent:1 animated:NO];
    [picker.pickerView selectRow:(picker.selectedDay - 1) inComponent:2 animated:NO];
    
    [picker setPickerTitle:title];
    
    [keywindow addSubview:picker];
    return picker;
}

+ (BOOL)hide
{
    GBDatePicker *hud = [GBDatePicker HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)
    {
        POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionAnimation.toValue = @([UIScreen mainScreen].bounds.size.height+hud.container.size.height/2);
        [hud.container.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
            if (finished){
                [hud.container.layer pop_removeAnimationForKey:@"positionAnimation"];
                [hud removeFromSuperview];
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

+ (GBDatePicker *)HUDForView: (UIView *)view {
    
    GBDatePicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBDatePicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBDatePicker *)aView;
        }
    }
    return hud;
}

#pragma mark - Property

- (void)setMinYear:(NSInteger)minYear {
    _minYear = minYear;
    
    if (_minYear >= _maxYear) {
        
        //reset default
        _minYear = kZHDatePickerDefaultMinimumYear;
        _maxYear = [self _getCurYear] + 100;
    }
    [_pickerView reloadAllComponents];
    
}

- (void)setMaxYear:(NSInteger)maxYear {
    _maxYear = maxYear;
    if (_maxYear <= _minYear) {
        _minYear = kZHDatePickerDefaultMinimumYear;
        _maxYear = [self _getCurYear] + 100;
    }
    [_pickerView reloadAllComponents];
    
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
    
    [_pickerView reloadAllComponents];
}

- (NSInteger)_getCurMonth {
    
    return [NSDate date].month;
}

- (NSInteger)_getCurDay {
    
    return [NSDate date].day;
}

- (NSInteger)_getCurYear {
    
    return kZHDatePickerDefaultMaxYear;
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
            
            //NSInteger yearSelected = [pickerView selectedRowInComponent:0] + _minYear;
            switch (_pickerDisplayMode) {
                case ZHDatePickerDisplayModeFreeStyle: {
                    return 12;
                }
                    break;
                case ZHDatePickerDisplayModelBeforeCurrent: {
//                    if ([self _getCurYear] == yearSelected) {
//                        return [self _getCurMonth];
//                    }
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

            NSInteger yearSelected = [pickerView selectedRowInComponent:0] + _minYear;
            NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;

            if (yearSelected == 1937 && monthSelected == 1) {
                 yearSelected  = self.selectedYear;
                 monthSelected = self.selectedMonth;
            }

            if (monthSelected == 2 && ((yearSelected%4 == 0 && yearSelected%100 != 0) || yearSelected % 400 == 0)) {
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
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _pickerView.frame.size.width / 3, kZHDatePickerDefaultRowHeight)];
    }
    
    [label setFont:[UIFont systemFontOfSize:22.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[ColorManager textColor]];
    
    NSString *title = @"";
    switch (component) {
        case 0://year
            title = [NSString stringWithFormat:@"%zd%@", row + _minYear,LS(@"personal.label.year")];
            break;
        case 1://month
            title = [NSString stringWithFormat:@"%zd%@", row + 1,LS(@"personal.label.month")];
            break;
        case 2://day
            title = [NSString stringWithFormat:@"%zd%@", row + 1,LS(@"personal.label.day")];
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
    

    _selectedYear = [_pickerView selectedRowInComponent:0] + _minYear;
    _selectedMonth = [_pickerView selectedRowInComponent:1] + 1;
    _selectedDay = [_pickerView selectedRowInComponent:2] + 1;

}

- (IBAction)actionTapDissmiss:(id)sender {
    [GBDatePicker hide];
}

- (IBAction)actionCancel:(id)sender {
    [GBDatePicker hide];
}
- (IBAction)actionSave:(id)sender {
    [GBDatePicker hide];
    
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

// 用于微调位置，机型适配
-(CGFloat)equalizeHeight
{
    if (IS_IPHONE4) {
        return 20;
    }
    else if(IS_IPHONE5){
        return 20;
    }
    else if(IS_IPHONE6){
        return 0;
    }
    else if(IS_IPHONE6P){
        return -20;
    }
    return 0;
}

-(void)dealloc
{
    [self.container.layer pop_removeAllAnimations];
    [self.backView.layer pop_removeAllAnimations];
}

@end
