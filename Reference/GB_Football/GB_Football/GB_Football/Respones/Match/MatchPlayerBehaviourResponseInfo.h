//
//  MatchPlayerBehaviourResponseInfo.h
//  GB_Football
//
//  Created by 王时温 on 2017/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "TeamDataResponseInfo.h"

@interface MatchPlayerBehaviourResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<TeamDataPlayerInfo *> *data;

@end
