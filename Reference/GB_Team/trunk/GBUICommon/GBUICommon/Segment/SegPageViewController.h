//
//  SegPageViewController.h
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"

@interface SegPageViewController : GBBaseViewController

@property(nonatomic, assign, readonly) BOOL isInitLoadData;

- (void)viewPageDidLoad;

- (void)viewPageDidAppear;

- (void)viewPageDidDisappear;

@end
