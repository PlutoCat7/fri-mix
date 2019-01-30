//
//  GBStepPicker.m
//  GB_Football
//
//  Created by weilai on 16/8/25.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBStepPicker.h"
#import "GBVerticalPicker.h"
#import <pop/POP.h>

@interface GBStepPicker() <GBVerticalViewDelegate, GBVerticalViewDataSource>
@property (weak, nonatomic) IBOutlet GBVerticalPicker *stepPick;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *stepSetStLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

// 默认选择项
@property (assign, nonatomic) NSInteger stepSelect;

@property (nonatomic, strong) NSMutableArray *stepArray;

@property (nonatomic, copy) void(^completeBlock)(NSInteger step);

@end

@implementation GBStepPicker


+ (instancetype)showWithSelectStep:(NSInteger)step complete:(void(^)(NSInteger step))complete {
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBStepPicker" owner:self options:nil];
    for (UIView *view in viewArray) {
        if ([view isKindOfClass:[GBStepPicker class]]) {
            GBStepPicker *picker = (GBStepPicker *) view;
            picker.frame = [UIScreen mainScreen].bounds;
            picker.stepSelect = step;
            picker.stepPick.selectedRow = step / 1000 - 1;
            picker.completeBlock = complete;
            [keywindow addSubview:picker];
            
            return picker;
        }
    }
    
    return nil;
}

+ (BOOL)hide
{
    GBStepPicker *hud = [GBStepPicker HUDForView:[UIApplication sharedApplication].keyWindow];
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

+ (GBStepPicker *)HUDForView: (UIView *)view {
    GBStepPicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBStepPicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBStepPicker *)aView;
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

-(void)loadData
{
    self.stepPick.dataSource = self;
    self.stepPick.delegate = self;
    self.stepPick.selectedRow = self.stepSelect / 1000;
    self.stepPick.rowHeight = 40;
    self.stepPick.selectedRowFont = [UIFont fontWithName:@"BEBAS" size:30];
    self.stepPick.backgroundColor = [UIColor clearColor];
    self.stepPick.textColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.stepPick.unselectedRowScale = 0.5;

    
    self.stepArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 50; i++) {
        NSString *s = [NSString stringWithFormat:@"%d",(int)((i + 1) * 1000)];
        [self.stepArray addObject:s];
    }
    
}

- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+304.f/2);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-304.f/2+[self equalizeHeight]);
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
    
    self.stepSetStLbl.text = LS(@"setting.label.goal.step");
    [self.cancelBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.saveBtn setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
}

- (IBAction)actionTapDismiss:(id)sender {
    [GBStepPicker hide];
}

- (IBAction)actionCancel:(id)sender {
    [GBStepPicker hide];
}

- (IBAction)actionSave:(id)sender {
    [GBStepPicker hide];
    BLOCK_EXEC_SetNil(self.completeBlock, self.stepSelect);
}

- (void)pickerView:(GBVerticalPicker *)pickerView changedIndex:(NSUInteger)indexPath {
    if (pickerView == self.stepPick) {
        self.stepSelect = (indexPath + 1) * 1000;
        
    }
}

- (NSInteger)pickerView:(GBVerticalPicker *)pickerView {
    if (pickerView == self.stepPick) {
        return self.stepArray.count;
        
    }
    return 0;
}

- (NSString *)pickerView:(GBVerticalPicker *)pickerView titleForRow:(NSUInteger)indexPath {
    if (pickerView == self.stepPick) {
        return self.stepArray[indexPath];
        
    }
    
    return nil;
}


// 用于微调位置，机型适配
-(CGFloat)equalizeHeight
{
    if (IS_IPHONE4) {
        return 30;
    }
    else if(IS_IPHONE5){
        return 30;
    }
    else if(IS_IPHONE6){
        return 0;
    }
    else if(IS_IPHONE6P){
        return 0;
    }
    return 0;
}

-(void)dealloc
{
    [self.backView.layer pop_removeAllAnimations];
    [self.container.layer pop_removeAllAnimations];
}

@end
