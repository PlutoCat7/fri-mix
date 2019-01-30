//
//  UIView+Toast.m
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UIView+Toast.h"
#import <objc/runtime.h>

const static NSInteger kAnimateDuration = 2.5f;

@implementation UIView (Toast)

- (void)showLoadingToast {
    
    [self showToastWithText:nil];
}

- (void)showLoadingToastWithText:(NSString *)text {
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate text:text delay:-1];
}


- (void)showToastWithText:(NSString *)text {
    
    [self showHUDWithMode:MBProgressHUDModeText text:text delay:kAnimateDuration];
}

//先隐藏之前的toast
- (void)dismissToast {
    
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

#pragma mark - Private

- (void)showHUDWithMode:(MBProgressHUDMode)mode
                   text:(NSString*)text
                  delay:(NSInteger)delay {
    
    [self dismissToast];
    
    MBProgressHUD *hud = self.progressHUD;
    hud.mode = mode;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:18.0f];
    
    if (delay > 0) {
        [hud hide:YES afterDelay:delay];
    }
}

static char kMBProgressHUD;
- (void)setProgressHUD:(MBProgressHUD *)hud {
    
    objc_setAssociatedObject(self, &kMBProgressHUD, hud, OBJC_ASSOCIATION_RETAIN);
}

- (MBProgressHUD *)progressHUD {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    return hud;
}

@end
