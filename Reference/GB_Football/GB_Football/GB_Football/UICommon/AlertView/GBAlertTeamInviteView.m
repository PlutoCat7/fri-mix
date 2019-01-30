//
//  GBAlertTeamInviteView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAlertTeamInviteView.h"
#import "GBAvatorView.h"
#import "GBBoxButton.h"
#import "UIImageView+WebCache.h"

@interface GBAlertTeamInviteView ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet GBAvatorView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameWithConstraint;

//静态国际化
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteTitleLabel;
@property (weak, nonatomic) IBOutlet GBBoxButton *cancelButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *joinButton;

@property (nonatomic, copy) GBAlertViewCallBackBlock alertViewCallBackBlock;

@end

@implementation GBAlertTeamInviteView

+ (instancetype)alertWithImageUrl:(NSString *)imageUrl
                             name:(NSString *)name
                        teamName:(NSString *)teamName
                    CallBackBlock:(GBAlertViewCallBackBlock)alertViewCallBackBlock {
    
    [GBAlertTeamInviteView remove];
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBAlertTeamInviteView" owner:nil options:nil];
    GBAlertTeamInviteView *alert = [xibArray firstObject];
    [alert localUI];
    alert.backgroundView = alert.tipBack;
    alert.animationView = alert.boxView;
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    [alert.avatorView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    CGFloat width = [name widthWithFont:[UIFont systemFontOfSize:14.0f*kAppScale] constrainedToHeight:20];
    if (width>kUIScreen_Width*(110.f/375)) {
        width = kUIScreen_Width*(110.f/375);
    }
    alert.userNameLabel.text = name;
    alert.userNameWithConstraint.constant = width;
    alert.teamNameLabel.text = teamName;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert showPopBox];
    
    return alert;
}

+ (void)remove
{
    GBAlertTeamInviteView *hud = nil;
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class hudClass = [GBAlertTeamInviteView class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertTeamInviteView *)aView;
        }
    }
    if (hud)[hud removeFromSuperview];
}

- (void)localUI {
    
    self.titleLabel.text = LS(@"team.invitation");
    self.inviteTitleLabel.text = LS(@"team.invite.you");
    [self.cancelButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.joinButton setTitle:LS(@"nearby.popbox.btn.join") forState:UIControlStateNormal];
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
