//
//  GBAlertTeamHomePageView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAlertTeamHomePageView.h"

@interface GBAlertTeamHomePageView ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBtnConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdBtnConstraint;

@property (nonatomic, copy) GBAlertViewCallBackBlock alertViewCallBackBlock;

@end

@implementation GBAlertTeamHomePageView

+ (instancetype)alertWithFirstName:(NSString *)firstName secondName:(NSString *)secondName handler:(GBAlertViewCallBackBlock)alertViewCallBackBlock {
    
    //防止同时多个弹框
    [GBAlertTeamHomePageView remove];
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBAlertTeamHomePageView" owner:nil options:nil];
    GBAlertTeamHomePageView *alert = [xibArray firstObject];
    [alert localUI];
    alert.backgroundView = alert.tipBack;
    alert.animationView = alert.boxView;
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
    
    [alert.firstButton setTitle:firstName forState:UIControlStateNormal];
    [alert.secondButton setTitle:secondName forState:UIControlStateNormal];
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert showPopBox];
    
    return alert;
}

+ (void)remove
{
    GBAlertTeamHomePageView *hud = nil;
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class hudClass = [GBAlertTeamHomePageView class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertTeamHomePageView *)aView;
        }
    }
    if (hud)[hud removeFromSuperview];
}

- (void)localUI {
    
    [self.thirdButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.firstButton.layer.cornerRadius = self.firstButton.height/2;
        self.secondButton.layer.cornerRadius = self.secondButton.height/2;
        self.thirdButton.layer.cornerRadius = self.thirdButton.height/2;
        if (self.secondButton.titleLabel.text.length==0) {
            self.secondButton.hidden = YES;
            CGFloat padding = (175*kAppScale-self.firstButton.height-self.thirdButton.height)/3;
            self.firstBtnConstraint.constant = padding;
            self.thirdBtnConstraint.constant = padding;
        }
    });
}


#pragma mark - Action

- (IBAction)buttonAction:(id)sender {
    
    [self hidePopBox];
    NSInteger index = 0;
    if (sender == self.firstButton) {
        index = 1;
    }else if (sender == self.secondButton) {
        index = 2;
    }else if (sender == self.thirdButton) {
        index = 0;
    }
    BLOCK_EXEC(self.alertViewCallBackBlock, index);
}


@end
