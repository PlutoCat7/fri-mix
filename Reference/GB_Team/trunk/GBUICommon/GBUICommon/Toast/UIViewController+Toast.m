//
//  UIViewController+Toast.m
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "UIViewController+Toast.h"
#import "UIView+Toast.h"

@implementation UIViewController (Toast)

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
