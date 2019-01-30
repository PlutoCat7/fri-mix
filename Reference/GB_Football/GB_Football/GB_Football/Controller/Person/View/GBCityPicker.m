//
//  GBCityPicker.m
//  GB_Football
//
//  Created by Pizza on 16/8/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBCityPicker.h"
#import <pop/POP.h>

@interface GBCityPicker()
// 选择器控件
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
// 选择器的容器，用于后期layer层做动画
@property (weak, nonatomic) IBOutlet UIView *container;
// 背景层
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *areaStLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

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
@implementation GBCityPicker

-(void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)show:(NSInteger)provinceId cityId:(NSInteger)cityId areaId:(NSInteger)areaId {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    GBCityPicker *picker = [[NSBundle mainBundle]loadNibNamed:@"GBCityPicker" owner:self options:nil][0];
    picker.frame = [UIScreen mainScreen].bounds;
    picker.provinceId = provinceId;
    picker.cityId = cityId;
    picker.areaId = areaId;
    [picker loadData];
    [picker setupUI];
    [picker setupAnimation];
    [keywindow addSubview:picker];
    return picker;
}

+ (BOOL)hide
{
    GBCityPicker *hud = [GBCityPicker HUDForView:[UIApplication sharedApplication].keyWindow];
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

+ (GBCityPicker *)HUDForView: (UIView *)view {
    GBCityPicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBCityPicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBCityPicker *)aView;
        }
    }
    return hud;
}

- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+265.f/2);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-265.f/2+[self equalizeHeight]);
    [self.container.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished)
        {
            [self.container.layer pop_removeAnimationForKey:@"positionAnimation"];
        }};
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished){
            self.backView.alpha = 1.0f;
            [self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
        }};
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

-(void)setupUI{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.areaStLbl.text = LS(@"personal.hint.region");
    [self.cancelBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.saveBtn setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
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
    
    return 50.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = (UILabel *) view;
    if (nil == label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _pickerView.frame.size.width / 3, 50.0f)];
        [label setFont:[UIFont systemFontOfSize:22.0f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[ColorManager textColor]];
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
            self.provinceInfo = [LogicManager findAreaWithAreaList:self.provinceList areaID:self.provinceId];
            [self loadCityData];
            [_pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 1:
        {
            self.cityId = self.cityList[row].areaID;
            self.cityInfo = [LogicManager findAreaWithAreaList:self.cityList areaID:self.cityId];
            [self loadAreaData];
            [_pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
        }
            break;
        case 2:
        {
            self.areaId = self.areaList[row].areaID;
            self.areaInfo = [LogicManager findAreaWithAreaList:self.areaList areaID:self.areaId];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Action

- (IBAction)actionTapDissmiss:(id)sender {
    [GBCityPicker hide];
}

- (IBAction)actionCancel:(id)sender {
    [GBCityPicker hide];
}
- (IBAction)actionSave:(id)sender {
    [GBCityPicker hide];
    
    // 保存按钮
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAreaString:provinceId:cityId:areaId:)]) {
        NSString *area = [NSString stringWithFormat:@"%@  %@  %@", self.provinceInfo.areaName, self.cityInfo.areaName, self.areaInfo.areaName];
        [self.delegate didSelectAreaString:area provinceId:self.provinceId cityId:self.cityId areaId:self.areaId];
    }
}

#pragma mark - Private

- (void)loadData {
    
    [self loadProvince];
    [_pickerView selectRow:[self.provinceList indexOfObject:self.provinceInfo] inComponent:0 animated: NO];
    [_pickerView selectRow:[self.cityList indexOfObject:self.cityInfo] inComponent:1 animated: NO];
    [_pickerView selectRow:[self.areaList indexOfObject:self.areaInfo] inComponent:2 animated:NO];
    [_pickerView reloadAllComponents];
    [_pickerView setShowsSelectionIndicator:YES];
}

- (void)loadProvince {
    
    self.provinceList = [RawCacheManager sharedRawCacheManager].areaList;
    self.provinceInfo = [LogicManager findAreaWithAreaList:self.provinceList areaID:self.provinceId];
    if (!self.provinceInfo) {
        self.provinceInfo = self.provinceList.firstObject;
    }
    self.provinceId = self.provinceInfo.areaID;
    
    [self loadCityData];

}

- (void)loadCityData {
    
    self.cityList = self.provinceInfo.areaChidlArray;
    self.cityInfo = [LogicManager findAreaWithAreaList:self.cityList areaID:self.cityId];
    if (!self.cityInfo) {
        self.cityInfo = self.cityList.firstObject;
    }
    self.cityId = self.cityInfo.areaID;
    
    [self loadAreaData];
}

- (void)loadAreaData {

    self.areaList = self.cityInfo.areaChidlArray;
    self.areaInfo = [LogicManager findAreaWithAreaList:self.areaList areaID:self.areaId];
    if (!self.areaInfo) {
        self.areaInfo = self.areaList.firstObject;
    }
    self.areaId = self.areaInfo.areaID;
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
