//
//  BaseController+AnalysisTitle.m
//  HotelGGIOS
//
//  Created by MaTeen on 15/11/25.
//  Copyright © 2015年 MaTeen. All rights reserved.
//

#import "BaseViewController+AnalysisTitle.h"
#import <UMAnalytics/MobClick.h>

@implementation BaseViewController (AnalysisTitle)

- (void)viewDidAppear:(BOOL)animated
{
    if (self.title > 0)
    {
        [MobClick beginLogPageView:self.title];
    }
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.title > 0)
    {
        [MobClick endLogPageView:self.title];
    }
    [super viewDidDisappear:animated];
}


@end
