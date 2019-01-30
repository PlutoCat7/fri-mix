//
//  SegPageViewController.m
//  GBUICommon
//
//  Created by weilai on 16/9/8.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "SegPageViewController.h"

@interface SegPageViewController ()

@property(nonatomic, assign) BOOL isInitLoadData;

@end

@implementation SegPageViewController

- (instancetype)init {
    if (self = [super init]) {
        self.isInitLoadData = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewPageDidLoad {
    self.isInitLoadData = YES;
    [self loadPageData];
}

- (void)viewPageDidAppear {
    
}

- (void)viewPageDidDisappear {
    
}

// 这个入库是在创建的时候调用viewDidLoad就进入的控制
- (BOOL) isAutoLoadData {
    return NO;
}

// 界面第一次在segmentview里面显示的时候调用
- (void)loadPageData {
}


@end
