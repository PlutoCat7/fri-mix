//
//  TeamMatchRecordDataResponseInfo.h
//  GB_Football
//
//  Created by gxd on 17/8/4.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "TeamDataResponseInfo.h"


@interface TeamMatchRecordDataResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<TeamDataPlayerInfo *> *data;

@end
