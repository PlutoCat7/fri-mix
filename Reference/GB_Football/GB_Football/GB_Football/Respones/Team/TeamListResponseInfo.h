//
//  TeamListResponseInfo.h
//  GB_Football
//
//  Created by gxd on 17/7/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "TeamResponseInfo.h"

@interface TeamListResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<TeamInfo *> *data;

@end
