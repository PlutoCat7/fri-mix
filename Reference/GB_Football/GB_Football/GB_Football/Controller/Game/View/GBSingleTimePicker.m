//
//  GBSingleTimePicker.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBSingleTimePicker.h"
#import "GBVerticalPicker.h"
#import <pop/POP.h>

@interface GBSingleTimePicker ()<
GBVerticalViewDelegate,
GBVerticalViewDataSource>

@property (weak, nonatomic) IBOutlet GBVerticalPicker *startHourPick;
@property (weak, nonatomic) IBOutlet GBVerticalPicker *startMinPick;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *container;

// 静态翻译标签
@property (weak, nonatomic) IBOutlet UILabel *titleStLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelStButton;
@property (weak, nonatomic) IBOutlet UIButton *saveStButton;

// 默认选择项
@property (assign, nonatomic) NSInteger startHSelectIndex;
@property (assign, nonatomic) NSInteger startMSelectIndex;

@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minArray;

@end

@implementation GBSingleTimePicker

+ (instancetype)showWithSelectIndex:(NSInteger)startHour startMin:(NSInteger)startMin {
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBSingleTimePicker" owner:self options:nil];
    for (UIView *view in viewArray) {
        if ([view isKindOfClass:[GBSingleTimePicker class]]) {
            GBSingleTimePicker *picker = (GBSingleTimePicker *) view;
            picker.frame = [UIScreen mainScreen].bounds;
            picker.startHSelectIndex = startHour;
            picker.startMSelectIndex = startMin;
            picker.startHourPick.selectedRow = startHour;
            picker.startMinPick.selectedRow = startMin;
            [keywindow addSubview:picker];
            
            return picker;
        }
    }
    
    return nil;
}

+ (BOOL)hide
{
    GBSingleTimePicker *hud = [GBSingleTimePicker HUDForView:[UIApplication sharedApplication].keyWindow];
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

+ (GBSingleTimePicker *)HUDForView: (UIView *)view {
    GBSingleTimePicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBSingleTimePicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBSingleTimePicker *)aView;
        }
    }
    return hud;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self loadData];
    [self setupUI];
    [self localizeUI];
    [self setupAnimation];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.container.bottom = self.height;
}

- (void)localizeUI{
    
    self.titleStLabel.text = LS(@"post.picker.time.title");
    [self.cancelStButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.saveStButton setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
}

-(void)loadData
{
    self.startHourPick.dataSource = self;
    self.startHourPick.delegate = self;
    self.startHourPick.selectedRow = self.startHSelectIndex;
    self.startHourPick.rowHeight = 40;
    self.startHourPick.selectedRowFont = [UIFont fontWithName:@"BEBAS" size:30];
    self.startHourPick.backgroundColor = [UIColor clearColor];
    self.startHourPick.textColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.startHourPick.unselectedRowScale = 0.5;
    
    self.startMinPick.dataSource = self;
    self.startMinPick.delegate = self;
    self.startMinPick.selectedRow = self.startMSelectIndex;
    self.startMinPick.rowHeight = 40;
    self.startMinPick.selectedRowFont = [UIFont fontWithName:@"BEBAS" size:30];
    self.startMinPick.backgroundColor = [UIColor clearColor];
    self.startMinPick.textColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.startMinPick.unselectedRowScale = 0.5;
    
    self.hourArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 24; i++) {
        NSString *s = [NSString stringWithFormat:@"%d",(int)i];
        [self.hourArray addObject:s];
    }
    
    self.minArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 60; i++) {
        NSString *s = [NSString stringWithFormat:@"%d",(int)i];
        [self.minArray addObject:s];
    }
}

- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+312.f/2);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-312.f/2);
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

- (void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (IBAction)actionTapDismiss:(id)sender {
    [GBSingleTimePicker hide];
}

- (IBAction)actionCancel:(id)sender {
    [GBSingleTimePicker hide];
}

- (IBAction)actionSave:(id)sender {
    [GBSingleTimePicker hide];
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(GBSingleTimePicker:startHour:startMin:)]) {
        [self.delegate GBSingleTimePicker:self startHour:self.startHSelectIndex startMin:self.startMSelectIndex];
    }
}

- (void)pickerView:(GBVerticalPicker *)pickerView changedIndex:(NSUInteger)indexPath {
    if (pickerView == self.startHourPick) {
        self.startHSelectIndex = indexPath;
        
    } else if(pickerView == self.startMinPick) {
        self.startMSelectIndex = indexPath;
        
    }
}

- (NSInteger)pickerView:(GBVerticalPicker *)pickerView {
    if (pickerView == self.startHourPick) {
        return self.hourArray.count;
        
    } else if(pickerView == self.startMinPick) {
        return self.minArray.count;
        
    }
    return 0;
}

- (NSString *)pickerView:(GBVerticalPicker *)pickerView titleForRow:(NSUInteger)indexPath {
    if (pickerView == self.startHourPick) {
        return self.hourArray[indexPath];
        
    } else if(pickerView == self.startMinPick) {
        return self.minArray[indexPath];
        
    }
    
    return nil;
}

-(void)dealloc
{
    [self.backView.layer pop_removeAllAnimations];
    [self.container.layer pop_removeAllAnimations];
}

@end
