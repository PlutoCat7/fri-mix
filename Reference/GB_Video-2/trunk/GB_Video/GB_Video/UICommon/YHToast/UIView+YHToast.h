//
//  UIView+YHToast.h
//  GB_Football
//
//  Created by wsw on 16/8/26.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (YHToast)

@property (nonatomic, strong) MBProgressHUD *progressHUD;

/** 显示loading提示 */
- (void)showLoadingToast;
- (void)showLoadingToastWithText:(NSString *)text;

/** 显示纯文本toast */
- (void)showToastWithText:(NSString *)text;

/** 取消toast */
- (void)dismissToast;

@end
