//
//  GBAlertInviteView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAlertInviteView.h"
#import "GBBoxButton.h"
#import "UIImageView+WebCache.h"


@interface GBAlertInviteView ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressContentLabel;

//静态国际化
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet GBBoxButton *cancelButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *joinButton;

@property (nonatomic, copy) GBAlertViewCallBackBlock alertViewCallBackBlock;

@end

@implementation GBAlertInviteView

+ (instancetype)alertWithImageUrl:(NSString *)imageUrl
                             name:(NSString *)name
                        matchName:(NSString *)matchName
                        courtName:(NSString *)courtName
                    CallBackBlock:(GBAlertViewCallBackBlock)alertViewCallBackBlock {
    
    [GBAlertInviteView remove];
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBAlertInviteView" owner:nil options:nil];
    GBAlertInviteView *alert = [xibArray firstObject];
    [alert localUI];
    alert.backgroundView = alert.tipBack;
    alert.animationView = alert.boxView;
    alert.alertViewCallBackBlock = alertViewCallBackBlock;
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    
    [alert.avatorImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"portrait"]];
    alert.userNameLabel.text = name;
    alert.matchContentLabel.text = matchName;
    alert.addressContentLabel.text = courtName;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert showPopBox];
    
    return alert;
}

+ (void)remove
{
    GBAlertInviteView *hud = nil;
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class hudClass = [GBAlertInviteView class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertInviteView *)aView;
        }
    }
    if (hud)[hud removeFromSuperview];
}

- (void)localUI {
    
    self.titleLabel.text = LS(@"invite.match.invite.title");
    self.matchTitleLabel.text = LS(@"invite-you-attend.title");
    self.addressTitleLabel.text = LS(@"invite-match-address.title");
    [self.cancelButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.joinButton setTitle:LS(@"inivte-join.title") forState:UIControlStateNormal];
}

- (void)dismiss {
    
    [self cancelEvent:nil];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.avatorImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.avatorImageView.layer.cornerRadius = self.avatorImageView.width/2;
    });
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
