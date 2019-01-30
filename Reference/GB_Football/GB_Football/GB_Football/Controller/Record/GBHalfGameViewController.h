//
//  GBHalfGameViewController.h
//  GB_Football
//
//  Created by Pizza on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PageViewController.h"
#import "MatchInfo.h"

@interface GBHalfGameViewController : PageViewController

@property (nonatomic, assign) BOOL direction;
@property (nonatomic, assign) BOOL showTimeRate;

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo;

@end
