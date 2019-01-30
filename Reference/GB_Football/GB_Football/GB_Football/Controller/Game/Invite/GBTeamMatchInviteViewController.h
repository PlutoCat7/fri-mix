//
//  GBTeamMatchInviteViewController.h
//  GB_Football
//
//  Created by gxd on 17/8/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBBaseViewController.h"
#import "TeamRequest.h"

@interface GBTeamMatchInviteViewController : GBBaseViewController

- (instancetype)initWithSelectedList:(NSArray<TeamPalyerInfo *> *)selectedList;

@end
