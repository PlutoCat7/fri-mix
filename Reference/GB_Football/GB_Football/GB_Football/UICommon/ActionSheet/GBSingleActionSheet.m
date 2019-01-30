//
//  GBSingleActionSheet.m
//  GB_Football
//
//  Created by gxd on 17/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBSingleActionSheet.h"
#import "GBBoxButton.h"
#import <pop/POP.h>

@interface GBSingleActionSheet()

@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet GBBoxButton *button1;
@property (weak, nonatomic) IBOutlet GBBoxButton *butttonCancle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) void(^complete)(NSInteger index);

@end

@implementation GBSingleActionSheet

+ (instancetype)showWithTitle:(NSString*)title button1:(NSString*)button1 cancel:(NSString*)cancel
{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBSingleActionSheet" owner:self options:nil];
    for (UIView *view in viewArray) {
        if ([view isKindOfClass:[GBSingleActionSheet class]]) {
            GBSingleActionSheet *sheet = (GBSingleActionSheet *)view;
            sheet.frame = [UIScreen mainScreen].bounds;
            [sheet.titleLabel setText:title];
            [sheet.button1 setTitle:button1 forState:UIControlStateNormal];
            [sheet.butttonCancle setTitle:cancel forState:UIControlStateNormal];
            [keywindow addSubview:sheet];
            return sheet;
        }
    }
    return nil;
}

+ (instancetype)showWithTitle:(NSString*)title button1:(NSString*)button1 cancel:(NSString*)cancel handle:(void(^)(NSInteger index))handle {
    
    GBSingleActionSheet *actionSheet = [self showWithTitle:title button1:button1 cancel:cancel];
    actionSheet.complete = handle;
    
    return actionSheet;
}

+ (BOOL)hide
{
    GBSingleActionSheet *hud = [GBSingleActionSheet HUDForView:[UIApplication sharedApplication].keyWindow];
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


+ (GBSingleActionSheet *)HUDForView: (UIView *)view
{
    GBSingleActionSheet *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBSingleActionSheet class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBSingleActionSheet *)aView;
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
    positionAnimation.toValue   = @([UIScreen mainScreen].bounds.size.height-168/2);
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
    [GBSingleActionSheet hide];
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(GBSingleActionSheet:index:)])
    {
        [self.delegate GBSingleActionSheet:self index:0];
    }
    BLOCK_EXEC(self.complete, 0);
}

- (IBAction)actionPressButtonCancel:(id)sender {
    [GBSingleActionSheet hide];
}
- (IBAction)actionDismiss:(id)sender {
    [GBSingleActionSheet hide];
}

-(void)dealloc
{
    [self.boxView.layer pop_removeAllAnimations];
    [self.backView.layer pop_removeAllAnimations];
}

@end
