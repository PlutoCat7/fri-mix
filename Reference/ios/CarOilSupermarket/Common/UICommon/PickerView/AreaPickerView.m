//
//  AreaPickerView.m
//  CarOilSupermarket
//
//  Created by yahua on 2017/9/6.
//  Copyright © 2017年 yahua. All rights reserved.
//

#import "AreaPickerView.h"

@interface AreaPickerView () <UIPickerViewDelegate,
UIPickerViewDataSource>

// 背景层
@property (weak, nonatomic) IBOutlet UIView *backView;
// 选择器的容器，用于后期layer层做动画
@property (weak, nonatomic) IBOutlet UIView *container;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) void(^resultBlock)(NSString *province, NSString *city, NSString *area);
@property (nonatomic, strong) NSArray<AreaInfo *> *provinceList;
@property (nonatomic, strong) NSArray<AreaInfo *>  *cityList;
@property (nonatomic, strong) NSArray<AreaInfo *>  *areaList;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, strong) AreaInfo *provinceInfo;
@property (nonatomic, strong) AreaInfo *cityInfo;
@property (nonatomic, strong) AreaInfo *areaInfo;

@end

@implementation AreaPickerView

+ (instancetype)showWithHandler:(void(^)(NSString *province, NSString *city, NSString *area))handler {
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    AreaPickerView *picker = [[NSBundle mainBundle]loadNibNamed:@"AreaPickerView" owner:self options:nil][0];
    picker.frame = [UIScreen mainScreen].bounds;
    picker.resultBlock = handler;
    [picker loadData];
    [picker setupAnimation];
    [keywindow addSubview:picker];
    return picker;
}

+ (void)hide
{
    AreaPickerView *hud = [AreaPickerView HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)
    {
        [UIView animateWithDuration:0.25f animations:^{
            hud.container.top = hud.height;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
        }];
    }
}

+ (AreaPickerView *)HUDForView: (UIView *)view {
    AreaPickerView *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [AreaPickerView class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (AreaPickerView *)aView;
        }
    }
    return hud;
}

- (void)setupAnimation{
    
    self.container.top = self.height;
    [UIView animateWithDuration:0.25f animations:^{
        self.container.bottom = self.height;
    }];
}

#pragma mark - Action

- (IBAction)actionTapDissmiss:(id)sender {
    [AreaPickerView hide];
}

- (IBAction)actionCancel:(id)sender {
    [AreaPickerView hide];
}
- (IBAction)actionSave:(id)sender {
    [AreaPickerView hide];
    
    NSString *province = self.provinceInfo.areaName;
    if (!province) {
        province = @"";
    }
    NSString *city = self.cityInfo.areaName;
    if (!city) {
        city = @"";
    }
    NSString *area = self.areaInfo.areaName;
    if (!area) {
        area = @"";
    }
    BLOCK_EXEC(self.resultBlock, province, city, area);
}

#pragma mark - Private

- (void)loadData {
    
    [self loadProvince];
//    [_pickerView selectRow:[self.provinceList indexOfObject:self.provinceInfo] inComponent:0 animated: NO];
//    [_pickerView selectRow:[self.cityList indexOfObject:self.cityInfo] inComponent:1 animated: NO];
//    [_pickerView selectRow:[self.areaList indexOfObject:self.areaInfo] inComponent:2 animated:NO];
//    [_pickerView reloadAllComponents];
//    [_pickerView setShowsSelectionIndicator:YES];
}

- (void)loadProvince {
    
    self.provinceList = [RawCacheManager sharedRawCacheManager].areaList;
    self.provinceInfo = self.provinceList.firstObject;
    if (!self.provinceInfo) {
        self.provinceInfo = self.provinceList.firstObject;
    }
    self.provinceId = self.provinceInfo.areaID;
    
    [self loadCityData];
    
}

- (void)loadCityData {
    
    self.cityList = self.provinceInfo.areaChidlArray;
    self.cityInfo = self.cityList.firstObject;
    if (!self.cityInfo) {
        self.cityInfo = self.cityList.firstObject;
    }
    self.cityId = self.cityInfo.areaID;
    
    [self loadAreaData];
}

- (void)loadAreaData {
    
    self.areaList = self.cityInfo.areaChidlArray;
    self.areaInfo = self.areaList.firstObject;
    if (!self.areaInfo) {
        self.areaInfo = self.areaList.firstObject;
    }
    self.areaId = self.areaInfo.areaID;
}

#pragma mark - Picker Delegate &&s Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    // 0省 1 市 2 区 的个数
    switch (component)
    {
        case 0:
        {
            return self.provinceList.count;
        }
            break;
        case 1:
        {
            return self.cityList.count;
        }
            break;
        case 2:
        {
            return self.areaList.count;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 50.0f*kAppScale;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    for(UIView *speartorView in pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    UILabel *label = (UILabel *) view;
    if (nil == label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _pickerView.frame.size.width / 3, 50.0f)];
        [label setFont:[UIFont systemFontOfSize:16.0f*kAppScale]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        label.adjustsFontSizeToFitWidth = YES;
    }
    
    NSString *title = @"";
    
    switch (component)
    {
        case 0:
        {
            title = self.provinceList[row].areaName;
        }
            break;
        case 1:
        {
            title = self.cityList[row].areaName;
        }
            break;
        case 2:
        {
            title = self.areaList[row].areaName;
        }
            break;
        default:
            break;
    }
    
    
    [label setText:title];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component)
    {
        case 0:
        {
            self.provinceId = self.provinceList[row].areaID;
            self.provinceInfo = self.provinceList[row];
            [self loadCityData];
            [_pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 1:
        {
            self.cityId = self.cityList[row].areaID;
            self.cityInfo = self.cityList[row];
            [self loadAreaData];
            [_pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 2:
        {
            self.areaId = self.areaList[row].areaID;
            self.areaInfo = self.areaList[row];
        }
            break;
        default:
            break;
    }
}

@end
