 //
//  SABaseViewController+AnalysisTitle.m
//  TiHouse
//
//  Created by Teen Ma on 2018/4/10.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SABaseViewController+AnalysisTitle.h"
#import <UMAnalytics/MobClick.h>

@implementation SABaseViewController (AnalysisTitle)

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
