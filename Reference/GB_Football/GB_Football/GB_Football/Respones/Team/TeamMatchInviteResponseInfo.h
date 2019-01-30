//
//  TeamMatchInviteResponseInfo.h
//  GB_Football
//
//  Created by gxd on 17/8/3.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBResponseInfo.h"
#import "TeamHomeResponeInfo.h"

@interface TeamMatchInviteResponseInfo : GBResponseInfo

@property (nonatomic, strong) NSArray<TeamPalyerInfo *> *data;

@end
