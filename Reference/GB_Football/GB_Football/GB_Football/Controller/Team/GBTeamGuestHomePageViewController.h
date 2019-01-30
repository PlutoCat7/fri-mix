//
//  GBTeamGuestHomePageViewController.h
//  GB_Football
//
//  Created by 王时温 on 2017/7/24.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "TeamResponseInfo.h"

@interface GBTeamGuestHomePageViewController : GBBaseViewController

- (instancetype)initWithTeamId:(NSInteger)teamId;

- (instancetype)initWithTeamInfo:(TeamInfo *)teamInfo;

@end
