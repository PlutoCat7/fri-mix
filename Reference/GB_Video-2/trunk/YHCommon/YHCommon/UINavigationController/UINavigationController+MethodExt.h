//
//  UINavigationController+MethodExt.h
//  JayApp
//
//  Created by devp on 14-5-16.
//  Copyright (c) 2014年 yanzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MethodExt)

@end

@interface UINavigationController (block)
/**
 *    pushes一个视图控制器到指定的接受者
 *
 *    @param viewController 接受者（需要被push的视图控制器）
 *    @param animated       是否需要动画
 *    @param completion     一个在push完成后被执行的block回调
 */
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
              completion:(dispatch_block_t)completion;

/**
 *    pop到一个指定的接受者
 *
 *    @param viewController 需要被pop停止并显示的视图控制器
 *    @param animated       是否动画
 *    @param completion     一个在pop完成后被执行的block回调
 */
- (void)popToViewController:(UIViewController *)viewController
                   animated:(BOOL)animated
               completion:(dispatch_block_t)completion;

/**
 *    pop一个当前导航栈上的最顶层视图控制器
 *
 *    @param animated   是否动画
 *    @param completion 一个在pop完成后被执行的block回调
 */
- (void)popViewControllerAnimated:(BOOL)animated
                     completion:(dispatch_block_t)completion;

/**
 *    pop到当前导航栈的最后一个视图控制器
 *
 *    @param animated   是否动画
 *    @param completion 一个在pop完成后被执行的block回调
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated
                           completion:(dispatch_block_t)completion;
@end

@interface UINavigationController (UINavigationControllerDelegate)

@end