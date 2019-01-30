//
//  UIView+YHToast.m
//  GB_Football
//
//  Created by wsw on 16/8/26.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UIView+YHToast.h"

#import <objc/runtime.h>

const static NSInteger kAnimateDuration = 2.5f;

@implementation UIView (YHToast)

- (void)showLoadingToast {

    [self showLoadingToastWithText:nil];
}

- (void)showLoadingToastWithText:(NSString *)text {
    
    [self showHUDWithMode:MBProgressHUDModeIndeterminate text:text delay:-1];
}


- (void)showToastWithText:(NSString *)text {
    
    [self showHUDWithMode:MBProgressHUDModeText text:text delay:kAnimateDuration];
}

//先隐藏之前的toast
- (void)dismissToast {
    
    [MBProgressHUD hideHUDForView:self animated:YES];
}

#pragma mark - Private

- (void)showHUDWithMode:(MBProgressHUDMode)mode
                   text:(NSString*)text
                  delay:(NSInteger)delay {
    
    [self dismissToast];
    
    MBProgressHUD *hud = self.progressHUD;
    hud.mode = mode;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
    
    if (delay > 0) {
        [hud hideAnimated:YES afterDelay:delay];
    }
}

static char kMBProgressHUD;
- (void)setProgressHUD:(MBProgressHUD *)hud {
    
    objc_setAssociatedObject(self, &kMBProgressHUD, hud, OBJC_ASSOCIATION_RETAIN);
}

- (MBProgressHUD *)progressHUD {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    //    MBProgressHUD *hud = objc_getAssociatedObject(self, &kMBProgressHUD);
    //    if (!hud) {
    //        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //        self.progressHUD = hud;
    //    }
    return hud;
}

@end
