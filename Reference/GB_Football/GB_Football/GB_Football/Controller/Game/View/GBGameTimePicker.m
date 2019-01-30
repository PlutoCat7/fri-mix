//
//  GBGameTimePicker.m
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGameTimePicker.h"
#import "GBVerticalPicker.h"
#import <pop/POP.h>

@interface GBGameTimePicker() <GBVerticalViewDelegate, GBVerticalViewDataSource>
@property (weak, nonatomic) IBOutlet GBVerticalPicker *startHourPick;
@property (weak, nonatomic) IBOutlet GBVerticalPicker *startMinPick;
@property (weak, nonatomic) IBOutlet GBVerticalPicker *endHourPick;
@property (weak, nonatomic) IBOutlet GBVerticalPicker *endMinPick;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *container;

// 默认选择项
@property (assign, nonatomic) NSInteger startHSelectIndex;
@property (assign, nonatomic) NSInteger startMSelectIndex;
@property (assign, nonatomic) NSInteger endHSelectIndex;
@property (assign, nonatomic) NSInteger endMSelectIndex;

@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minArray;
// 静态翻译标签
@property (weak, nonatomic) IBOutlet UILabel *beginStLabel;
@property (weak, nonatomic) IBOutlet UILabel *endStLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleStLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelStButton;
@property (weak, nonatomic) IBOutlet UIButton *saveStButton;

@end

@implementation GBGameTimePicker

+ (instancetype)showWithSelectIndex:(NSInteger)startHour startMin:(NSInteger)startMin endHour:(NSInteger)endHour endMin:(NSInteger)endMin {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBGameTimePicker" owner:self options:nil];
    for (UIView *view in viewArray) {
        if ([view isKindOfClass:[GBGameTimePicker class]]) {
            GBGameTimePicker *picker = (GBGameTimePicker *) view;
            picker.frame = [UIScreen mainScreen].bounds;
            picker.startHSelectIndex = startHour;
            picker.startMSelectIndex = startMin;
            picker.endHSelectIndex = endHour;
            picker.endMSelectIndex = endMin;
            picker.startHourPick.selectedRow = startHour;
            picker.startMinPick.selectedRow = startMin;
            picker.endHourPick.selectedRow = endHour;
            picker.endMinPick.selectedRow = endMin;
            [keywindow addSubview:picker];
            
            return picker;
        }
    }
    
    return nil;
}

+ (BOOL)hide
{
    GBGameTimePicker *hud = [GBGameTimePicker HUDForView:[UIApplication sharedApplication].keyWindow];
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

+ (GBGameTimePicker *)HUDForView: (UIView *)view {
    GBGameTimePicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBGameTimePicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBGameTimePicker *)aView;
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

- (void)localizeUI{
    self.beginStLabel.text = LS(@"post.picker.begin.time");
    self.endStLabel.text = LS(@"post.picker.finish.time");
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
    
    self.endHourPick.dataSource = self;
    self.endHourPick.delegate = self;
    self.endHourPick.selectedRow = self.startHSelectIndex;
    self.endHourPick.rowHeight = 40;
    self.endHourPick.selectedRowFont = [UIFont fontWithName:@"BEBAS" size:30];
    self.endHourPick.backgroundColor = [UIColor clearColor];
    self.endHourPick.textColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.endHourPick.unselectedRowScale = 0.5;
    
    self.endMinPick.dataSource = self;
    self.endMinPick.delegate = self;
    self.endMinPick.selectedRow = self.startMSelectIndex;
    self.endMinPick.rowHeight = 40;
    self.endMinPick.selectedRowFont = [UIFont fontWithName:@"BEBAS" size:30];
    self.endMinPick.backgroundColor = [UIColor clearColor];
    self.endMinPick.textColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.endMinPick.unselectedRowScale = 0.5;
    
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
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+347.f/2);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-347.f/2);
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
    [GBGameTimePicker hide];
}

- (IBAction)actionCancel:(id)sender {
    [GBGameTimePicker hide];
}

- (IBAction)actionSave:(id)sender {
    [GBGameTimePicker hide];
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(GBGameTimePicker:startHour:startMin:endHour:endMin:)]) {
        [self.delegate GBGameTimePicker:self startHour:self.startHSelectIndex startMin:self.startMSelectIndex endHour:self.endHSelectIndex endMin:self.endMSelectIndex];
    }
}

- (void)pickerView:(GBVerticalPicker *)pickerView changedIndex:(NSUInteger)indexPath {
    if (pickerView == self.startHourPick) {
        self.startHSelectIndex = indexPath;
        
    } else if(pickerView == self.startMinPick) {
        self.startMSelectIndex = indexPath;
        
    } else if (pickerView == self.endHourPick) {
        self.endHSelectIndex = indexPath;
        
    } else if (pickerView == self.endMinPick) {
        self.endMSelectIndex = indexPath;
        
    }
}

- (NSInteger)pickerView:(GBVerticalPicker *)pickerView {
    if (pickerView == self.startHourPick) {
        return self.hourArray.count;
        
    } else if(pickerView == self.startMinPick) {
        return self.minArray.count;
        
    } else if (pickerView == self.endHourPick) {
        return self.hourArray.count;
        
    } else if (pickerView == self.endMinPick) {
        return self.minArray.count;
        
    }
    return 0;
}

- (NSString *)pickerView:(GBVerticalPicker *)pickerView titleForRow:(NSUInteger)indexPath {
    if (pickerView == self.startHourPick) {
        return self.hourArray[indexPath];
        
    } else if(pickerView == self.startMinPick) {
        return self.minArray[indexPath];
        
    } else if (pickerView == self.endHourPick) {
        return self.hourArray[indexPath];
        
    } else if (pickerView == self.endMinPick) {
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
