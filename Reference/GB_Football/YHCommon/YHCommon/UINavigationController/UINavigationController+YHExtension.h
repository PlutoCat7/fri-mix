//
//  UINavigationController+YHExtension.h
//  YHCommonDemo
//
//  Created by yahua on 16/3/10.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (YHExtension)

/**
 *  @author wangsw, 16-03-10 16:03:31
 *
 *  push时移除已存在的某个控制器
 *
 *  @param viewController      要push的viewcontroller
 *  @param otherViewController 要remove的viewcontroller
 *  @param animated            是否显示动画
 */
- (void)yh_pushViewController:(UIViewController *)viewController removeOtherViewController:(UIViewController *)otherViewController animated:(BOOL)animated;

/**
 *  @author wangsw, 16-03-24 19:03:04
 *
 *  防止多次push
 *
 *  @param viewController 需要push的viewController
 *  @param animated       是否显示动画
 */
- (void)yh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 *  @author wangsw, 16-03-24 19:03:56
 *
 *  防止多次pop
 *
 *  @param viewController 需要pop的viewController
 *  @param animated       是否显示动画
 */
- (void)yh_popViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
