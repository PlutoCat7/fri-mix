//
//  GBAlertLiPiUpdate.m
//  GB_Football
//
//  Created by Pizza on 2017/3/6.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAlertLiPiUpdate.h"
#import <pop/POP.h>
#import "GBBoxButton.h"
#import "GBLipiCountDownButton.h"

#define kUpdateCountDown 15

@interface GBAlertLiPiUpdate()
@property (weak, nonatomic) IBOutlet GBBoxButton *okButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *sheetView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, copy) void (^okBlock)();
@property (nonatomic, copy) void (^cancelBlock)();
@property (nonatomic, copy) NSString *okTitle;
@end


@implementation GBAlertLiPiUpdate
- (IBAction)actionOnClickOk:(id)sender {
    [GBAlertLiPiUpdate hide];
    BLOCK_EXEC(self.okBlock)
}
- (IBAction)actionOnClickCancel:(id)sender {
    [GBAlertLiPiUpdate hide];
    BLOCK_EXEC(self.cancelBlock)
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self setupAnimation];
}

+(GBAlertLiPiUpdate*)showWithTitle:(NSString*)title
                           content:(NSString*)content
                     buttonStrings:(NSArray*)buttonStrings
                              onOk:(void (^)())okBlock
                          onCancel:(void (^)())cancelBlock
{
    GBAlertLiPiUpdate *hud = [GBAlertLiPiUpdate HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)  [GBAlertLiPiUpdate remove];
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBAlertLiPiUpdate" owner:self options:nil];
    for (UIView *view in viewArray)
    {
        if ([view isKindOfClass:[GBAlertLiPiUpdate class]])
        {
            GBAlertLiPiUpdate *sheet = (GBAlertLiPiUpdate *)view;
            sheet.frame = [UIScreen mainScreen].bounds;
            [sheet.titleLabel setText:title];
            sheet.okTitle = [buttonStrings firstObject];
//            sheet.okButton.defaultTitle = sheet.okTitle;
//            [sheet.okButton setTitle:[NSString stringWithFormat:@"%@(%d)",sheet.okTitle,kUpdateCountDown]
//                            forState:UIControlStateNormal];
            [sheet.okButton setTitle:[NSString stringWithFormat:@"%@",sheet.okTitle]
                            forState:UIControlStateNormal];
//            [sheet.okButton startCountDown:kUpdateCountDown];
            sheet.contentLabel.text = content;
            [sheet.cancelButton setTitle:[buttonStrings lastObject] forState:UIControlStateNormal];
            sheet.okBlock = okBlock;
            sheet.cancelBlock = cancelBlock;
            [keywindow addSubview:sheet];
            return sheet;
        }
    }
    return nil;
    
}

+ (BOOL)hide
{
    GBAlertLiPiUpdate *hud = [GBAlertLiPiUpdate HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)
    {
        POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionAnimation.toValue = @([UIScreen mainScreen].bounds.size.height);
        [hud.sheetView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
        {
            if (finished)
            {
                [hud.sheetView.layer pop_removeAnimationForKey:@"positionAnimation"];
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

+ (void)remove
{
    GBAlertLiPiUpdate *hud = [GBAlertLiPiUpdate HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)[hud removeFromSuperview];
}

+ (GBAlertLiPiUpdate *)HUDForView: (UIView *)view
{
    GBAlertLiPiUpdate *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBAlertLiPiUpdate class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertLiPiUpdate *)aView;
        }
    }
    return hud;
}


- (void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupAnimation{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        if(finish)[self.sheetView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.sheetView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished){
        self.backView.alpha = 1.0f;
        if (finished)[self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
    }};
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

-(void)dealloc
{
    [self.sheetView.layer pop_removeAllAnimations];
    [self.backView.layer pop_removeAllAnimations];
}

@end
