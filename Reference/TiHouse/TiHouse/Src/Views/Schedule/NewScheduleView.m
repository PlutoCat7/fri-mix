//
//  NewScheduleView.m
//  TiHouse
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "NewScheduleView.h"
#import "NewScheduleModel.h"
#import "SelectColorView.h"
#import "AddScheduleModel.h"
#import "User.h"
#import "NSDate+Extend.h"
#import "NewHousePersonModel.h"
#import "Login.h"

@interface NewScheduleView ()<UIScrollViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollBottomView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *sevaBtn;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UIButton *remindTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *remindPeopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectColorBtn;
@property (weak, nonatomic) IBOutlet UILabel *startymdLabel;
@property (weak, nonatomic) IBOutlet UILabel *starthmLabel;
@property (weak, nonatomic) IBOutlet UILabel *endYmdLabel;
@property (weak, nonatomic) IBOutlet UILabel *endHmLabel;
@property (weak, nonatomic) IBOutlet UIView *pikerDateView;
@property (weak, nonatomic) IBOutlet UILabel *remindContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindPeopleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIView *startAndEndTimeView;
@property (weak, nonatomic) IBOutlet UIView *scrollSubView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *pikerDateBottomLine;
@property (weak, nonatomic) IBOutlet UIView *remindListView;
@property (weak, nonatomic) IBOutlet UIView *remindListLine;
@property (weak, nonatomic) IBOutlet UIView *remindPeopleView;
@property (weak, nonatomic) IBOutlet UIView *remindBottomSubView;
@property (weak, nonatomic) IBOutlet UIView *sureBtnView;

@property (strong, nonatomic) NSString * selectColorStr;
@property (assign, nonatomic) BOOL isTapStart;
@property (assign, nonatomic) BOOL isEditEndTime;
@property (strong, nonatomic) NSDate * startDate;
@property (strong, nonatomic) NSDate * endDate;
@property (assign, nonatomic) NSInteger remindTimeIndex;
@property (strong, nonatomic) NSString * remindPeopleUidStr;

//view
@property (strong, nonatomic) SelectColorView * selectColorView;

//model
@property (strong, nonatomic) NewScheduleModel * scheduleModel;

@end

@implementation NewScheduleView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    
    NewScheduleView * newScheduleView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    newScheduleView.scheduleModel = viewModel;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:newScheduleView action:@selector(viewTap)];
    [newScheduleView addGestureRecognizer:tap];
    
    [newScheduleView xl_setupViews];
    
    return newScheduleView;
}

-(void)viewTap {
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.sevaBtn sizeToFit];
    self.sevaBtn.frame = CGRectMake(0, 0, self.sevaBtn.frame.size.width, self.sevaBtn.frame.size.height);
    [self.sureBtnView bringSubviewToFront:self.sevaBtn];
    self.sevaBtn.center = CGPointMake(self.sureBtnView.frame.size.width/2, self.sureBtnView.frame.size.height/2);
}

-(void)xl_setupViews {
    
    [self.pikerDateView setHidden:YES];
    [self.pikerDateBottomLine setHidden:YES];
    [self.remindListView setOrigin:CGPointMake(self.remindListView.x, self.pikerDateView.top)];
    [self.remindListLine setOrigin:CGPointMake(self.remindListLine.x, self.remindListView.bottom)];
    [self.remindListLine setHidden:YES];
    
    [self.remindPeopleView setOrigin:CGPointMake(self.remindPeopleView.x, self.remindListLine.bottom)];
    [self.remindPeopleView setHidden:YES];
    
    [self.lineView setOrigin:CGPointMake(self.lineView.x, self.remindListView.bottom)];
    [self.scrollBottomView setSize:CGSizeMake(kScreen_Width, 149)];
    [self.scrollBottomView setOrigin:CGPointMake(self.scrollBottomView.x, self.lineView.bottom)];
    [self.remindBottomSubView setFrame:CGRectMake(0, 49, kScreen_Width, 76)];
    [self.remarkTextView setFrame:CGRectMake(self.remarkTextView.x, 0, kScreen_Width - 26, 76)];
    [self.scrollView setHeight:kScreen_Height - 64 - 80 - 50];
    [self.scrollSubView setHeight:self.scrollBottomView.bottom];
    [self.scrollView setContentSize:CGSizeMake(kScreen_Width, self.scrollSubView.y + self.scrollSubView.height)];
    
    [self.textTF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.sureBtnView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sureBtnView.layer.shadowOffset = CGSizeMake(3, 3);
    self.sureBtnView.layer.shadowOpacity = 0.8;
    self.sureBtnView.layer.shadowRadius = 5;
    
    
    //如果scheduleM存在数据，为编辑状态
    if (self.scheduleModel.scheduleM) {
        self.selectColorStr = self.scheduleModel.scheduleM.schedulecolor;
        self.textTF.text = [NSString emojizedStringWithString:IF_NULL_TO_STRINGSTR(self.scheduleModel.scheduleM.schedulename, @"")];//允许输入emojin
        self.remindTimeIndex = self.scheduleModel.scheduleM.scheduletiptype;
        self.remindContentLabel.text = [self getRemindTimeNameWithID:(int)self.scheduleModel.scheduleM.scheduletiptype];
        self.remarkTextView.text = [NSString emojizedStringWithString:IF_NULL_TO_STRINGSTR(self.scheduleModel.scheduleM.scheduleremark,@"")];//允许输入emojin
        self.remarkTextView.textColor = [UIColor blackColor];
        self.remindPeopleUidStr = self.scheduleModel.scheduleM.schedulearruidtip;
        self.switchBtn.on = self.scheduleModel.scheduleM.scheduletype;
        
        //提醒谁
        self.remindPeopleLabel.text = self.scheduleModel.scheduleM.nameschedulearruidtip;
        
        //默认起始时间和结束时间
        NSDate * nowDate = [NSDate dateFromTimestamp:self.scheduleModel.scheduleM.schedulestarttime / 1000];
        self.startymdLabel.text = [self getYYYY_MM_DD:nowDate];
        self.starthmLabel.text = [self getHH_mm:nowDate];
        self.startDate = nowDate;
        
        NSDate * newDate = [NSDate dateFromTimestamp:self.scheduleModel.scheduleM.scheduleendtime / 1000];
        self.endYmdLabel.text = [self getYYYY_MM_DD:newDate];
        self.endHmLabel.text = [self getHH_mm:newDate];
        self.endDate = newDate;
        
    } else {
        //默认选中的颜色
        self.selectColorStr = @"FCD586";//默认颜色
        self.remindTimeIndex = 0;//默认不提醒
        self.remarkTextView.textColor = XWColorFromHex(0xBFBFBF);
        self.remindPeopleUidStr = @"";
        
        //默认起始时间和结束时间
        NSDate * nowDate = [NSDate new];
        if (self.scheduleModel.createDate) {
           nowDate = self.scheduleModel.createDate;
        }
        
        self.startymdLabel.text = [self getYYYY_MM_DD:nowDate];
        self.starthmLabel.text = [self getHH_mm:nowDate];
        self.endYmdLabel.text = self.startymdLabel.text;
        self.startDate = nowDate;
        
        NSTimeInterval count = nowDate.timeIntervalSinceNow + 3600;
        NSDate * newDate = [NSDate dateWithTimeIntervalSinceNow:count];
        self.endHmLabel.text = [self getHH_mm:newDate];
        self.endDate = newDate;
    }
}

#pragma mark - public method

/**
 * 设置提醒时间
 */
-(void)makeRemindTimeContent:(NSString *)value withIndex:(NSInteger )index {
    self.remindContentLabel.text = value;
    self.remindTimeIndex = index;
}

/**
 * 设置提醒的人
 */
-(void)makeRemindPeopleContent:(NSArray *)valueArray {
    
    NSMutableString * uidStr = [[NSMutableString alloc] init];
    NSMutableString * nameStr = [[NSMutableString alloc] init];
    for (int i = 0; i < valueArray.count; i++) {
        NewHousePersonModel * user = valueArray[i];
        if (i == valueArray.count - 1) {
            [nameStr appendString:[NSString stringWithFormat:@"%@",user.nickname]];
            [uidStr appendString:[NSString stringWithFormat:@"%ld",user.uidconcert]];
        } else {
            [nameStr appendString:[NSString stringWithFormat:@"%@,",user.nickname]];
            [uidStr appendString:[NSString stringWithFormat:@"%ld,",user.uidconcert]];
        }
    }
    self.remindPeopleLabel.text = nameStr;
    self.remindPeopleUidStr = uidStr;
}

#pragma mark - private method

/**
 * 选择颜色按钮
 */
- (IBAction)selectColorBtnAction:(UIButton *)sender {
    [self.textTF resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectColorView];
    [self.selectColorView showSelectColorView];
    
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
}

/**
 * 提醒时间
 */
- (IBAction)remindTimeAction:(UIButton *)sender {
    [self.scheduleModel.remindTimeSubject sendNext:@(self.remindTimeIndex)];
    
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
}

/**
 * 提醒谁看事件
 */
- (IBAction)remindPeopleAction:(UIButton *)sender {
    [self.scheduleModel.remindPeopleSubject sendNext:self.remindPeopleUidStr];
    
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
}

/**
 * 保存按钮事件
 */
- (IBAction)saveBtnAction:(UIButton *)sender {
    
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
    
//    if (self.textTF.text.length <= 0) {
//        [NSObject showHudTipStr:@"请输入日程项目"];
//        return;
//    }
//
//    if (self.remindPeopleLabel.text.length <= 0) {
//        [NSObject showHudTipStr:@"请选择提醒谁看"];
//        return;
//    }
//
    NSString * remark = nil;
    if (![self.remarkTextView.text isEqualToString:@"请在此添加备注"]) {
        remark = self.remarkTextView.text;
    }
//    if (remark.length <= 0) {
//        [NSObject showHudTipStr:@"请输入备注"];
//        return;
//    }
    
    NSTimeInterval start = [NSDate timestampFromDate:self.startDate] * 1000;
    NSTimeInterval end = [NSDate timestampFromDate:self.endDate] * 1000;
    if (start > end) {
        [NSObject showHudTipStr:@"结束时间必须晚于开始时间"];
        return;
    }
    
    [self beginLoading];
    
    AddScheduleModel * model = [[AddScheduleModel alloc] init];
    model.houseid = self.house.houseid;
    model.uid = self.house.uidcreater;
    model.schedulename = [NSString aliasedStringWithString:self.textTF.text];
    model.scheduletype = self.switchBtn.on;
    model.scheduleendtime = end;
    model.schedulestarttime = start;
    model.scheduletiptype = (int)self.remindTimeIndex;
    
    model.schedulearruidtip = self.remindPeopleUidStr;
    model.scheduleremark = [NSString aliasedStringWithString:remark];
    model.schedulecolor = self.selectColorStr;
    
    WEAKSELF
    NSString * path = nil;
    if (self.scheduleModel.scheduleM) {
        //编辑日程
        path = @"/api/inter/schedule/edit";
        model.scheduleid = self.scheduleModel.scheduleM.scheduleid;

    } else {
        //添加日程
        path = @"/api/inter/schedule/add";
    }
    [[TiHouse_NetAPIManager sharedManager] request_addScheduleSelect:model withPath:path Block:^(id data, NSError *error) {
        
        [weakSelf endLoading];
        
        if (data) {
            [NSObject showStatusBarSuccessStr:data];
            
            //退出该界面
            [weakSelf.scheduleModel.finishSubject sendNext:nil];
        }
    }];
}

/**
 * 开始时间点击事件
 */
- (IBAction)startViewTapAction:(UITapGestureRecognizer *)sender {
    self.startymdLabel.textColor = XWColorFromHex(0xFEC00C);
    self.starthmLabel.textColor = self.startymdLabel.textColor;
    self.endYmdLabel.textColor = XWColorFromHex(0x606060);
    self.endHmLabel.textColor = self.endYmdLabel.textColor;
    
    [self.textTF resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
    
    if (!self.isTapStart) {
        sender.view.tag = 0;
    }
    self.isTapStart = YES;
    
    if (sender.view.tag > 1) {
        sender.view.tag = 1;
    } else {
        sender.view.tag = 2;
    }
    
    if (!self.pikerDateView.isHidden && sender.view.tag == 1) {
        [self dismissPickerDateView];
    } else {
        [self showPickerDateView];
    }
}

/**
 * 结束时间点击事件
 */
- (IBAction)endTimeViewTapAction:(UITapGestureRecognizer *)sender {
    self.endYmdLabel.textColor = XWColorFromHex(0xFEC00C);
    self.endHmLabel.textColor = self.endYmdLabel.textColor;
    self.startymdLabel.textColor = XWColorFromHex(0x606060);
    self.starthmLabel.textColor = self.startymdLabel.textColor;
    
    [self.textTF resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
    
    if (self.isTapStart) {
        sender.view.tag = 0;
    }
    self.isTapStart = NO;
    
    if (sender.view.tag > 1) {
        sender.view.tag = 1;
    } else {
        sender.view.tag = 2;
    }
    
    if (!self.pikerDateView.isHidden && sender.view.tag == 1) {
        [self dismissPickerDateView];
    } else {
        [self showPickerDateView];
    }
}

/**
 * 时间选择器，选择结束调用方法
 */
- (IBAction)pickeDataSelectAction:(UIDatePicker *)sender {
    [self makeStartAndEndTime:sender.date];
}

/**
 * 展示时间选择器
 */
-(void)showPickerDateView {
    
    if (self.isTapStart) {
        self.datePicker.date = self.startDate;
    } else {
        self.datePicker.date = self.endDate;
    }
    
    [self.pikerDateView setHidden:NO];
    [self.pikerDateBottomLine setHidden:NO];
    [self.remindListView setOrigin:CGPointMake(self.remindListView.x, self.pikerDateBottomLine.bottom)];
    
    [self.remindListLine setOrigin:CGPointMake(self.remindListLine.x, self.remindListView.bottom)];
    [self.remindPeopleView setOrigin:CGPointMake(self.remindPeopleView.x, self.remindListLine.bottom)];
    
    [self.lineView setOrigin:CGPointMake(self.lineView.x, self.remindListView.bottom)];
    [self.scrollBottomView setSize:CGSizeMake(kScreen_Width, 149)];
    [self.scrollBottomView setOrigin:CGPointMake(self.scrollBottomView.x, self.lineView.bottom)];
    [self.remindBottomSubView setFrame: CGRectMake(0, 49, kScreen_Width, 76)];
    [self.remarkTextView setFrame:CGRectMake(self.remarkTextView.x, 0, kScreen_Width - 26, 76)];
    [self.scrollView setHeight:kScreen_Height - 64 - 80 - 50];
    [self.scrollSubView setHeight:self.scrollBottomView.bottom];
    [self.scrollView setContentSize:CGSizeMake(kScreen_Width, self.scrollSubView.y + self.scrollSubView.height)];
}

/**
 * 时间选择器消失
 */
-(void)dismissPickerDateView {
    [self.pikerDateView setHidden:YES];
    [self.pikerDateBottomLine setHidden:YES];
    [self.remindListView setOrigin:CGPointMake(self.remindListView.x, self.pikerDateView.top)];
    
    [self.remindListLine setOrigin:CGPointMake(self.remindListLine.x, self.remindListView.bottom)];
    [self.remindPeopleView setOrigin:CGPointMake(self.remindPeopleView.x, self.remindListLine.bottom)];
    
    [self.lineView setOrigin:CGPointMake(self.lineView.x, self.remindListView.bottom)];
    [self.scrollBottomView setSize:CGSizeMake(kScreen_Width, 149)];
    [self.scrollBottomView setOrigin:CGPointMake(self.scrollBottomView.x, self.lineView.bottom)];
    [self.remindBottomSubView setFrame:CGRectMake(0, 49, kScreen_Width, 76)];
    [self.remarkTextView setFrame:CGRectMake(self.remarkTextView.x, 0, kScreen_Width - 26, 76)];
    [self.scrollView setHeight:kScreen_Height - 64 - 80 - 50];
    [self.scrollSubView setHeight:self.scrollBottomView.bottom];
    [self.scrollView setContentSize:CGSizeMake(kScreen_Width, self.scrollSubView.y + self.scrollSubView.height)];
}

-(void)makeStartAndEndTime:(NSDate *)date {
    
    if (self.isTapStart) {
        self.startDate = date;
        self.startymdLabel.text = [self getYYYY_MM_DD:date];
        self.starthmLabel.text = [self getHH_mm:date];
        
        if (!self.isEditEndTime) {
            NSTimeInterval count = date.timeIntervalSinceNow + 3600;
            NSDate * newDate = [NSDate dateWithTimeIntervalSinceNow:count];
            self.endDate = newDate;
            self.endYmdLabel.text = [self getYYYY_MM_DD:newDate];
            self.endHmLabel.text = [self getHH_mm:newDate];
        }
        
    } else {
        self.isEditEndTime = YES;
        self.endDate = date;
        self.endYmdLabel.text = [self getYYYY_MM_DD:date];
        self.endHmLabel.text = [self getHH_mm:date];
    }
}

-(NSString *)getYYYY_MM_DD:(NSDate *)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString * reusltDate = [formatter stringFromDate:date];
    return reusltDate;
}

-(NSString *)getHH_mm:(NSDate *)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"a hh:mm"];
    NSString * reusltDate = [formatter stringFromDate:date];
    return reusltDate;
}

-(NSString *)getRemindTimeNameWithID:(int)type {
    NSArray * array = @[@"不提醒",@"事件开始时",@"提前五分钟",@"提前30分钟",@"提前1小时",@"提前1天",@"提前2天"];
    NSString * name = nil;
    if (type - 1 >= 0 && type - 1 < array.count) {
        name = array[type - 1];
    }
    
    return name;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请在此添加备注"]) {
        textView.text = nil;
    }
    
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    
    textView.textColor = [UIColor blackColor];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.pikerDateView.isHidden) {
        [self dismissPickerDateView];
    }
}

#pragma mark - get fun
-(SelectColorView *)selectColorView {
    if (!_selectColorView) {
        _selectColorView = [SelectColorView shareInstanceWithViewModel:nil];
        _selectColorView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        
        WEAKSELF;
        _selectColorView.SelectColorBlock = ^(NSString *colorValue) {
            weakSelf.selectColorStr = colorValue;
            _selectColorView = nil;
        };
        _selectColorView.DismissColorBlock = ^{
            _selectColorView = nil;
        };
    }
    return _selectColorView;
}

#pragma mark - set fun
-(void)setSelectColorStr:(NSString *)selectColorStr {
    
    _selectColorStr = selectColorStr;
    
    NSString * colorStr = [NSString stringWithFormat:@"0x%@",selectColorStr];
    unsigned long color = strtoul([colorStr UTF8String],0,16);
    [self.selectColorBtn setBackgroundColor:XWColorFromHex(color)];
}

@end
