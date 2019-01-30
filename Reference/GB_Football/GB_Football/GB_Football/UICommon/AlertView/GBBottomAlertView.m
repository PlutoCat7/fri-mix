//
//  GBBottomAlertView.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/7.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBottomAlertView.h"
#import "GBBoxButton.h"

@interface GBBottomAlertView ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *tipMessageStLabel;
@property (weak, nonatomic) IBOutlet GBBoxButton *tipCancelButton;
@property (weak, nonatomic) IBOutlet GBBoxButton *tipYesButton;

@property (nonatomic, copy) void(^handler)(BOOL isSure);

@end

@implementation GBBottomAlertView

+ (instancetype)showWithTitle:(NSString *)title handler:(void(^)(BOOL isSure))handler {
    
    NSArray *xibArray= [[NSBundle mainBundle]loadNibNamed:@"GBBottomAlertView" owner:nil options:nil];
    GBBottomAlertView *alert = xibArray.firstObject;
    alert.handler = handler;
    alert.tipMessageStLabel.text = title;
    alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
    [alert showPopBox];
    
    return alert;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)localizeUI {
    
    [self.tipCancelButton setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [self.tipYesButton setTitle:LS(@"common.btn.yes") forState:UIControlStateNormal];
}

- (void)showPopBox {
    
    self.backgroundView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        self.backgroundView.alpha = 1;
        self.alertView.transform = CGAffineTransformMakeTranslation(0, -196);
    } completion:nil];
}

- (void)hidePopBox {
    
    [UIView animateWithDuration:0.5f animations:^{
        self.backgroundView.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (IBAction)actionCancelAction:(id)sender {
    
    BLOCK_EXEC(self.handler, NO);
    [self hidePopBox];
}

- (IBAction)actionOkAction:(id)sender {
    
    BLOCK_EXEC(self.handler, YES);
    [self hidePopBox];
}

@end
