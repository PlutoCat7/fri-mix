//
//  GBBaseViewController+Empty.h
//  GB_Football
//
//  Created by 王时温 on 2017/1/12.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface GBBaseViewController (Empty) <
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>

/**
 是否需要显示空试图
 */
@property (nonatomic, assign) BOOL isShowEmptyView;

/**
 空视图
 */
@property (nonatomic, strong) __kindof UIScrollView *emptyScrollView;

- (NSString *)emptyTitle;

@end
