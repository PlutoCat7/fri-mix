//
//  GBGameScorePicker.m
//  GB_Football
//
//  Created by Pizza on 16/8/22.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBGameScorePicker.h"
#import "GBVerticalPicker.h"
#import <pop/POP.h>

@interface GBGameScorePicker() <GBVerticalViewDelegate, GBVerticalViewDataSource>
@property (weak, nonatomic) IBOutlet GBVerticalPicker *ourPickerView;
@property (weak, nonatomic) IBOutlet GBVerticalPicker *oppPickerView;
@property (nonatomic, strong) NSMutableArray *scoreArray;
// 选择器的容器，用于后期layer层做动画
@property (weak, nonatomic) IBOutlet UIView *container;
// 背景图
@property (weak, nonatomic) IBOutlet UIView *backView;
// 默认选择项
@property (assign, nonatomic) NSInteger ourSelectIndex;
@property (assign, nonatomic) NSInteger oppSelectIndex;
// 我方进球数量
@property (assign, nonatomic) NSInteger ourGoal;
// 对方进球数量
@property (assign, nonatomic) NSInteger oppGoal;
// 静态翻译标签
@property (weak, nonatomic) IBOutlet UILabel *ourStLabel;
@property (weak, nonatomic) IBOutlet UILabel *oppStLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleStLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelStButton;
@property (weak, nonatomic) IBOutlet UIButton *saveStButton;

@end

@implementation GBGameScorePicker


-(void)awakeFromNib {
    [super awakeFromNib];
    [self loadData];
    [self setupUI];
    [self localizeUI];
    [self setupAnimation];
}

- (void)localizeUI{
    self.ourStLabel.text = LS(@"post.picker.score.our");
    self.oppStLabel.text = LS(@"post.picker.score.opp");
    self.titleStLabel.text = LS(@"post.picker.score.title");
    [self.cancelStButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.saveStButton setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
}
- (void)pickerView:(GBVerticalPicker *)pickerView changedIndex:(NSUInteger)indexPath
{
    if (pickerView == self.ourPickerView)
    {
        self.ourGoal = indexPath;
    }
    else if(pickerView == self.oppPickerView)
    {
        self.oppGoal = indexPath;
    }
}

- (NSInteger)pickerView:(GBVerticalPicker *)pickerView
{
    return self.scoreArray .count;
}

- (NSString *)pickerView:(GBVerticalPicker *)pickerView titleForRow:(NSUInteger)indexPath
{
    return self.scoreArray [indexPath];
}

+ (instancetype)showWithOurSelectIndex:(NSInteger)ourSelectIndex oppSelectIndex:(NSInteger)oppSelectIndex
{
    
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBGameScorePicker" owner:self options:nil];
    for (UIView *view in viewArray) {
        if ([view isKindOfClass:[GBGameScorePicker class]]) {
            GBGameScorePicker *picker = (GBGameScorePicker *) view;
            picker.frame = [UIScreen mainScreen].bounds;
            picker.ourSelectIndex = ourSelectIndex;
            picker.oppSelectIndex = oppSelectIndex;
            picker.ourPickerView.selectedRow = ourSelectIndex;
            picker.oppPickerView.selectedRow = oppSelectIndex;
            [keywindow addSubview:picker];
            
            return picker;
        }
    }
    
    return nil;
}

+ (BOOL)hide
{
    GBGameScorePicker *hud = [GBGameScorePicker HUDForView:[UIApplication sharedApplication].keyWindow];
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
                [hud.backView.layer pop_removeAnimationForKey:@"positionAnimation"];
            }};
        [hud.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        
        return YES;
    }
    return NO;
}

+ (GBGameScorePicker *)HUDForView: (UIView *)view {
    GBGameScorePicker *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBGameScorePicker class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBGameScorePicker *)aView;
        }
    }
    return hud;
}

-(void)loadData
{
    self.ourPickerView.dataSource = self;
    self.ourPickerView.delegate = self;
    self.ourPickerView.selectedRow = self.ourSelectIndex;
    self.ourPickerView.rowHeight = 40;
    self.ourPickerView.selectedRowFont = [UIFont fontWithName:@"BEBAS" size:30];
    self.ourPickerView.backgroundColor = [UIColor clearColor];
    self.ourPickerView.textColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.ourPickerView.unselectedRowScale = 0.5;
    
    
    self.oppPickerView.dataSource = self;
    self.oppPickerView.delegate = self;
    self.oppPickerView.selectedRow = self.oppSelectIndex;
    self.oppPickerView.rowHeight = 40;
    self.oppPickerView.selectedRowFont = [UIFont fontWithName:@"BEBAS" size:30];
    self.oppPickerView.backgroundColor = [UIColor clearColor];
    self.oppPickerView.textColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.oppPickerView.unselectedRowScale = 0.5;
    
    self.scoreArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 100; i++)
    {
        NSString *s = [NSString stringWithFormat:@"%d",(int)i];
        [self.scoreArray addObject:s];
    }
}

- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height+347.f/2);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-347.f/2);
    [self.container.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished)
        {
            [self.container.layer pop_removeAnimationForKey:@"positionAnimation"];
        }};
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished){self.backView.alpha = 1.0f;}};
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
    if (finished)
    {
        [self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
    }};
}

- (void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}


#pragma mark - Action
- (IBAction)actionTapDismiss:(id)sender {
    [GBGameScorePicker hide];
}

- (IBAction)actionCancel:(id)sender {
    [GBGameScorePicker hide];
}

- (IBAction)actionSave:(id)sender {
    [GBGameScorePicker hide];
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(GBGameScorePicker:our:opp:)])
    {
        [self.delegate GBGameScorePicker:self our:self.ourGoal opp:self.oppGoal];
    }
}

-(void)dealloc
{
    [self.backView.layer pop_removeAllAnimations];
    [self.container.layer pop_removeAllAnimations];
}
@end
