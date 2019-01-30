//
//  UINavigationController+MethodExt.m
//  JayApp
//
//  Created by devp on 14-5-16.
//  Copyright (c) 2014年 yanzw. All rights reserved.
//

#import "UINavigationController+MethodExt.h"

@implementation UINavigationController (MethodExt)
@end

static dispatch_block_t _completionBlock;
static UIViewController *_viewController;

@implementation UINavigationController (block)
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion {
    [self setCompletionBlock:completion viewController:viewController delegate:self];
    [self pushViewController:_viewController animated:animated];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion {
    [self setCompletionBlock:completion viewController:viewController delegate:self];
    [self popToViewController:_viewController animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated completion:(dispatch_block_t)completion {
    NSUInteger index = [self.viewControllers indexOfObject:self.visibleViewController];
    
    if (index > 0) {
        
        index--;
        UIViewController *viewController = [self.viewControllers objectAtIndex:index];
        
        [self setCompletionBlock:completion viewController:viewController delegate:self];
        [self popToViewController:_viewController animated:animated];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated completion:(dispatch_block_t)completion {
    NSUInteger index = [self.viewControllers indexOfObject:self.visibleViewController];
    
    if (index > 0) {
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:0];
        
        [self setCompletionBlock:completion viewController:viewController delegate:self];
        [self popToRootViewControllerAnimated:animated];
    }
}

- (void)setCompletionBlock:(dispatch_block_t)completion viewController:(UIViewController *)viewController delegate:(id)delegate {
    _completionBlock  = [completion copy];
    _viewController = viewController;
    
    self.delegate = delegate;
}
@end

@implementation UINavigationController (UINavigationControllerDelegate)

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 开启滑动手势
//    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        if ([navigationController.viewControllers count] >= 2) {
//            navigationController.interactivePopGestureRecognizer.enabled = YES;
//        }
//    }
    if ([viewController isEqual:_viewController] && _completionBlock) {
        _completionBlock();
        _viewController = nil;
    }
}
@end