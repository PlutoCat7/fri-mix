//
//  GBTimeDivisionViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/5/8.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PageViewController.h"
#import "MatchInfo.h"

@interface GBTimeDivisionViewController : PageViewController

@property (nonatomic, assign) BOOL showTimeRate;

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo;

@end
