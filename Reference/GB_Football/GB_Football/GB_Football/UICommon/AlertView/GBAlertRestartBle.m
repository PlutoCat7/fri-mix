//
//  GBAlertRestartBle.m
//  GB_Football
//
//  Created by gxd on 17/6/19.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAlertRestartBle.h"

#import <pop/POP.h>
#import "RTLabel.h"


#define kUpdateCountDown 15

@interface GBAlertRestartBle()


@property (weak, nonatomic) IBOutlet UIView *sheetView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *updateTitleStLbl;
@property (weak, nonatomic) IBOutlet UILabel *updateSubTitleStLbl;
@property (weak, nonatomic) IBOutlet UILabel *closeBleStLbl;
@property (weak, nonatomic) IBOutlet UILabel *restartBleStLbl;
@property (weak, nonatomic) IBOutlet UILabel *iknowStLbl;

@property (nonatomic, copy) void (^okBlock)();

@end


@implementation GBAlertRestartBle
- (IBAction)actionOnClickOk:(id)sender {
    [GBAlertRestartBle hide];
    BLOCK_EXEC(self.okBlock)
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self setupAnimation];
}

+(GBAlertRestartBle*)showUpdateHint:(void (^)())okBlock;
{
    GBAlertRestartBle *hud = [GBAlertRestartBle HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)  [GBAlertRestartBle remove];
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBAlertRestartBle" owner:self options:nil];
    for (UIView *view in viewArray)
    {
        if ([view isKindOfClass:[GBAlertRestartBle class]])
        {
            GBAlertRestartBle *sheet = (GBAlertRestartBle *)view;
            sheet.frame = [UIScreen mainScreen].bounds;
            sheet.okBlock = okBlock;
            [keywindow addSubview:sheet];
            return sheet;
        }
    }
    return nil;
    
}

+ (BOOL)hide
{
    GBAlertRestartBle *hud = [GBAlertRestartBle HUDForView:[UIApplication sharedApplication].keyWindow];
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
    GBAlertRestartBle *hud = [GBAlertRestartBle HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)[hud removeFromSuperview];
}

+ (GBAlertRestartBle *)HUDForView: (UIView *)view
{
    GBAlertRestartBle *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBAlertRestartBle class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertRestartBle *)aView;
        }
    }
    return hud;
}


- (void)setupUI
{
    self.updateTitleStLbl.text = LS(@"lipi.update.ble.popbox.title");
    self.updateSubTitleStLbl.text = LS(@"lipi.update.ble.popbox.sub.title");
    self.closeBleStLbl.text = LS(@"lipi.update.ble.popbox.close");
    self.restartBleStLbl.text = LS(@"lipi.update.ble.popbox.restart");
    self.iknowStLbl.text = LS(@"lipi.update.ble.popbox.iknow");
    
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
