//
//  GBActionSheet.m
//  GB_Football
//
//  Created by Pizza on 16/9/6.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBActionSheet.h"
#import "GBBoxButton.h"
#import <pop/POP.h>

@interface GBActionSheet()

// 选择器控件
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet GBBoxButton *button1;
@property (weak, nonatomic) IBOutlet GBBoxButton *button2;
@property (weak, nonatomic) IBOutlet GBBoxButton *butttonCancle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) void(^complete)(NSInteger index);

@end


@implementation GBActionSheet

+ (instancetype)showWithTitle:(NSString*)title button1:(NSString*)button1 button2:(NSString*)button2 cancel:(NSString*)cancel
{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBActionSheet" owner:self options:nil];
    for (UIView *view in viewArray) {
        if ([view isKindOfClass:[GBActionSheet class]]) {
            GBActionSheet *sheet = (GBActionSheet *)view;
            sheet.frame = [UIScreen mainScreen].bounds;
            [sheet.titleLabel setText:title];
            [sheet.button1 setTitle:button1 forState:UIControlStateNormal];
            [sheet.button2 setTitle:button2 forState:UIControlStateNormal];
            [sheet.butttonCancle setTitle:cancel forState:UIControlStateNormal];
            [keywindow addSubview:sheet];
            return sheet;
        }
    }
    return nil;
}

+ (instancetype)showWithTitle:(NSString*)title button1:(NSString*)button1 button2:(NSString*)button2 cancel:(NSString*)cancel handle:(void(^)(NSInteger index))handle {
    
    GBActionSheet *actionSheet = [self showWithTitle:title button1:button1 button2:button2 cancel:cancel];
    actionSheet.complete = handle;
    
    return actionSheet;
}

+ (BOOL)hide
{
    GBActionSheet *hud = [GBActionSheet HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)
    {
        POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionAnimation.toValue = @([UIScreen mainScreen].bounds.size.height);
        [hud.boxView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
        {
            if (finished)
            {
                [hud.boxView.layer pop_removeAnimationForKey:@"positionAnimation"];
                [hud removeFromSuperview];
            }
        };
        POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        opacityAnimation.fromValue = @(1);
        opacityAnimation.toValue   = @(0);
        [hud.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
        {
            if (finished)
            {
                [hud.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
            }
        };
        return YES;
    }
    return NO;
}


+ (GBActionSheet *)HUDForView: (UIView *)view
{
    GBActionSheet *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBActionSheet class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBActionSheet *)aView;
        }
    }
    return hud;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self setupAnimation];
}


- (void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupAnimation{
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.fromValue = @([UIScreen mainScreen].bounds.size.height);
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-229/2);
    [self.boxView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {if (finished){[self.boxView.layer pop_removeAnimationForKey:@"positionAnimation"];}};
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished){
        self.backView.alpha = 1.0f;
        if (finished)[self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
    }};
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (IBAction)actionPressButton1:(id)sender {
    [GBActionSheet hide];
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(GBActionSheet:index:)])
    {
        [self.delegate GBActionSheet:self index:0];
    }
    BLOCK_EXEC(self.complete, 0);
}
- (IBAction)actionPressButton2:(id)sender {
    [GBActionSheet hide];
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(GBActionSheet:index:)])
    {
        [self.delegate GBActionSheet:self index:1];
    }
    BLOCK_EXEC(self.complete, 1);
}
- (IBAction)actionPressButtonCancel:(id)sender {
    [GBActionSheet hide];
}
- (IBAction)actionDismiss:(id)sender {
    [GBActionSheet hide];
}

-(void)dealloc
{
    [self.boxView.layer pop_removeAllAnimations];
    [self.backView.layer pop_removeAllAnimations];
}
@end
