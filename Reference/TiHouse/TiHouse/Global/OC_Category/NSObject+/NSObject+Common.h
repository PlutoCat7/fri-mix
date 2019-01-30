//
//  NSObject+Common.h
//  TiHouse
//
//  Created by Confused小伟 on 2017/12/29.
//  Copyright © 2017年 Confused小伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

+ (NSString *)baseURLStr;

+ (BOOL)showError:(NSError *)error;

+ (void)showHudTipStr:(NSString *)tipStr;
+ (void)showHudTipStr:(UIView*)view tipStr:(NSString *)tipStr;
+ (MBProgressHUD *)showHUDQueryStr:(NSString *)titleStr;
+ (MBProgressHUD *)showHUDQuery;
+ (MBProgressHUD *)showHUDQueryStr:(UIView*)view titleStr:(NSString *)titleStr;
+ (NSUInteger)hideHUDQuery;

+ (void)showStatusBarQueryStr:(NSString *)tipStr;
+ (void)showStatusBarSuccessStr:(NSString *)tipStr;
+ (void)showStatusBarErrorStr:(NSString *)errorStr;
@end
