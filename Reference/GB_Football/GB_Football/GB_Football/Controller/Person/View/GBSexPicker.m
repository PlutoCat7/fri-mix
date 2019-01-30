//
//  GBSexPicker.m
//  GB_Football
//
//  Created by Pizza on 16/8/4.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBSexPicker.h"
#import <pop/POP.h>

@interface GBSexPicker()
// 选择器控件
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
// 选择器的容器，用于后期layer层做动画
@property (weak, nonatomic) IBOutlet UIView *container;
// 背景图
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *sexStLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (assign, nonatomic) NSInteger selectSex;
@property (nonatomic, strong) NSArray *genderList;

@end
@implementation GBSexPicker

+ (instancetype)showWithIndex:(NSInteger)index {
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    GBSexPicker *picker = [[NSBundle mainBundle]loadNibNamed:@"GBSexPicker" owner:self options:nil][0];
    picker.frame = [UIScreen mainScreen].bounds;
    picker.selectSex = index;
    [keywindow addSubview:picker];
    return picker;
}

+ (BOOL)hide
{
    GBSexPicker *hud = [GBSexPicker HUDForView:[UIApplication sharedApplication].keyWindow];
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
            [hud.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];};
        [hud.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        
        return YES;
    }
    return NO;
}

+ (GBSexPicker *)HUDForView: (UIView *)view {
    GBSexPicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBSexPicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBSexPicker *)aView;
        }
    }
    return hud;
}


#pragma mark - Action
- (IBAction)actionTapDismiss:(id)sender {
    [GBSexPicker hide];
}

- (IBAction)actionCancel:(id)sender {
    [GBSexPicker hide];
}

- (IBAction)actionSave:(id)sender {
    
    [GBSexPicker hide];
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(didSelectSexIndex:)])
    {
        [self.delegate didSelectSexIndex:self.selectSex];
    }
}

#pragma mark - Picker Delegate &&s Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.genderList.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 75.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = (UILabel *) view;
    if (nil == label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _pickerView.frame.size.width / 3, 50.0f)];
    }
    [label setFont:[UIFont systemFontOfSize:22.0f]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[ColorManager textColor]];

    [label setText:self.genderList[row]];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _selectSex = row;
}

#pragma mark - Private 

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadData];
    [self setupUI];
    [self setupAnimation];
}

-(void)loadData
{
    self.genderList = @[LS(@"personal.label.male"), LS(@"personal.label.female")];
    [_pickerView reloadAllComponents];
    [_pickerView setShowsSelectionIndicator:YES];
}

- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+265.f/2 );
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-265.f/2+[self equalizeHeight]);
    [self.container.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self.container.layer pop_removeAnimationForKey:@"positionAnimation"];};
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished){
        self.backView.alpha = 1.0f;
        [self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
    }};
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.sexStLbl.text = LS(@"personal.hint.gender");
    [self.cancelBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.saveBtn setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
}

#pragma mark - Getter and Setter

- (void)setSelectSex:(NSInteger)selectSex {
    
    _selectSex = selectSex;
    [_pickerView selectRow:self.selectSex inComponent:0 animated:NO];
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
    [self.backView.layer pop_removeAllAnimations];
    [self.container.layer pop_removeAllAnimations];
}

@end
