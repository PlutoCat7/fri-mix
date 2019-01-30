//
//  GBFullGameViewController.h
//  GB_Football
//
//  Created by Pizza on 16/8/23.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "PageViewController.h"
#import "MatchInfo.h"

@interface GBFullGameViewController : PageViewController

@property (nonatomic, copy) void(^didChangeHeatMapDirection)(BOOL direction);
@property (nonatomic, copy) void(^didShowMapTimeRate)(BOOL show);

- (void)refreshWithMatchInfo:(MatchInfo *)matchInfo;

@end
