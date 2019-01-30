//
//  UIViewController+YHToast.m
//  MagicBean
//
//  Created by yahua on 16/3/11.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "UIViewController+YHToast.h"

#import "UIView+YHToast.h"

@implementation UIViewController (YHToast)

- (void)showLoadingToast {
    
    [self showLoadingToastWithText:nil];
}

- (void)showLoadingToastWithText:(NSString *)text {
    
    [self.view showLoadingToastWithText:text];
}

- (void)showToastWithText:(NSString *)text {
    
    [self.view showToastWithText:text];
}

- (void)dismissToast {
    
    [self.view dismissToast];
}

@end
