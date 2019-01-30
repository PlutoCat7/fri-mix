//
//  UINavigationController+YHExtension.m
//  YHCommonDemo
//
//  Created by yahua on 16/3/10.
//  Copyright © 2016年 wangsw. All rights reserved.
//

#import "UINavigationController+YHExtension.h"


@implementation UINavigationController (YHExtension)

- (void)yh_pushViewController:(UIViewController *)viewController removeOtherViewController:(UIViewController *)otherViewController animated:(BOOL)animated {
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    [viewControllers removeObject:otherViewController];
    [viewControllers addObject:viewController];
    [self setViewControllers:viewControllers animated:animated];
}

- (void)yh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.topViewController == viewController) {
        return;
    }
    [self pushViewController:viewController animated:animated];
}

- (void)yh_popViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
    if (![viewControllers containsObject:viewController]) {
        return;
    }
    [viewControllers removeObject:viewController];
    [self setViewControllers:viewControllers animated:animated];
}

@end
