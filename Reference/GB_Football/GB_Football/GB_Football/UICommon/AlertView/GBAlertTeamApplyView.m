//
//  GBAlertTeamApplyView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAlertTeamApplyView.h"
#import "GBAvatorView.h"
#import "GBBoxButton.h"
#import "UIImageView+WebCache.h"

@interface GBAlertTeamApplyView ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet GBAvatorView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

//静态国际化
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTitleLabel;
@property (weak, nonatomic) IBOutlet GBBoxButton *cancelButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *joinButton;

@property (nonatomic, copy) GBAlertViewCallBackBlock alertViewCallBackBlock;

@end

@implementation GBAlertTeamApplyView

+ (instancetype)alertWithImageUrl:(NSString *)imageUrl
                             name:(NSString *)name
                    CallBackBlock:(GBAlertViewCallBackBlock)alertViewCallBackBlock {
    
    [GBAlertTeamApplyView remove];
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBAlertTeamApplyView" owner:nil options:nil];
    GBAlertTeamApplyView *alert = [xibArray firstObject];
    [alert localUI];
    alert.backgroundView = alert.tipBack;
    alert.animationView = alert.boxView;
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    [alert.avatorView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    alert.userNameLabel.text = name;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert showPopBox];
    
    return alert;
}

+ (void)remove
{
    GBAlertTeamApplyView *hud = nil;
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class hudClass = [GBAlertTeamApplyView class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertTeamApplyView *)aView;
        }
    }
    if (hud)[hud removeFromSuperview];
}

- (void)localUI {
    
    self.titleLabel.text = LS(@"team.application");
    self.applyTitleLabel.text = LS(@"team.apply");
    [self.cancelButton setTitle:LS(@"common.btn.refuse") forState:UIControlStateNormal];
    [self.joinButton setTitle:LS(@"common.btn.agree") forState:UIControlStateNormal];
}

- (void)dismiss {
    
    [self cancelEvent:nil];
}

#pragma mark - Action

- (IBAction)cancelEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.alertViewCallBackBlock, 0);
}
- (IBAction)okEvent:(id)sender {
    
    [self hidePopBox];
    BLOCK_EXEC(self.alertViewCallBackBlock, 1);
}

@end
