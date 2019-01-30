//
//  GBBindPlayerViewController.h
//  GB_Team
//
//  Created by weilai on 16/9/26.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBBasePageViewController.h"
#import "MatchBindInfo.h"

@interface GBBindPlayerViewController : GBBasePageViewController

- (instancetype)initWithMatchBindInfo:(MatchBindInfo *)matchBindInfo;

@end
