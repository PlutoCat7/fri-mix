//
//  GBBaseViewController+Empty.m
//  GB_Football
//
//  Created by 王时温 on 2017/1/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController+Empty.h"

#import "GBEmptyView.h"

#import <objc/runtime.h>

@implementation GBBaseViewController (Empty)

- (NSString *)emptyTitle {

    return LS(@"暂无数据");
}

#pragma mark - Setter and Getter

static char const * const kIsShowEmptyView = "kIsShowEmptyView";
static char const * const kEmptyViewScrollView = "kEmptyViewScrollView";

- (void)setIsShowEmptyView:(BOOL)isShowEmptyView {
    
    objc_setAssociatedObject(self, kIsShowEmptyView, @(isShowEmptyView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowEmptyView {
    
    NSNumber *value = objc_getAssociatedObject(self, kIsShowEmptyView);
    return [value boolValue];
}

- (void)setEmptyScrollView:(__kindof UIScrollView *)emptyScrollView {
    
    if (!emptyScrollView) {
        return;
    }
    emptyScrollView.emptyDataSetSource = self;
    emptyScrollView.emptyDataSetDelegate = self;
    objc_setAssociatedObject(self, kEmptyViewScrollView, emptyScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__kindof UIScrollView *)emptyScrollView {
    
    return objc_getAssociatedObject(self, kEmptyViewScrollView);
}

#pragma mark - EmptyDataSet delegate

- (UIView*)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (!self.emptyScrollView) {
        return nil;
    }
    GBEmptyView *emptyView = [[[NSBundle mainBundle] loadNibNamed:@"GBEmptyView" owner:nil options:nil] lastObject];
    emptyView.frame = self.emptyScrollView.bounds;
    emptyView.title = [self emptyTitle];;
    return emptyView;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return self.isShowEmptyView;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

@end
