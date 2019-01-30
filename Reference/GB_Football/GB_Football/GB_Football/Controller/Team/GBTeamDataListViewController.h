//
//  GBTeamDataListViewController.h
//  GB_Football
//
//  Created by gxd on 17/7/17.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "PageViewController.h"

#import "GBTeamDataListModel.h"


@interface GBTeamDataListViewController : PageViewController

@property (nonatomic, assign, readonly) GBGameRankType rankType;
@property (nonatomic, strong) GBTeamDataListModel *model;

// 标题和单位
- (instancetype)initWithType:(GBGameRankType)type;

@end
