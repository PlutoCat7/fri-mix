//
//  PageViewController.m
//  GB_Football
//
//  Created by weilai on 16/4/1.
//  Copyright © 2016年 GoBrother. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()
{
    BOOL isInitLoadData;
    
}

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initLoadData {
    if (!isInitLoadData && [self isViewLoaded]) {
        isInitLoadData = YES;
        [self initPageData];
    }
}

- (void)loadData {
    // 不使用这个函数
}

- (void)initPageData {
    
}


@end
