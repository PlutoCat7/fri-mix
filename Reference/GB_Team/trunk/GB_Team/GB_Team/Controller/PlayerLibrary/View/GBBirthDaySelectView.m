//
//  GBBirthDaySelectView.m
//  GB_Team
//
//  Created by Pizza on 2016/11/28.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBirthDaySelectView.h"
#import "GBHightLightButton.h"
#import <pop/POP.h>
#import "XXNibBridge.h"

#define kZHDatePickerDefaultMinimumYear 1936
#define kZHDatePickerDefaultRowHeight 50.0f

typedef enum {
    ZHDatePickerDisplayModelBeforeCurrent = 0,
    ZHDatePickerDisplayModeFreeStyle = 1,
}ZHDatePickerDisplayMode;

@interface GBBirthDaySelectView ()<XXNibBridge>
// 保存按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
// 变色背景
@property (weak, nonatomic) IBOutlet UIView *backView;
// 弹出框
@property (weak, nonatomic) IBOutlet UIView *popBox;
// 日期选择器
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

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

@implementation GBBirthDaySelectView

#pragma mark -
#pragma mark Memory


#pragma mark - Action

- (IBAction)okButtonAction:(id)sender
{
    [GBBirthDaySelectView hide];
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

- (IBAction)actionClose:(id)sender
{
    [GBBirthDaySelectView hide];
}

#pragma mark - Private

-(void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.okButton.enabled = YES;
}

-(void)popAnimation
{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.duration = 0.5f;
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.width);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.width-470/2);
    [self.popBox.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished)
    {
        [self.popBox.layer pop_removeAnimationForKey:@"positionAnimation"];
    }};
    [self alphaHalf:self.backView  fade:NO duration:0.5f  beginTime:0 completionBlock:^{}];
}

-(void)hideAnimation:(void(^)())completionBlock;
{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.duration    = 0.5f;
    positionAnimation.fromValue   = @([UIScreen mainScreen].bounds.size.width-470/2);
    positionAnimation.toValue     = @([UIScreen mainScreen].bounds.size.width+470/2);
    [self.popBox.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished){
            [self.popBox.layer pop_removeAnimationForKey:@"positionAnimation"];
            [self.popBox removeFromSuperview];
            BLOCK_EXEC(completionBlock);
        }};
    [self alphaHalf:self.backView  fade:YES duration:0.5f  beginTime:0 completionBlock:^{}];
}

-(void)alphaHalf:(UIView*)view fade:(BOOL)fade duration:(CGFloat)duration beginTime:(CGFloat)beginTime completionBlock:(void(^)())completionBlock
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + beginTime;
    if (fade)
    {
        anim.fromValue = @(0.7);
        anim.toValue   = @(0.0);
    }
    else
    {
        anim.fromValue = @(0.0);
        anim.toValue   = @(0.7);
    }
    anim.completionBlock = ^(POPAnimation *ani, BOOL fin){
        if(fin)
        {
            [view pop_removeAnimationForKey:@"alpha"];
            BLOCK_EXEC(completionBlock);
        }
    };
    [view pop_addAnimation:anim forKey:@"alpha"];
}

#pragma mark - Getters & Setters

// 弹出
+(GBBirthDaySelectView *)showWithDate:(NSDate *)date
{
    GBBirthDaySelectView *selectView = [[[NSBundle mainBundle] loadNibNamed:@"GBBirthDaySelectView" owner:nil options:nil]
                                        lastObject];
    [selectView loadData];
    selectView.frame = [UIScreen mainScreen].bounds;
    if (date) {
        selectView.selectedYear = date.year;
        selectView.selectedMonth = date.month;
        selectView.selectedDay = date.day;
    }
    [selectView.pickerView selectRow:(selectView.selectedYear - selectView.minYear) inComponent:0 animated:NO];
    [selectView.pickerView selectRow:(selectView.selectedMonth - 1) inComponent:1 animated:NO];
    [selectView.pickerView selectRow:(selectView.selectedDay - 1) inComponent:2 animated:NO];
    [selectView popAnimation];
    [selectView setupUI];
    
    [[UIApplication sharedApplication].keyWindow addSubview:selectView];
    return selectView;
}

// 收起
+(void)hide
{
    GBBirthDaySelectView *selectView = [GBBirthDaySelectView HUDForView];
    if (selectView)
    {
        
        [selectView hideAnimation:^(void){
            [selectView removeFromSuperview];
        }];
    }
}

+ (GBBirthDaySelectView *)HUDForView
{
    GBBirthDaySelectView *hud = nil;
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class hudClass = [GBBirthDaySelectView class];
    for (UIView *aView in subViewsArray)
    {
        if ([aView isKindOfClass:hudClass])
        {
            hud = (GBBirthDaySelectView *)aView;
        }
    }
    return hud;
}

- (void)loadData {
    
    NSDate *currentDate = [NSDate date];
    NSInteger curMonth = currentDate.month;
    NSInteger curDay = currentDate.day;
    NSInteger curYear = currentDate.year;
    _minYear = kZHDatePickerDefaultMinimumYear;
    _maxYear = curYear;
    _selectedYear = curYear - 26;
    _selectedMonth = curMonth;
    _selectedDay = curDay;
    [_pickerView reloadAllComponents];
    [_pickerView setShowsSelectionIndicator:YES];
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
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _pickerView.frame.size.width / 3, kZHDatePickerDefaultRowHeight)];
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
    _selectedYear = [_pickerView selectedRowInComponent:0] + _minYear;
    _selectedMonth = [_pickerView selectedRowInComponent:1] + 1;
    _selectedDay = [_pickerView selectedRowInComponent:2] + 1;
    
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
    [self.popBox.layer pop_removeAllAnimations];
    [self.backView.layer pop_removeAllAnimations];
}

@end
