//
//  UIScrollView+COSEmpty.m
//  CarOilSupermarket
//
//  Created by yahua on 2018/1/21.
//  Copyright © 2018年 王时温. All rights reserved.
//

#import "UIScrollView+COSEmpty.h"
#import <objc/runtime.h>

@implementation UIScrollView (COSEmpty)

static void *kshowEmptyViewKey = &kshowEmptyViewKey;
- (void)showEmptyView:(BOOL)isShow {
    
    UIImageView *emptyImageView = [self emptyImageView];
    if (emptyImageView) {
        if (isShow) {
            [self addSubview:emptyImageView];
        }else {
            [emptyImageView removeFromSuperview];
        }
    }
}

- (UIImageView *)emptyImageView {
    
    UIImageView *imageView = objc_getAssociatedObject(self, kshowEmptyViewKey);
    if (imageView) {
        return imageView;
    }
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 190, 190)];
    imageView.image = [UIImage imageNamed:@"common_empty"];
    imageView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    
    objc_setAssociatedObject(self, kshowEmptyViewKey, imageView, OBJC_ASSOCIATION_RETAIN);
    
    return imageView;
}

@end
