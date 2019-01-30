//
//  GBPersonDetailViewController.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/7/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPersonDetailViewController.h"
#import "GBPesonNameViewController.h"
#import "GBPersonPositionSetting.h"
#import "AKPickerView.h"
#import "GBHightLightButton.h"
#import "GBPositionLabel.h"
#import "UserRequest.h"
#import "GBCircleHub.h"

#define kWieghtStart 15
#define kHeightStart 50
#define kAgeStart 3
#define kNumberStart 1

@interface GBPersonDetailViewController ()<AKPickerViewDataSource,AKPickerViewDelegate>

// 体重选择器
@property (weak, nonatomic) IBOutlet AKPickerView *widthPicker;
// 身高选择器
@property (weak, nonatomic) IBOutlet AKPickerView *heightPicker;
// 球衣号码选择器
@property (weak, nonatomic) IBOutlet AKPickerView *numberPicker;
// 场上位置
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
// ok按钮
@property (weak, nonatomic) IBOutlet GBHightLightButton *okButton;
// 选择场上位置图标
@property (weak, nonatomic) IBOutlet GBPositionLabel *posIcon1;

@property (weak, nonatomic) IBOutlet UILabel *weightStLbl;
@property (weak, nonatomic) IBOutlet UILabel *heightStLbl;
@property (weak, nonatomic) IBOutlet UILabel *numberStLbl;
@property (weak, nonatomic) IBOutlet UILabel *positionStLbl;

@property (weak, nonatomic) IBOutlet UILabel *hintLbl;
// 数据源
@property (nonatomic, strong) NSArray<NSNumber *> *weightList;
@property (nonatomic, strong) NSArray<NSNumber *> *heightList;
@property (nonatomic, strong) NSArray<NSNumber *> *numberList;

@property (nonatomic, strong) UserInfo *userInfo;

@end

@implementation GBPersonDetailViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
}

- (void)localizeUI {
    self.weightStLbl.text = LS(@"player.label.weight");
    self.heightStLbl.text = LS(@"player.label.height");
    self.numberStLbl.text = LS(@"player.label.number");
    self.positionStLbl.text = LS(@"player.label.position");
    self.hintLbl.text = LS(@"player.hint.setting.weightheight");
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Notification

#pragma mark - Delegate
#pragma mark  AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item {
    
    if (pickerView == self.widthPicker) {
        self.userInfo.weight = self.weightList[item].floatValue;
    }else if (pickerView == self.heightPicker) {
        self.userInfo.height = self.heightList[item].floatValue;
    }else if (pickerView == self.numberPicker) {
        self.userInfo.teamNo = self.numberList[item].floatValue;
    }
}

// 适配微调
- (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
{
    if (IS_IPHONE6) {
        if ([self.heightPicker isEqual:pickerView]) {
            return CGSizeMake(0,0);
        }
        else if([self.numberPicker isEqual:pickerView]){
            return CGSizeMake(6,6);
        }
        else
        {
            return CGSizeMake(3,3);
        }
    }
    else if(IS_IPHONE6P)
    {
        if ([self.heightPicker isEqual:pickerView]) {
            return CGSizeMake(0,0);
        }
        else if([self.numberPicker isEqual:pickerView]){
            return CGSizeMake(8,8);
        }
        else
        {
            return CGSizeMake(3,3);
        }
    }
    else if(IS_IPHONE5)
    {
        pickerView.font = [UIFont fontWithName:pickerView.font.fontName size:23];
        pickerView.highlightedFont = [UIFont fontWithName:pickerView.font.fontName size:23];
        if ([self.heightPicker isEqual:pickerView]) {
            return CGSizeMake(0,0);
        }
        else if([self.numberPicker isEqual:pickerView]){
            return CGSizeMake(6,6);
        }
        else
        {
            return CGSizeMake(0,0);
        }
    }
    return CGSizeMake(3,3);
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    if (pickerView == self.widthPicker) {
        return self.weightList.count;
    }else if (pickerView == self.heightPicker) {
        return self.heightList.count;
    }else if (pickerView == self.numberPicker) {
        return self.numberList.count;
    }
    return 0;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    if (pickerView == self.widthPicker) {
        return self.weightList[item].stringValue;
    }else if (pickerView == self.heightPicker) {
        return self.heightList[item].stringValue;
    }else if (pickerView == self.numberPicker) {
        return self.numberList[item].stringValue;
    }
    return @"";
}

#pragma mark - Action

// 点击场上位置
- (IBAction)actionSelecPosition:(id)sender {
    
    NSArray *positionList = @[];
    if (![NSString stringIsNullOrEmpty:self.userInfo.position]) {
        positionList = [self.userInfo.position componentsSeparatedByString:@","];
    }
    NSMutableArray *selectList = [NSMutableArray arrayWithCapacity:1];
    if (positionList.count > 0) {
        [selectList addObject:[positionList firstObject]];
    }
    
    GBPersonPositionSetting *nameViewController = [[GBPersonPositionSetting alloc] initWithSelectList:selectList];
    nameViewController.saveBlock = ^(NSArray<NSString *>* selectIndexList){
        
        [self setPositin:selectIndexList];
        
        NSString *position = [NSString stringWithFormat:@"%@,%@", selectIndexList.firstObject, selectIndexList.lastObject];
        self.userInfo.position = position;
        [self checkInputValid];
    };
    [self.navigationController pushViewController:nameViewController animated:YES];
}
// 点击OK按钮
- (IBAction)actionPressOk:(id)sender {
    
    [self showLoadingToast];
    @weakify(self)
    [UserRequest updateUserInfo:self.userInfo handler:^(id result, NSError *error) {
        
        @strongify(self)
        [self dismissToast];
        if (!error) {
            if (self.isNeedNext) {
                [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"player.hint.setting.success")];
                [RawCacheManager sharedRawCacheManager].userInfo = self.userInfo;
                [self performBlock:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowMainView object:nil];
                } delay:1.0f];
            }else {
                [[UIApplication sharedApplication].keyWindow showToastWithText:LS(@"player.hint.setting.success")];
                [RawCacheManager sharedRawCacheManager].userInfo = self.userInfo;
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else {
            [self showToastWithText:error.domain];
        }
    }];
}

#pragma mark - Private

-(void)setupUI
{
    self.title = LS(@"player.nav.title");
    [self setupBackButtonWithBlock:nil];
    [self setupPickers];
}

-(void)loadData
{
    self.userInfo = [[RawCacheManager sharedRawCacheManager].userInfo copy];
    self.weightList = [self numberListWithMax:125 min:15];
    self.heightList = [self numberListWithMax:250 min:50];
    self.numberList = [self numberListWithMax:99 min:1];
    
    if (![NSString stringIsNullOrEmpty:self.userInfo.position]) {
        [self setPositin:[self.userInfo.position componentsSeparatedByString:@","]];
    }
    
    [self checkInputValid];
}

-(void)setupPickers
{
    self.heightPicker.delegate = self;
    self.heightPicker.dataSource = self;
    
    self.widthPicker.delegate = self;
    self.widthPicker.dataSource = self;
    
    self.numberPicker.delegate = self;
    self.numberPicker.dataSource = self;
    
    NSInteger weight = self.userInfo.weight - kWieghtStart;
    if (weight < 0) {
        weight = 65 - kWieghtStart;
    }else if(weight>=self.weightList.count){
        weight = self.weightList.count-1;
    }
    [self.widthPicker selectItem:weight animated:YES];
    
    NSInteger height = self.userInfo.height - kHeightStart;
    if (height < 0) {
        height = 175 - kHeightStart;
    }else if (height>=self.heightList.count){
        height = self.heightList.count-1;
    }
    [self.heightPicker selectItem:height animated:YES];
    
    NSInteger teamNo = self.userInfo.teamNo - kNumberStart;
    if (teamNo < 0) {
        teamNo = 10 - kNumberStart;
    }else if (teamNo>=self.numberList.count) {
        teamNo = self.numberList.count-1;
    }
    [self.numberPicker selectItem:teamNo animated:YES];
}

- (void)checkInputValid {
    
    self.okButton.enabled = self.userInfo.position.length > 0;
}

- (NSArray *)numberListWithMax:(NSInteger)max min:(NSInteger)min {
    
    NSMutableArray *weightList = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index=min; index<=max; index++) {
        [weightList addObject:@(index)];
    }
    return [weightList copy];
}
- (void)setPositin:(NSArray<NSString*> *)positionList {
    
    if (positionList.count == 0) {
        return;
    }
    self.posIcon1.hidden = NO;
    self.posIcon1.index = positionList.firstObject.integerValue;
    
    self.positionLabel.hidden = YES;
}

#pragma mark - Getters & Setters

@end
