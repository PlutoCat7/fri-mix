//
//  UIViewController+YHToast.h
//  MagicBean
//
//  Created by yahua on 16/3/11.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (YHToast)

/** 显示loading提示 */
- (void)showLoadingToast;
- (void)showLoadingToastWithText:(NSString *)text;

/** 显示纯文本toast */
- (void)showToastWithText:(NSString *)text;

/** 取消toast */
- (void)dismissToast;

@end
