//
//  GBAlertRemovedView.m
//  GB_Football
//
//  Created by 王时温 on 2017/5/27.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBAlertRemovedView.h"
#import "GBBoxButton.h"

@interface GBAlertRemovedView ()

// 弹出框背景（动画用）
@property (weak, nonatomic) IBOutlet UIView *tipBack;
// 弹出框   （动画用）
@property (weak, nonatomic) IBOutlet UIView *boxView;


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasLabel;
@property (weak, nonatomic) IBOutlet UILabel *kickoutLabel;
@property (weak, nonatomic) IBOutlet GBBoxButton *knowButton;
@end

@implementation GBAlertRemovedView

+ (instancetype)alertWithUserName:(NSString *)userName matchName:(NSString *)matchName {
    
    //防止同时多个弹框
    [GBAlertRemovedView remove];
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBAlertRemovedView" owner:nil options:nil];
    GBAlertRemovedView *alert = [xibArray firstObject];
    [alert localUI];
    alert.backgroundView = alert.tipBack;
    alert.animationView = alert.boxView;
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    alert.userNameLabel.text = userName;
    alert.matchNameLabel.text = matchName;
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    [alert showPopBox];
    
    return alert;
}

+ (void)remove
{
    GBAlertRemovedView *hud = nil;
    NSArray *subViewsArray = [UIApplication sharedApplication].keyWindow.subviews;
    Class hudClass = [GBAlertRemovedView class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertRemovedView *)aView;
        }
    }
    if (hud)[hud removeFromSuperview];
}

- (void)localUI {
    
    self.titleLabel.text = LS(@"common.popbox.title.tip");
    self.hasLabel.text = LS(@"inivte-have-been.title");
    self.kickoutLabel.text = LS(@"inivte-kicked-out-friend.title");
    [self.knowButton setTitle:LS(@"sync.popbox.btn.got.it") forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.userNameLabel.width/self.width>(140.0f/375)) { //用户名最大宽度
            self.userNameLabel.width = (140.0f/375)*self.width;
        }
        self.kickoutLabel.left = self.userNameLabel.right + 10;
    });
}

#pragma mark - Action


- (IBAction)okEvent:(id)sender {
    
    [self hidePopBox];
}

@end
