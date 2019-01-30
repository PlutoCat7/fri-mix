//
//  TeamSearchResponseInfo.h
//  GB_Football
//
//  Created by gxd on 17/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponsePageInfo.h"
#import "TeamResponseInfo.h"

@interface TeamSearchResponseInfo : GBResponsePageInfo

@property (nonatomic, strong) NSArray<TeamInfo *> *data;

@end
