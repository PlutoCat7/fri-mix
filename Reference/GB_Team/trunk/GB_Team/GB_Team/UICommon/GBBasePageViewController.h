//
//  GBBasePageViewController.h
//  GBUICommon
//
//  Created by 王时温 on 2016/11/17.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface GBBasePageViewController : GBBaseViewController <
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
